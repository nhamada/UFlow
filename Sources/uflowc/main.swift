
ArgParser.shared.set(arguments: [
    .inputTarget(summary: "user flow document"),
    .optional(longOptionName: "--output", shortOptionName: "-o", summary: "Output directory"),
])
let args = ArgParser.shared.parse(args: CommandLine.arguments)
print(args)
