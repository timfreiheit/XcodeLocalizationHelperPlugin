//
//  LHImagesConstantsFileGenerator.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 23.07.15.
//  Copyright (c) 2015 AppGrade. All rights reserved.
//

import Foundation

class LHImagesConstantsFileGenerator {
    
    func generate(keys: Set<String>, className : String) -> String {
        var file = "" +
            "//\n" +
            "//  \(className).swift\n" +
            "//\n" +
            "//  Created By XcodeLocalizationHelperPlugin\n" +
            "//  Generated Source. No not modify\n" +
            "//\n" +
            "\n" +
            "class \(className) {\n "
        
        for key in keys {
            file += "\n" + generateVariable(key)
        }
        
        file += "}"
        
        return file
    }
    
    func generateVariable(key: String) -> String {
        
        var name = key.toVariableNameFromValidName()
        
        var v = "" +
            "   static var \(name) : UIImage? {\n" +
            "       get { \n" +
            "           return UIImage(named: \"\(key)\") \n" +
            "       } \n" +
            "   }\n"
        return v
    }
    
}