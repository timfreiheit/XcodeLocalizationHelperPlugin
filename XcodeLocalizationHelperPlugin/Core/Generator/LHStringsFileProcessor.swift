//
//  LocalizationConstantsFileGenerator.swift
//
//  Created by Tim Freiheit on 19.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation

import AppKit


class LHStringsFileProcessor {
    
    func generateFromProject(projectDir : String){
        
        println("generate files for project in: \(projectDir)")
        
        var values : [LHLocalization] = []
        
        var parser = LocalizationParser()
        var files = parser.searchLocalizationFiles(projectDir);
        for file in files {
            var localiztions = parser.localizationsFromContentsOfFile(file)
            if let localiztions = localiztions {
                values += parser.filterNotValidKeys(localiztions)
            }
        }
        
        var folder = projectDir.stringByAppendingPathComponent(LHPreferences.outputPath)
        
        self.createLocalizationFiles(folder, values: values)
    
    }
    
    /**
     * generate files from localizations
     */
    func createLocalizationFiles(folder: String, values : [LHLocalization]){
        
        println("createLocalizationFiles: items: \(values.count)")
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(folder)) {
            NSFileManager.defaultManager() .createDirectoryAtPath(folder, withIntermediateDirectories: false, attributes: nil, error: nil)
        }
        
        var tableNames = Set<String>()
        
        if (LHPreferences.splitOutput == true) {
            // generate a constants file for every table
            for value in values {
                tableNames.insert(value.tableName)
            }
        }
        
        // generate a combined file with all localizations
        tableNames.insert("Strings")
        
        for tableName in tableNames {
            var fileName = tableName
            
            var valuesForTable = values
            if tableName != "Strings" {
                valuesForTable = values.filter({
                    $0.tableName == tableName
                })
                fileName = "Strings\(tableName)"
            }
            
            //filter doublicates
            var keySet = Set<String>()
            var values : [LHLocalization] = []
            for value in valuesForTable {
                if (keySet.contains(value.key) == false) {
                    keySet.insert(value.key)
                    values.append(value)
                }
            }
            
            var generator = LHLocalizationConstantsFileGenerator()
            
            let className = fileName
            var fileContent = generator.generate(values, className: className)
            
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
    
}