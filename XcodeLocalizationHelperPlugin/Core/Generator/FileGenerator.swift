//
//  LocalizationConstantsFileGenerator.swift
//
//  Created by Tim Freiheit on 19.07.15.
//  Copyright (c) 2015 AppGrade. All rights reserved.
//

import Foundation

import AppKit


class FileGenerator {
    
    func generateFromProject(projectDir : String){
        
        println("generate files for project in: \(projectDir)")
        
        var values : [Localization] = []
        
        var files = searchLocalizationFiles(projectDir);
        
        var parser = LocalizationParser()
        for file in files {
            var localiztions = parser.localizationsFromContentsOfFile(projectDir + "/" + file)
            if let localiztions = localiztions {
                values += parser.filterNotValidKeys(localiztions)
            }
        }
        
        var folder = projectDir.stringByAppendingPathComponent("Localization")
        if (!NSFileManager.defaultManager().fileExistsAtPath(folder)) {
            NSFileManager.defaultManager() .createDirectoryAtPath(folder, withIntermediateDirectories: false, attributes: nil, error: nil)
        }
        
        self.createLocalizationFiles(folder, values: values)
    
    }
    
    /**
     * generate files from localizations
     */
    func createLocalizationFiles(folder: String, values : [Localization]){
        var tableNames = Set<String>()
        
        for value in values {
            tableNames.insert(value.tableName)
        }
        
        tableNames.insert("Strings")
        
        for tableName in tableNames {
            var fileName = tableName
            println("Table: \(tableName)")
            
            var valuesForTable = values
            if tableName != "Strings" {
                valuesForTable = values.filter({
                    $0.tableName == tableName
                })
                fileName = "Strings\(tableName)"
            }
            var keySet = Set<String>()
            
            for value in valuesForTable {
                keySet.insert(value.key)
            }
            
            var generator = LocalizationConstantsFileGenerator()
            
            let className = fileName
            var fileContent = generator.generate(keySet, className: className)
            
            var file = folder.stringByAppendingPathComponent("\(className).swift")
            
            // remove current file if needed
            if (!NSFileManager.defaultManager().fileExistsAtPath(folder)) {
                NSFileManager.defaultManager().removeItemAtPath(file,error: nil)
            }
            
            var error : NSError?
            fileContent.writeToFile(file, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
            
            if let error = error {
                NSAlert(error: error).runModal()
            }
        }

    }
    
    /**
     * search all available .strings files
     */
    private func searchLocalizationFiles(dir : String) -> [String] {
        
        var files: [String] = []
        
        let fileManager = NSFileManager.defaultManager()
        let enumerator = fileManager.enumeratorAtPath(dir)!
        
        for element in enumerator {
            if let element  = element as? String {
                if element.endWith(".strings") {
                    files += [element]
                }
            }
        }
        
        return files;
    }
    
}