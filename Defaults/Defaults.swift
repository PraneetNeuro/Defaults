//
//  Defaults.swift
//  Defaults
//
//  Created by Praneet S on 09/03/21.
//

import Foundation

func defaultsProcess(args: [String]) -> Data {
    let defaultsExecutableURL = URL(fileURLWithPath: "/usr/bin/defaults")
    let process = Process()
    let pipeForReadingOutput = Pipe()
    process.executableURL = defaultsExecutableURL
    process.standardOutput = pipeForReadingOutput
    process.arguments = args
    do {
        try process.run()
    } catch {
        print(error)
    }
    return pipeForReadingOutput.fileHandleForReading.readDataToEndOfFile()
}

func readDefaultsFromBundleID(bundleID: String) -> [String: AnyObject]? {
    let defaultsXML = defaultsProcess(args: ["export", bundleID, "-"])
    let defaultsDict = XML_Dict(xmlData: defaultsXML)
    guard let dict = defaultsDict else {
        return nil
    }
    return dict
}

func readTypeOfKey(key: String, bundleID: String) -> String {
    let typeData = defaultsProcess(args: ["read-type", bundleID, key])
    return String(data: typeData, encoding: .utf8) ?? "Unable to read type"
}

func setValueForKey(key: String, value: String, bundleID: String, type: String) {
    print(type)
    var typeToSet: String = "-string"
    if(type.split(separator: " ").count == 3){
        typeToSet = "-\(type.split(separator: " ")[2])"
    }
    print(typeToSet)
    defaultsProcess(args: ["write", bundleID, key, typeToSet, value])
}
