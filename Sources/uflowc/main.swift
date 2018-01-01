import Foundation
import Yams
import UFlow

ArgParser.shared.set(arguments: [
    AppConfig.Argument.inputFile,
    AppConfig.Argument.outputDirectory,
])
let args = ArgParser.shared.parse(args: CommandLine.arguments)
let options = build(with: args)

options.inputFiles.forEach {
    guard let yaml = try? String(contentsOfFile: $0) else {
        abort()
    }
    guard let dictionary = (try? Yams.load(yaml: yaml)) as? [String:Any] else {
        abort()
    }
    let doc = Document(from: dictionary)
    print(doc.info)
    doc.screens.forEach {
        print($0)
    }
    GraphVizPlotter.plot(document: doc, to: options.outputDirectory)
}
