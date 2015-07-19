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
        
        var values = parseLocalizationFiles(projectDir)
        
        var tableNames = Set<String>()
        
        for value in values {
            tableNames.insert(value.tableName)
        }
        
        var folder = projectDir.stringByAppendingPathComponent("Localization")
        if (!NSFileManager.defaultManager().fileExistsAtPath(folder)) {
            NSFileManager.defaultManager() .createDirectoryAtPath(folder, withIntermediateDirectories: false, attributes: nil, error: nil)
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
        
        let readyAlert: NSAlert = NSAlert()
        readyAlert.messageText = "Generation completed"
        readyAlert.informativeText = "Add all files in \(projectDir)/Localization to your project."
        readyAlert.alertStyle = NSAlertStyle.InformationalAlertStyle
        readyAlert.addButtonWithTitle("OK")
        readyAlert.runModal()
    
    }
    
    
    private func parseLocalizationFiles(projectDir : String) -> [Localization] {
        
        var result : [Localization] = []
        
        var files = searchLocalizationFiles(projectDir);
        
        var parser = LocalizationParser()
        for file in files {
            var localiztions = parser.localizationsFromContentsOfFile(projectDir + "/" + file)
            if let localiztions = localiztions {
                result += parser.filterNotValidKeys(localiztions)
            }else {
                println("error while parsing")
            }
        }
        
        return result
    }
    
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