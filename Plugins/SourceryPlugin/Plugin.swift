import Foundation
import PackagePlugin

// MARK: - SourceryPlugin

@main
struct SourceryPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let sourceryConfigFile = target.directory.appending("Configs/sourcery.yml")
        let generatedSourcesDirectory = context.pluginWorkDirectory
        let executable = try context.tool(named: "Sourcery").path
        let templatesDirectory = executable.removingLastComponent().removingLastComponent().appending("templates")
        let cachePath = generatedSourcesDirectory.appending(subpath: "Cache")
        let generatedPath = generatedSourcesDirectory.appending(subpath: "Generated")

        try FileManager.default.createDirectory(atPath: generatedSourcesDirectory.string, withIntermediateDirectories: true)

        let sourceryCommand = Command.prebuildCommand(
            displayName: "Running Sourcery",
            executable: executable,
            arguments: [
                "--config",
                sourceryConfigFile.string,
                "--cacheBasePath",
                cachePath.string,
            ],
            environment: [
                "TARGET_DIR": target.directory.string,
                "DERIVED_DATA_DIR": generatedPath.string,
                "TEMPLATES_DIR": templatesDirectory.string,
            ],
            outputFilesDirectory: generatedPath
        )
        return [sourceryCommand]
    }
}
