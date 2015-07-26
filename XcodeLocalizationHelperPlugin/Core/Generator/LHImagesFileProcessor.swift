//
//  LHImagesFileGenerator.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 23.07.15.
//  Copyright (c) 2015 AppGrade. All rights reserved.
//

import Foundation

class LHImagesFileProcessor {
    func generateFromProject(projectDir : String){
        
        println("generate files for project in: \(projectDir)")
        
        let parser = LHImagesParser()
        var images = parser.searchImages(projectDir);
        images = parser.filterNotValidKeys(images)
        
        var keySet = Set<String>()
        
        for value in images {
            keySet.insert(value.name)
        }
        
        var generator = LHImagesConstantsFileGenerator()
        
        let className = "Images"
        var fileContent = generator.generate(keySet, className: className)
        
        
        var folder = projectDir.stringByAppendingPathComponent(LHPreferences.outputPath)
        if (!NSFileManager.defaultManager().fileExistsAtPath(folder)) {
            NSFileManager.defaultManager() .createDirectoryAtPath(folder, withIntermediateDirectories: false, attributes: nil, error: nil)
        }
        
        var file = folder.stringByAppendingPathComponent("\(className).swift")
        
        // remove current file if needed
        if (!NSFileManager.defaultManager().fileExistsAtPath(file)) {
            NSFileManager.defaultManager().removeItemAtPath(file,error: nil)
        }
        
        var error : NSError?
        fileContent.writeToFile(file, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
        
        if let error = error {
            NSAlert(error: error).runModal()
        }
        
    }
}