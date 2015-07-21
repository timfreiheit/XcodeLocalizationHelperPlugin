//
//  LASettingsWindowController.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 21.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation

import AppKit

class LHSettingsWindowController : NSWindowController {
    
    @IBOutlet weak var runAtBuildTimeCheckBox: NSButton?
    
    convenience init() {
        self.init(windowNibName: "LHSettingWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
}