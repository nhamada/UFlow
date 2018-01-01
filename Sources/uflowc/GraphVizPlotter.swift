//
//  GraphVizPlotter.swift
//  uflowc
//
//  Created by Naohiro Hamada on 2017/12/31.
//

import Foundation
import UFlow

public final class GraphVizPlotter: Plotter {
    static var fileExtension: String {
        return ".dot"
    }
    
    static func plot(document: Document, to outputDirectory: URL) {
        let outputFileUrl = outputDirectory.appendingPathComponent(document.documentTitle + GraphVizPlotter.fileExtension)
        
        let contentString = document.fileHeaderString() +
            document.contentString() +
            document.fileFooterString()
        
        try? contentString.write(to: outputFileUrl, atomically: true, encoding: .utf8)
    }
}


fileprivate extension Document {
    var documentTitle: String {
        let baseTitle = info.title
        return baseTitle.replacingOccurrences(of: " ", with: "_")
    }
    
    func fileHeaderString() -> String {
        return
        """
        digraph G {
            graph [
                rankdir="LR";
            ]
            label = "\(info.title)"
        """
    }
    
    func contentString() -> String {
        return screenDefinitionString() + transitionString()
    }
    
    private func screenDefinitionString() -> String {
        let screenDef = screens.reduce("") { (partialResult, current) in
            let screenString =
            """
                "\(current.id)" [
                    label = "\(current.name)\(current.enumerateComponents())\(current.summarySection())";
                    shape = "Mrecord";
                ];
            """
            return partialResult + "\n" + screenString
        }
        let actionDef = screens.reduce("") { (partialResult, current) in
            return partialResult + "\n" + current.enumerateFlowActions()
        }
        return screenDef + actionDef
    }
    
    private func transitionString() -> String {
        let transitions = screens.reduce("") { (partialResult, current) in
            return partialResult + "\n" + current.enumerateFlowTransitions()
        }
        return transitions
    }
    
    func fileFooterString() -> String {
        return
        """
        
        }
        """
    }
}

fileprivate extension Screen {
    func enumerateComponents(separator: String = " | ") -> String {
        guard let components = components else {
            return ""
        }
        return components.reduce("") { (partialResult, current) in
            return partialResult + separator + "\(current.view): \(current.name)"
        }
    }
    
    func enumerateFlowActions() -> String {
        guard let flows = flows else {
            return ""
        }
        return flows.enumerated().reduce("") { (partialResult, current) in
            return partialResult + "\n" + current.element.enumerateActions(for: id, at: current.offset)
        }
    }
    
    func enumerateFlowTransitions() -> String {
        guard let flows = flows else {
            return ""
        }
        return flows.enumerated().reduce("") { (partialResult, current) in
            return partialResult + "\n" + current.element.enumerateTransitions(for: id, at: current.offset)
        }
    }
    
    func summarySection(separator: String = " | ") -> String {
        guard let summary = summary else {
            return ""
        }
        return separator + summary
    }
}

fileprivate extension Screen.Flow {
    func enumerateActions(for screenId: String, at index: Int) -> String {
        return actions.enumerated().reduce("") { (partialResult, current) in
            if !current.element.predicate.needsGraphvizNode {
                return partialResult
            }
            let action =
            """
                "\(current.element.actionNode(for: screenId, flowId: index, at: current.offset))" [
                    label="\(current.element.predicate) \(current.element.object)";
                    shape="cds";
                ];
            """
            return partialResult + "\n" + action
        }
    }
    
    func enumerateTransitions(for screenId: String, at index: Int) -> String {
        guard let first = actions.first else {
            return ""
        }
        if actions.count == 1 {
            return ""
        } else {
            var result = "    \"\(screenId)\" -> \"\(first.actionNode(for: screenId, flowId: index, at: 0))\";"
            for i in 1...(actions.count - 1) {
                result = result + "\n" + "    \"\(actions[i - 1].actionNode(for: screenId, flowId: index, at: i - 1))\" -> \"\(actions[i].actionNode(for: screenId, flowId: index, at: i))\";";
            }
            return result
        }
    }
}

fileprivate extension Screen.Action {
    func actionNode(for screenId: String, flowId: Int, at actionIndex: Int) -> String {
        if predicate.needsGraphvizNode {
            return "\(screenId)-f\(flowId)-a\(actionIndex)"
        } else {
            return object
        }
    }
}

fileprivate extension Screen.Action.Predicate {
    var needsGraphvizNode: Bool {
        switch self {
        case .tap, .type, .open, .close:
            return true
        case .show:
            return false
        }
    }
}
