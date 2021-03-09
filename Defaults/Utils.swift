//
//  Utils.swift
//  Defaults
//
//  Created by Praneet S on 09/03/21.
//

import Foundation

func XML_Dict(xmlData: Data) -> [String:AnyObject]? {
    var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
    var dict: [String: AnyObject] = [:]
    do {
        dict = try PropertyListSerialization.propertyList(from: xmlData, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:AnyObject]
        
    } catch {
        print("Error reading plist: \(error), format: \(propertyListFormat)")
    }
    return dict
}
