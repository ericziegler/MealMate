//
//  FileUtilities.swift
//

import Foundation

// MARK: - File Handling

func openTextFileNamed(name: String, fileExtension: String) -> String? {
    var result: String?
    if let filePath = Bundle.main.path(forResource: name, ofType: fileExtension) {
        do {
            let contents = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
            result = contents
        } catch {
            print(error)
        }
    }
    return result
}

func directoryExistsAtPath(_ path: String) -> Bool {
    var isDirectory = ObjCBool(true)
    let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
}

func fileExists(at path: String) -> Bool {
    return FileManager.default.fileExists(atPath: path)
}
