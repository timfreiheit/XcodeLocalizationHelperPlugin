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
class Plugin: NSObject {
    var bundle: NSBundle
    
    var generateMenuItem = LHGenerateMenuItem()
    var settingsMenuItem = LHSettingsMenuItem()

    init(bundle: NSBundle) {
        self.bundle = bundle
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProjectCompiled:", name: IDENotification.IDEBuildOperationDidGenerateOutputFilesNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didApplicationFinishLaunchingNotification:", name: NSApplicationDidFinishLaunchingNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuDidChangeItemNotification:", name: NSMenuDidChangeItemNotification, object: nil)
        
        LHPreferences.registerDefaults()
        
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onProjectCompiled( noti : NSNotification ){
            // TODO
    }
    
    func didApplicationFinishLaunchingNotification(noti : NSNotification ){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSApplicationDidFinishLaunchingNotification, object: nil);
    }

    func menuDidChangeItemNotification(noti : NSNotification ){
        self.createMenuItemsIfNeeded()
    }
    
    /**
     * set custom menu items to Xcode menu
     * checks if menuitems already exists in the menu
     */
    func createMenuItemsIfNeeded() {
        
        var item = NSApp.mainMenu??.itemWithTitle("Edit")
        if let item = item {
            if ( item.submenu?.itemWithTitle(generateMenuItem.title) == nil ) {
                item.submenu?.addItem(NSMenuItem.separatorItem())
                item.submenu?.addItem(generateMenuItem)
            }
        }
        
        item = NSApp.mainMenu??.itemWithTitle("Editor")
        if let item = item {
            if ( item.submenu?.itemWithTitle(settingsMenuItem.title) == nil ) {
                item.submenu?.insertItem(settingsMenuItem, atIndex: 0)
            }
        }
    }
    
}

