//
//  LHProject.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 25.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation

class LHProject{
    
    var project: PBXProject?
    var projectPath: String
    
    var images: [LHImage] = []
    
    /**
     * [tablename: localizations]
     */
    var localizations : [String: LHLocalizationTable ] = [:]
    
    convenience init(project: PBXProject){
        self.init(projectPath: project.path.stringByDeletingLastPathComponent)
        self.project = project
    }
    
    init(projectPath: String){
        self.projectPath = projectPath
        self.initImages()
        self.initLocalizations()
    }
    
    private func initImages(){
        let parser = LHImagesParser()
        var images = parser.searchImages(projectPath);
        images = parser.filterNotValidKeys(images)
    }
    
    private func initLocalizations(){
        var parser = LocalizationParser()
        var files = parser.searchLocalizationFiles(projectPath);
        for file in files {
            parseAndAddLocalizationsFromFile(projectPath + "/" + file)
        }
    }
    
    
    /**
     * updates all localizations from selected file
     * and recreate generated files
     */
    func updateLocalizationFile(file : String){
        
        for (key,value) in localizations {
            value.removeAllLocalizationsWithFile(file)
        }
        
        parseAndAddLocalizationsFromFile(file)
        
        generateLocalisationFiles()
    }
    
    private func parseAndAddLocalizationsFromFile(file: String){
        
        var parser = LocalizationParser()
        var values = parser.localizationsFromContentsOfFile(file)
        if let values = values where count(values) > 0 {
            let first = values[0]
            let table = self.localizations[first.tableName] ?? LHLocalizationTable(name: first.tableName)
            
            for value in values {
                table.addLocalization(value)
            }
            localizations[first.tableName] = table
            
        }
    }
    
    /**
     * generates localisation files
     */
    func generateLocalisationFiles(){
        var folder = projectPath.stringByAppendingPathComponent(LHPreferences.outputPath)
        let processor = LHStringsFileProcessor()
        
        var allLocalizations : [LHLocalization] = []
        for (key,value) in localizations {
            allLocalizations += value.getLocalizationsFromBaseLanguage()
        }
        
        processor.createLocalizationFiles(folder, values: allLocalizations)
    }
    
}