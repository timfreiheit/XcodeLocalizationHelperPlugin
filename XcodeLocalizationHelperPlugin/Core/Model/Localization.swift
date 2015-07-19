//
//  Localization.swift
//
//  Created by Tim Freiheit on 19.07.15.
//  Copyright (c) 2015 AppGrade. All rights reserved.
//

import Foundation

class Localization : Printable{
    
    var key: String
    var value: String
    var language : String?
    var tableName : String
 
    init(key: String, value: String, language: String?, tableName : String){
        self.key = key
        self.value = value
        self.language = language
        self.tableName = tableName
    }
    
    var description: String {
        get{
            return "Localization{ key:\(key), value: \(value), language: \(language), tableName: \(tableName)}"
        }
    }
    
}