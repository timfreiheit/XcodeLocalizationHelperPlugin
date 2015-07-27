//
//  LHImagesConstantsFileGenerator.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 23.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation

class LHImagesConstantsFileGenerator {
    
    func generate(images: [LHImage], className : String) -> String {
        var file = "" +
            "//\n" +
            "//  \(className).swift\n" +
            "//\n" +
            "//  Created By XcodeLocalizationHelperPlugin\n" +
            "//  Generated Source. No not modify\n" +
            "//\n" +
            "\n" +
            "class \(className) {\n "
        
        for image in images {
            file += "\n" + generateVariable(image)
        }
        
        file += "}"
        
        return file
    }
    
    func generateVariable(image: LHImage) -> String {
        
        let key = image.name
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