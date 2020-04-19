import Foundation
import CoreGraphics
import ArgumentParser


struct AppIconAssigner: ParsableCommand {

    @Argument(
        help: #"Path of an example of a populated App Icon Asset folder, example "…/Assets.xcassets/AppIcon.appiconset""#
    ) var exampleIconSet: String
    @Argument(
        help: "New Icon Files path where to search for new images, example: ~/Desktop/exportedIcons"
    ) var iconFilesPath: String
    @Argument(
        help: #"Target path, example "./Assets.xcassets/AppIcon.appiconset"#
    ) var targetIconSet: String

    func run() throws {
        let exampleFolderURL: URL = URL(fileURLWithPath: self.exampleIconSet, isDirectory: true)
        let iconsFolderURL: URL = URL(fileURLWithPath: self.iconFilesPath, isDirectory: true)
        let targetFolderURL: URL = URL(fileURLWithPath: self.targetIconSet, isDirectory: true)
        let fileManager = FileManager.default

        let exampleContentsJSONURL = exampleFolderURL.appendingPathComponent("Contents.json")
        let contents = try JSONDecoder().decode(Contents.self, from: Data(contentsOf: exampleContentsJSONURL))
        let filesInIconFolder = try fileManager.contentsOfDirectory(at: iconsFolderURL, includingPropertiesForKeys: nil, options: [])

        let imageDescriptions: [ImageFile] = filesInIconFolder.compactMap(ImageFile.init)

        struct Task {
            let entry: ImageEntry
            let candidates: [ImageFile]
            let targetFileURL: URL
        }

        var tasks: [Task] = []

        try fileManager.removeItem(at: targetFolderURL)
        try fileManager.createDirectory(at: targetFolderURL, withIntermediateDirectories: true, attributes: nil)
        // clear directory of any contents

        for neededFile in contents.images {
            let candidates = imageDescriptions.filter { $0.pixelSize == neededFile.pixelSize }
            tasks.append(
                .init(entry: neededFile,
                      candidates: candidates,
                      targetFileURL: targetFolderURL.appendingPathComponent(neededFile.filename)))
        }

        try fileManager.copyItem(at: exampleContentsJSONURL, to: targetFolderURL.appendingPathComponent("Contents.json"))

        for task in tasks {
            guard let firstMatch = task.candidates.first else {
                print("No match found for \(task.entry) with size \(task.entry.pixelSize)")
                continue
            }

            try fileManager.copyItem(at: firstMatch.url, to: task.targetFileURL)
            print("Copied \(firstMatch.url.lastPathComponent) to \(task.targetFileURL.path)")
        }


    }
}

AppIconAssigner.main()
