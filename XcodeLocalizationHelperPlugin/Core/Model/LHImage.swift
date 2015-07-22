//
//  LHImage.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 22.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation

class LHImage {
 
    var name: String
    var path: String
    
    init(name: String, path: String){
        self.name = name
        self.path = path
    }
    
    var description: String {
        get{
            return "LHImage{ name:\(name), path: \(path)}"
        }
    }
}