//
//  AppConfig.swift
//  uflowc
//
//  Created by Naohiro Hamada on 2017/12/25.
//

import Foundation

struct AppConfig {
    struct Argument {
        static let inputFile = ArgParser.Argument.inputTarget(summary: "User flow document")
        static let outputDirectory = ArgParser.Argument.optional(longOptionName: "--output", shortOptionName: "-o", summary: "Output directory", default: "./")
    }
    
    let inputFiles: [String]
    let outputDirectory: URL
}


func build(with options: [ArgParser.Option]) -> AppConfig {
    let inputFiles = options.filter({
        $0.argument.summary == AppConfig.Argument.inputFile.summary
    }).map { $0.value }
    let outputDirectoryPath = options.first(where: {
        $0.argument.summary == AppConfig.Argument.outputDirectory.summary
    })?.value
    let outputDirectory = URL(fileURLWithPath: outputDirectoryPath ?? AppConfig.Argument.outputDirectory.default!)
    return AppConfig(inputFiles: inputFiles, outputDirectory: outputDirectory)
}
