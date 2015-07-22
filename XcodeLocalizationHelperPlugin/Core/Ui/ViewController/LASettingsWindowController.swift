//
//  LASettingsWindowController.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 21.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation

import AppKit

class LHSettingsWindowController : NSWindowController{
    
    @IBOutlet weak var runAtBuildTimeCheckBox: NSButton?
    
    @IBOutlet weak var splitFilesCheckBox: NSButton?
    
    @IBOutlet weak var outputTextField: NSTextField?
    
    @IBOutlet weak var ignoredPathsTextField: NSTextField?
    
    convenience init() {
        self.init(windowNibName: "LHSettingWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.runAtBuildTimeCheckBox?.state = LHPreferences.runOnBuild ? NSOnState : NSOffState
        
        self.splitFilesCheckBox?.state = LHPreferences.splitOutput ? NSOnState : NSOffState
        
        self.outputTextField?.stringValue = LHPreferences.outputPath
        
        var ignoredPaths = LHPreferences.ignoredPaths
        if let ignoredPaths = ignoredPaths {
            self.ignoredPathsTextField?.stringValue = ignoredPaths.combine(";")
        }
        
    }
    
    @IBAction func onSave(sender: NSButton) {
        LHPreferences.runOnBuild = (self.runAtBuildTimeCheckBox?.state == NSOnState)
        LHPreferences.splitOutput = (self.splitFilesCheckBox?.state == NSOnState)
        
        if let outputDir = self.outputTextField?.stringValue {
            LHPreferences.outputPath = outputDir
        }
        
        if let ignoredPaths = self.ignoredPathsTextField?.stringValue {
            var paths = split(ignoredPaths) {$0 == ";"}
            LHPreferences.ignoredPaths = paths
        }
        
    }
    
}