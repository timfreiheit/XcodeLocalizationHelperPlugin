//
//  BasePlugin.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 23.07.15.
//  Copyright (c) 2015 AppGrade. All rights reserved.
//

import Foundation

var sharedBasePlugin: BasePlugin?

/**
* base plugin for every plugin
*/
@objc class BasePlugin: NSObject {
    var bundle: NSBundle
    
    init(bundle: NSBundle) {
        self.bundle = bundle
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didApplicationFinishLaunchingNotification:", name: NSApplicationDidFinishLaunchingNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuDidChangeItemNotification:", name: NSMenuDidChangeItemNotification, object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didApplicationFinishLaunchingNotification(noti : NSNotification ){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSApplicationDidFinishLaunchingNotification, object: nil);
    }
    
    func menuDidChangeItemNotification(noti : NSNotification ){
    }
    
}

