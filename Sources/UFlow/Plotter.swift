//
//  Plotter.swift
//  uflowc
//
//  Created by Naohiro Hamada on 2017/12/31.
//

import Foundation

/**
 * User flow plotter protocol.
 *
 * To draw or render user flow, a class/struct which conforms this protocol is required.
 */
public protocol Plotter {
    /**
     * File extension of output user flow.
     */
    static var fileExtension: String { get }
    
    /**
     * Draw/Render a given user flow to output directory.
     *
     * - parameters:
     *   - document: User flow to draw/render
     *   - outputDirecotyr: Output directory
     */
    func plot(document: Document, to outputDirectory: URL)
}

public enum PlotType {
    case graphviz
}

public final class PlotterBuilder {
    public static func build(for type: PlotType) -> Plotter {
        switch type {
        case .graphviz:
            return GraphVizPlotter()
        }
    }
}
