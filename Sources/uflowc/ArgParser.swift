//
//  ArgParser.swift
//  uflowc
//
//  Created by Naohiro Hamada on 2017/12/24.
//

import Foundation

/**
 * Parser of command line options
 */
final class ArgParser {
    /// Parser singleton instance
    static let shared = ArgParser()
    
    /// Defined arguments for current app
    private var arguments: [Argument] = []
    
    /// Private initializer
    private init() { }
    
    /**
     * Command line argument definition
     */
    struct Argument {
        /// Argument long name
        let longOptionName: String?
        /// Argument short name
        let shortOptionName: String?
        
        /// Description of argument
        let summary: String
        
        /// Default value of argument
        let `default`: String?
        
        /// Whether if argument is required to run current app.
        let required: Bool
        
        /// Number of argument
        /// If argument name is required, number of the argument is 2.
        /// Otherwise, number of the argument is 1 (value only).
        var numberOfComponents: Int {
            if longOptionName == nil && shortOptionName == nil {
                return 1
            }
            return 2
        }
        
        /// Whether if argument requires name label
        var hasOptionName: Bool {
            return longOptionName != nil && shortOptionName != nil
        }
        
        /**
         * Define the required input file.
         *
         * - parameters:
         *   - summary: Description of input file
         * - returns: Input file argument
         */
        static func inputTarget(summary: String = "") -> Argument {
            return Argument(longOptionName: nil,
                            shortOptionName: nil,
                            summary: summary,
                            default: nil,
                            required: true)
        }
        
        /**
         * Define the required argument.
         *
         * - parameters:
         *   - longOptionName: Long argument label
         *   - shortOptionName: Short argument label
         *   - summary: Description of input file
         *   - default: Default value of this argument
         * - returns: Required argument
         */
        static func required(longOptionName: String, shortOptionName: String, summary: String = "", default: String? = nil) -> Argument {
            return Argument(longOptionName: longOptionName,
                            shortOptionName: shortOptionName,
                            summary: summary,
                            default: `default`,
                            required: true)
        }
        
        /**
         * Define the optional argument.
         *
         * - parameters:
         *   - longOptionName: Long argument label
         *   - shortOptionName: Short argument label
         *   - summary: Description of input file
         *   - default: Default value of this argument
         * - returns: Required argument
         */

        static func optional(longOptionName: String, shortOptionName: String, summary: String = "", default: String? = nil) -> Argument {
            return Argument(longOptionName: longOptionName,
                            shortOptionName: shortOptionName,
                            summary: summary,
                            default: `default`,
                            required: false)
        }
        
        private init(longOptionName: String?, shortOptionName: String?, summary: String, default: String?, required: Bool) {
            self.longOptionName = longOptionName
            self.shortOptionName = shortOptionName
            self.summary = summary
            self.default = `default`
            self.required = required
        }
    }

    /**
     * Parsed command line option
     */
    struct Option: CustomStringConvertible, CustomDebugStringConvertible {
        /// Corresponding argument
        let argument: Argument
        /// Argument value
        let value: String
        
        var description: String {
            if !argument.summary.isEmpty {
                return argument.summary + ": " + value
            }
            if let longOptionName = argument.longOptionName {
                return longOptionName + ": " + value
            }
            return value
        }
        
        var debugDescription: String {
            if !argument.summary.isEmpty {
                return argument.summary + ": " + value
            }
            if let longOptionName = argument.longOptionName {
                return longOptionName + ": " + value
            }
            return value
        }
    }

    func set(arguments: [Argument]) {
        self.arguments = arguments
    }
    
    func parse(args: [String]) -> [Option] {
        var args = [String](args.dropFirst())
        var result = [Option]()
        while !args.isEmpty {
            let partial = findMatchedArgument(args: args)
            args = partial.rest
            result.append(partial.option)
        }
        return result
    }
    
    private func findMatchedArgument(args: [String]) -> (rest: [String], option: Option) {
        guard let first = args.first else {
            fatalError("No argument in array")
        }
        let rest = [String](args.dropFirst())
        let matchedArgument = arguments.first(where: {
            if !$0.hasOptionName {
                return false
            }
            guard let longOptionName = $0.longOptionName, let shortOptionName = $0.shortOptionName else {
                abort()
            }
            return first == longOptionName || first == shortOptionName
        })
        if let matchedArgument = matchedArgument {
            guard let argValue = rest.first else {
                fatalError("Option `\(first)` missing value.")
            }
            return ([String](rest.dropFirst()), Option(argument: matchedArgument, value: argValue))
        }
        guard let noNameArgument = arguments.first(where: { !$0.hasOptionName }) else {
            fatalError("Argument without option name is not allowed.")
        }
        return (rest, Option(argument: noNameArgument, value: first))
    }
}
