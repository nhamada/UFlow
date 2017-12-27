//
//  Screen.swift
//  UFlow
//
//  Created by Naohiro Hamada on 2017/12/25.
//

import Foundation

/**
 * Data container for user flow on screen
 */
public struct Screen {
    /**
     * UI Component on screen
     */
    public struct Component: CustomStringConvertible, CustomDebugStringConvertible {
        /// Key definition of dictionary containing UI component
        private enum Keys: String {
            case type = "type"
            case name = "name"
        }
        /// Available UI Component
        public enum View: CustomStringConvertible, CustomDebugStringConvertible {
            /// Text label
            case label
            /// Text field
            case textfield
            /// Button
            case button
            /// View
            case view
            /// Image
            case image
            
            fileprivate init(from string: String) {
                switch string {
                case "label":
                    self = .label
                case "textfield":
                    self = .textfield
                case "button":
                    self = .button
                case "view":
                    self = .view
                case "image":
                    self = .image
                default:
                    fatalError("View matching to `\(string)` is not found.")
                }
            }
            
            public var description: String {
                switch self {
                case .label:
                    return "Label"
                case .textfield:
                    return "Text Field"
                case .button:
                    return "Button"
                case .view:
                    return "View"
                case .image:
                    return "Image"
                }
            }
            
            public var debugDescription: String {
                switch self {
                case .label:
                    return "Label"
                case .textfield:
                    return "Text Field"
                case .button:
                    return "Button"
                case .view:
                    return "View"
                case .image:
                    return "Image"
                }
            }
        }
        /// Name for UI Component
        public let name: String
        /// View type of UI Component
        public let view: View
        
        fileprivate init(from dictionary: [String:Any]) {
            guard let type = dictionary[Keys.type.rawValue] as? String else {
                fatalError("Missing `\(Keys.type.rawValue)`")
            }
            self.view = View(from: type)
            guard let name = dictionary[Keys.name.rawValue] as? String else {
                fatalError("Missing `\(Keys.name.rawValue)`")
            }
            self.name = name
        }
        
        public var description: String {
            return "\(view)[\(name)]"
        }
        
        public var debugDescription: String {
            return "\(view)[\(name)]"
        }
    }
    /// User/System action
    public struct Action: CustomStringConvertible, CustomDebugStringConvertible {
        /// Subject of action
        public enum Subject: CustomStringConvertible, CustomDebugStringConvertible {
            /// When action is initiated by user
            case user
            /// When action is initiated by system or app
            case system
            
            public var description: String {
                switch self {
                case .user:
                    return "User"
                case .system:
                    return "App"
                }
            }
            
            public var debugDescription: String {
                switch self {
                case .user:
                    return "User"
                case .system:
                    return "App"
                }
            }
        }
        /// Predicate of action
        public enum Predicate: CustomStringConvertible, CustomDebugStringConvertible {
            /// Tap UI component
            case tap
            /// Type some text to UI Component
            case type
            /// Show other UI Componet or other screen
            case show
            /// Open URL or other screen
            case open
            /// Close screen
            case close
            
            fileprivate init(from string: String) {
                switch string {
                case "tap":
                    self = .tap
                case "type":
                    self = .type
                case "show":
                    self = .show
                case "open":
                    self = .open
                case "close":
                    self = .close
                default:
                    fatalError("Predicate matching to `\(string)` is not found.")
                }
            }
            
            fileprivate var subject: Subject {
                switch self {
                case .tap, .type:
                    return .user
                case .show, .open, .close:
                    return .system
                }
            }
            
            public var description: String {
                switch self {
                case .tap:
                    return "tap"
                case .type:
                    return "type"
                case .show:
                    return "show"
                case .open:
                    return "open"
                case .close:
                    return "close"
                }
            }
            
            public var debugDescription: String {
                switch self {
                case .tap:
                    return "tap"
                case .type:
                    return "type"
                case .show:
                    return "show"
                case .open:
                    return "open"
                case .close:
                    return "close"
                }
            }
        }
        /// Who activate action
        public let subject: Subject
        /// Activated action
        public let predicate: Predicate
        /// Target of action
        public let object: String
        
        fileprivate init(from string: String) {
            guard let firstSpaceIndex = string.index(where: { $0 == " " } ) else {
                fatalError("Invalid format (no action target): \(string)")
            }
            let firstWord = string.prefix(upTo: firstSpaceIndex)
            self.predicate = Predicate(from: String(firstWord))
            self.subject = predicate.subject
            self.object = String(string.suffix(string.count - firstSpaceIndex.encodedOffset - 1))
        }
        
        public var description: String {
            return "\(subject) \(predicate) \(object)"
        }
        
        public var debugDescription: String {
            return "\(subject) \(predicate) \(object)"
        }
    }
    /// Sequence of actions
    public struct Flow {
        private static let actionSeparator = "->"
        
        public let actions: [Action]
        
        fileprivate init(from string: String) {
            self.actions = string.components(separatedBy: Flow.actionSeparator).map {
                Action(from: $0.trimmingCharacters(in: CharacterSet.whitespaces))
            }
        }
    }
    
    /// Key definition of dictionary containing screen
    private enum Keys: String {
        case id = "id"
        case name = "name"
        case summary = "summary"
        case components = "components"
        case flows = "flows"
    }
    
    /// Screen identifier
    public let id: String
    /// Screen name
    public let name: String
    /// Descirption of screen
    public let summary: String?
    /// UI Components on screen
    public let components: [Component]?
    /// Available user flow on screen
    public let flows: [Flow]?
    
    public init(from dictionary: [String:Any]) {
        guard let id = dictionary[Keys.id.rawValue] as? String else {
            fatalError("Missing `\(Keys.id.rawValue)`")
        }
        self.id = id
        guard let name = dictionary[Keys.name.rawValue] as? String else {
            fatalError("Missing `\(Keys.name.rawValue)`")
        }
        self.name = name
        self.summary = dictionary[Keys.summary.rawValue] as? String
        if let components = dictionary[Keys.components.rawValue] as? [Any] {
            self.components = components.map {
                guard let dic = $0 as? [String:Any] else {
                    fatalError()
                }
                return Component(from: dic)
            }
        } else {
            self.components = nil
        }
        if let flows = dictionary[Keys.flows.rawValue] as? [String] {
            self.flows = flows.map { Flow(from: $0) }
        } else {
            self.flows = nil
        }
    }
}
