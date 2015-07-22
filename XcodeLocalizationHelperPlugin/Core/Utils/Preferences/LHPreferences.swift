//
//  LHPreferences.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 22.07.15.
//  Copyright (c) 2015 AppGrade. All rights reserved.
//

import Foundation

class LHPreferences {
    
    static func registerDefaults(){
        var plist = NSBundle.mainBundle().pathForResource("defaultPrefs", ofType: "plist")
        if let plist = plist {
            let dic = NSDictionary(contentsOfFile: plist)
            if let dic = dic {
                NSUserDefaults.standardUserDefaults().registerDefaults(dic as [NSObject : AnyObject])
            }
        }
    }
    
    static var runOnBuild : Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(PrefKeys.RunOnBuild)
        }
        
        set(value) {
            NSUserDefaults.standardUserDefaults().setBool(value, forKey: PrefKeys.RunOnBuild)
        }
    }
    
    static var splitOutput : Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(PrefKeys.SplitOutput)
        }
        
        set(value) {
            NSUserDefaults.standardUserDefaults().setBool(value, forKey: PrefKeys.SplitOutput)
        }
    }
    
    static var outputPath : String {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(PrefKeys.OutputPath) ?? "gen"
        }
        
        set(value) {
            NSUserDefaults.standardUserDefaults().setValue(value, forKey: PrefKeys.OutputPath)
        }
    }
    
    static var ignoredPaths : [String]? {
        get {
            return NSUserDefaults.standardUserDefaults().valueForKey(PrefKeys.IgnoredPaths) as? [String]
        }
        
        set(value) {
            NSUserDefaults.standardUserDefaults().setValue(value, forKey: PrefKeys.IgnoredPaths)
        }
    }
    
}