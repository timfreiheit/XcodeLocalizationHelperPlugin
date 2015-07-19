//
//  LocalizationConstantsFileGenerator.swift
//
//  Created by Tim Freiheit on 19.07.15.
//  Copyright (c) 2015 AppGrade. All rights reserved.
//

import Foundation

class LocalizationConstantsFileGenerator {
    
    func generate(keys: Set<String>, className : String) -> String {
        var file = "" +
        "//\n" +
        "//  \(className).swift\n" +
        "//\n" +
        "//  Created By XcodeLocalizationHelperPlugin\n" +
        "//  Generated Source. No not modify\n" +
        "//\n" +
        "\n" +
        "class \(className) {\n " +
        "\n" + generateHelperMethods()
        
        for key in keys {
            file += "\n" + generateVariable(key)
        }
        
        file += "}"
        
        return file
    }
    
    func generateHelperMethods() -> String {
        var v = "" +
        "   private static func localized(key: String, comment: String = \"\") -> String { \n" +
        "       return NSLocalizedString(key, comment: comment) \n" +
        "   }\n"
        return v
    }
    
    func generateVariable(key: String) -> String {
        var v = "" +
        "   static var \(key) : String {\n" +
        "       get { \n" +
        "           return localized( \"\(key)\" ) \n" +
        "       } \n" +
        "   }\n" +
        "\n" +
        "   static func \(key)(comment: String) -> String {\n" +
        "       return localized( \"\(key)\" , comment: comment)\n" +
        "   }\n"
        return v
    }
    
}

//Example Output:

//
//  Strings.swift
//
//  Created by LocalizationHelperPlugin.
//  Generated Source. No not modify
//
class Strings {
    
    private static func localized(key: String,comment: String = "") -> String {
        return NSLocalizedString(key,comment: comment)
    }
    
    static var KEY: String {
        get {
            return localized("KEY")
        }
    }
    
    static func KEY(comment: String) -> String {
        return localized("KEY", comment: comment)
    }
    
}
