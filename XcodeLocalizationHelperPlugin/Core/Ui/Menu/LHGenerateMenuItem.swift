//
//  LHGenerateMenuItem.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 21.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation

import AppKit

class LHGenerateMenuItem : NSMenuItem {
    
    override convenience init () {
        self.init(title:"Generate Localization Constants", action:"doMenuAction", keyEquivalent:"")
        self.target = self
    }
    
    func doMenuAction(){
        
        var projectDir = IDEKitHelper.currentProjectPath()
        if let projectDir = projectDir {
            var generator = LHStringsFileGenerator()
            generator.generateFromProject(projectDir)
            
            let readyAlert: NSAlert = NSAlert()
            readyAlert.messageText = "Generation completed"
            readyAlert.informativeText = "Add all files in \(LHPreferences.outputPath) to your project."
            readyAlert.alertStyle = NSAlertStyle.InformationalAlertStyle
            readyAlert.addButtonWithTitle("OK")
            readyAlert.runModal()
            
        }else {
            let error = NSError(domain: "No Project open", code:42, userInfo:nil);
            NSAlert(error: error).runModal()
        }
    }
    
}