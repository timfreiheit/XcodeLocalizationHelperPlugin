//
//  TestPlugin.swift
//
//  Created by Tim Freiheit on 17.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import AppKit

let fileManager = NSFileManager.defaultManager()

let documentsPath: NSString = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory,.UserDomainMask,true)?[0] as! NSString


var sharedPlugin: Plugin?

/**
 * Plugin entry point to setup all connections, menus and notificationlisteners
 */
class Plugin: BasePlugin{
    var generateMenuItem = LHGenerateMenuItem()
    var settingsMenuItem = LHSettingsMenuItem()

    override init(bundle: NSBundle) {
        super.init(bundle: bundle)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProjectCompiled:", name: IDENotification.IDEBuildOperationDidGenerateOutputFilesNotification, object: nil)
        
        LHPreferences.registerDefaults()

    }

    /**
     * called when xcode compiled a project
     */
    func onProjectCompiled( noti : NSNotification ){
        if (LHPreferences.runOnBuild == true) {
            var projectDir = IDEKitHelper.currentProjectPath()
            if let projectDir = projectDir {
                
                var stringsGenerator = LHStringsFileGenerator()
                stringsGenerator.generateFromProject(projectDir)
                
                var imagesGenerator = LHImagesFileGenerator()
                imagesGenerator.generateFromProject(projectDir)
            
            }
        }
    }

    override func menuDidChangeItemNotification(noti : NSNotification ){
        super.menuDidChangeItemNotification(noti)
        self.createMenuItemsIfNeeded()
    }
    
    /**
     * set custom menu items to Xcode menu
     * checks if menuitems already exists in the menu
     */
    func createMenuItemsIfNeeded() {
        
        if let item = NSApp.mainMenu??.itemWithTitle("Edit") {
            if ( item.submenu?.itemWithTitle(generateMenuItem.title) == nil ) {
                item.submenu?.addItem(NSMenuItem.separatorItem())
                item.submenu?.addItem(generateMenuItem)
            }
        }
        
        if let item = NSApp.mainMenu??.itemWithTitle("Editor") {
            if ( item.submenu?.itemWithTitle(settingsMenuItem.title) == nil ) {
                item.submenu?.insertItem(settingsMenuItem, atIndex: 0)
            }
        }
    }
    
}

