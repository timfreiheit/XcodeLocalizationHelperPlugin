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
    
    var projects : [String:LHProject] = [:]
    
    var generateMenuItem = LHGenerateMenuItem()
    var settingsMenuItem = LHSettingsMenuItem()

    override init(bundle: NSBundle) {
        super.init(bundle: bundle)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProjectCompiled:", name: IDENotification.IDEBuildOperationDidGenerateOutputFilesNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onAnyNotification:", name: nil, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDocumentWillSave:", name: IDENotification.IDEEditorDocumentWillSaveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProjectOpened:", name: IDENotification.PBXProjectDidOpenNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProjectClosed:", name: IDENotification.PBXProjectDidCloseNotification, object: nil)
        
        
        LHPreferences.registerDefaults()

    }
    
    func onDocumentWillSave(noti : NSNotification){
        // notification object needs to be parsed using its description
        
        var description = reflect(noti.object).0.summary
        
        let searchFor = "URL: file://"
        let range = description.rangeOfString(searchFor)
        
        if let range = range {
            let file = description.substringWithRange(
                Range<String.Index>(start: range.endIndex, end: description.endIndex)
            )
            
            // check if file should be ignored
            let ignoredPaths = LHPreferences.ignoredPaths ?? []
            for path in ignoredPaths {
                if (file.startsWith(path)) {
                    return
                }
            }
            
            if file.endWith(".strings") {
                let project = self.getCurrentProject()
                // run after 1 second to wait until the file is saved
                dispatch_after_delay(1, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    println("Updated String Resource: \(file)")
                    project?.updateLocalizationFile(file)
                })
            }
        }
    }
    
    func getCurrentProject() -> LHProject? {
        let path = IDEKitHelper.currentProjectPath()
        if let path = path {
            if projects[path] == nil {
                projects[path] = LHProject(projectPath: path)
            }
        }
        return projects[path]
    }
    
    func onProjectOpened(noti : NSNotification){
        var project = noti.object as? PBXProject
        
        println("Project opened: \(project?.path)")
        println("\(IDEKitHelper.currentProjectPath())")
        
        let path = project?.path.stringByDeletingLastPathComponent
        if let path = path,
            project = project {
            if projects[path] == nil {
                projects[path] = LHProject(project: project)
            }
        }
    }

    func onProjectClosed(noti : NSNotification){
        var project = noti.object as? PBXProject
        println("Project closed: \(project?.path)")
        
        let path = project?.path.stringByDeletingLastPathComponent
        if let path = path {
            projects.removeValueForKey(path)
        }
        
    }
    
    func onAnyNotification(noti : NSNotification ) {
        // search for xcode notifications
    }
    
    /**
     * called when xcode compiled a project
     */
    func onProjectCompiled(noti : NSNotification ){
        if (LHPreferences.runOnBuild == true) {
            var projectDir = IDEKitHelper.currentProjectPath()
            if let projectDir = projectDir {
                
                dispatch_after_delay(1, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    var stringsGenerator = LHStringsFileProcessor()
                    stringsGenerator.generateFromProject(projectDir)
                    
                    var imagesGenerator = LHImagesFileProcessor()
                    imagesGenerator.generateFromProject(projectDir)
                })
            
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

