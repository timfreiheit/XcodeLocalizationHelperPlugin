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
    var localizations : [String: LHLocalizationTable] = [:]
    
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
            if let tableName = LocalizationParser.tableNameFromFile(file) {
                if let table = self.localizations[tableName] {
                    table.parseAndAddLocalizationsFromFile(file)
                } else {
                    self.localizations[tableName] = LHLocalizationTable(file: file)
                }
            }
        }
    }
    
    /**
     * updates all localizations from selected file
     * and recreate generated files
     */
    func updateLocalizationFile(file : String){
        let tableName = LocalizationParser.tableNameFromFile(file)
        if let tableName = tableName {
            if (self.localizations[tableName] == nil) {
                self.localizations[tableName] = LHLocalizationTable(file: file)
            }
        }
        
        for (key,value) in self.localizations {
            value.updateIfNeeded()
        }
        self.generateLocalisationFiles()
        
    }
    
    /**
     * generates localisation files
     */
    func generateLocalisationFiles(){
        var folder = projectPath.stringByAppendingPathComponent(LHPreferences.outputPath)
        
        var allLocalizations : [LHLocalization] = []
        for (key,value) in localizations {
            allLocalizations += value.getLocalizationsFromBaseLanguage()
        }
        
        let processor = LHStringsFileProcessor()
        processor.createLocalizationFiles(folder, values: allLocalizations)
    }
    
    /**
     * generates alle files for the current project
     */
    func generateFiles(){
        
        for (key,value) in localizations {
            value.updateIfNeeded()
        }
        self.generateLocalisationFiles()
        
        // todo use cached values
        var imagesGenerator = LHImagesFileProcessor()
        imagesGenerator.generateFromProject(projectPath)
        
    }
    
}