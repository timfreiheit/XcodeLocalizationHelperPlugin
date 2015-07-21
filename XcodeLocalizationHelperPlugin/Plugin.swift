//
//  TestPlugin.swift
//
//  Created by Tim Freiheit on 17.07.15.
//  Copyright (c) 2015 SMF. All rights reserved.
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
    //IDEBuildIssueProviderUpdatedIssuesNotification
    var generateSourceMenu : GenerateLocalizationSourcesMenu

    init(bundle: NSBundle) {
        self.bundle = bundle
        generateSourceMenu = GenerateLocalizationSourcesMenu()
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProjectCompiled:", name: IDENotification.IDEBuildOperationDidGenerateOutputFilesNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didApplicationFinishLaunchingNotification:", name: NSApplicationDidFinishLaunchingNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onProjectCompiled( noti : NSNotification ){
            // TODO
    }
    
    func didApplicationFinishLaunchingNotification( noti : NSNotification ){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSApplicationDidFinishLaunchingNotification, object: nil);
        createMenuItems()
    }

    func createMenuItems() {
        var item = NSApp.mainMenu??.itemWithTitle("Edit")
        if item != nil {
            var actionMenuItem = NSMenuItem(title:"Generate Localization Constants", action:"doMenuAction", keyEquivalent:"")
            actionMenuItem.target = self
            item!.submenu!.addItem(NSMenuItem.separatorItem())
            item!.submenu!.addItem(actionMenuItem)
        }
    }
    
    func doMenuAction() {
        generateSourceMenu.doMenuAction()
    }
}

