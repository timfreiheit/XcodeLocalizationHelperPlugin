//
//  LHLocalizationTable.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 26.07.15.
//  Copyright (c) 2015 AppGrade. All rights reserved.
//

import Foundation

class LHLocalizationTable {
    
    var name: String
    
    var languages : [String: [LHLocalization] ] = [:]
    
    init(name: String){
        self.name = name
    }
    
    func addLocalization(l: LHLocalization){
        var array = languages[l.language] ?? []
        array.append(l)
        languages[l.language] = array
    }
    
    func getLocalizationsFromBaseLanguage() -> [LHLocalization] {
        return languages[BASE_LANGUAGE] ?? []
    }
    
    func removeAllLocalizationsWithFile(file: String){
        for (key,value) in languages {
            languages[key] = value.filter{$0.fileName != file}
        }
    }
    
}