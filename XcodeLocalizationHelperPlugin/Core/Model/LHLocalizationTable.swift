//
//  LHLocalizationTable.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 26.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation

class LHLocalizationTable {
    
    var name: String
    
    var files = Set<String>()
    var languages : [String: [LHLocalization] ] = [:]
    
    var lastModified: NSDate = NSDate(timeIntervalSince1970: 0)
    
    init(name: String){
        self.name = name
    }
    
    init(file: String){
        self.name = LocalizationParser.tableNameFromFile(file) ?? ""
        self.parseAndAddLocalizationsFromFile(file)
    }
    
    func addLocalization(l: LHLocalization){
        var array = self.languages[l.language] ?? []
        array.append(l)
        self.languages[l.language] = array
        
        if (self.files.contains(l.fileName) == false) {
            self.files.insert(l.fileName)
            let lastModified = NSFileManager.defaultManager().lastModified(l.fileName)
            if (self.lastModified.timeIntervalSince1970 < lastModified.timeIntervalSince1970) {
                self.lastModified = lastModified
            }
        }
        
    }
    
    /**
     * updates the strings of all files which are recently updated
     */
    func updateIfNeeded(){
        
        let oldLastModified = self.lastModified
        for file in files {
            let lastModified = NSFileManager.defaultManager().lastModified(file)
            if (lastModified.timeIntervalSince1970 > oldLastModified.timeIntervalSince1970) {
                self.removeAllLocalizationsWithFile(file)
                self.parseAndAddLocalizationsFromFile(file)
            }
        }
        
    }
    
    /**
     * adds all localizations from a given .strings file
     * returns the tablename or empty string
     */
    func parseAndAddLocalizationsFromFile(file: String) {
        
        var parser = LocalizationParser()
        var values = parser.localizationsFromContentsOfFile(file)
        if let values = values where count(values) > 0 {
            let first = values[0]
            
            for value in values {
                self.addLocalization(value)
            }
        
        }
    }
    
    func getLocalizationsFromBaseLanguage() -> [LHLocalization] {
        return self.languages[BASE_LANGUAGE] ?? []
    }
    
    func removeAllLocalizationsWithFile(file: String){
        for (key,value) in self.languages {
            self.languages[key] = value.filter{$0.fileName != file}
        }
    }
    
}