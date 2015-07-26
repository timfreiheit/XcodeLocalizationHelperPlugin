//
//  IDEConstants.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 20.07.15.
//  Copyright (c) 2015 AppGrade. All rights reserved.
//

import Foundation

/**
 * some notification names sended from Xcode
 */
class IDENotification {
    
    static let IDEBuildOGet = "IDEBuildOGet"
    static let IDEBuildIssueProviderUpdatedIssuesNotification = "IDEBuildIssueProviderUpdatedIssuesNotification"
    static let IDEBuildIssueProviderUpdatedIssuesNotificationGet = "IDEBuildIssueProviderUpdatedIssuesNotificationGet"
    static let IDEBuildOperationDidGenerateOutputFilesNotification = "IDEBuildOperationDidGenerateOutputFilesNotification"
    
    static let IDESourceControlIDEWillUpdateLocalStatusNotification = "IDESourceControlIDEWillUpdateLocalStatusNotification"
    static let IDESourceControlIDEDidUpdateLocalStatusNotification = "IDESourceControlIDEDidUpdateLocalStatusNotification"
    
    static let IDEEditorDocumentWillCloseNotification = "IDEEditorDocumentWillCloseNotification"
    static let IDEEditorDocumentWillClose_ForNavigableItemCoordinatorEyesOnly_Notification = "IDEEditorDocumentWillClose_ForNavigableItemCoordinatorEyesOnly_Notification"
    static let IDEEditorAreaLastActiveEditorContextDidChangeNotification = "IDEEditorAreaLastActiveEditorContextDidChangeNotification"
    
    static let IDEIntegrityLogDataSourceDidChangeNotification = "IDEIntegrityLogDataSourceDidChangeNotification"
    static let IDEContainerDidOpenContainerNotification = "IDEContainerDidOpenContainerNotification"
    
    static let IDEControlGroupDidChangeNotificationName = "IDEControlGroupDidChangeNotificationName"
    static let IDEVariablesViewDidHide = "IDEVariablesViewDidHide"
    static let IDENavigableItemCoordinatorObjectGraphChangeNotificationGet = "IDENavigableItemCoordinatorObjectGraphChangeNotificationGet"
    static let IDEIndexDidChangeStateNotification = "IDEIndexDidChangeStateNotification"
    
    static let IDEEditorDocumentWillSaveNotification = "IDEEditorDocumentWillSaveNotification"
    
    static let ExecutionEnvironmentLastUserInitiatedBuildCompletedNotification = "ExecutionEnvironmentLastUserInitiatedBuildCompletedNotification"
    
    static let DVTUndoManagerWasResetNotification = "DVTUndoManagerWasResetNotification"
    static let DVTModelObjectGraphWillCoalesceChangesNotification = "DVTModelObjectGraphWillCoalesceChangesNotification"
    static let DVTModelObjectGraphObjectsDidChangeNotificationName = "DVTModelObjectGraphObjectsDidChangeNotificationName"
    static let DVTModelObjectGraphDidCoalesceChangesNotification = "DVTModelObjectGraphDidCoalesceChangesNotification"
    
    static let _NSSurfaceShouldSyncNote = "_NSSurfaceShouldSyncNote"
    static let _NSWindowWillChangeWindowNumber = "_NSWindowWillChangeWindowNumber"
    static let _NSWindowDidChangeWindowNumber = "_NSWindowDidChangeWindowNumber"
    
    static let TSPluginDidLoadNotification = "TSPluginDidLoadNotification"
    
    static let PBXProjectDidOpenNotification = "PBXProjectDidOpenNotification"
    static let PBXProjectDidCloseNotification = "PBXProjectDidCloseNotification"
    
}