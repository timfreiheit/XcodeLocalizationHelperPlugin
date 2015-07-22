//
//  LHSettingsMenu.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 21.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation


import Foundation

import AppKit

class LHSettingsMenuItem : NSMenuItem {
    
    /**
     * keep reference to WindowController to avoid getting killed
     */
    var windowController : LHSettingsWindowController?
    
    override convenience init () {
        self.init(title:"Localization Helper Settings", action:"doMenuAction", keyEquivalent:"")
        self.target = self
    }
    
    func doMenuAction(){
        // show settings
        self.windowController = LHSettingsWindowController()
        if let window = windowController?.window {
            NSApp.beginSheet(window, completionHandler: { respone in
                self.windowController = nil
            })
        }
        
    }
    
}