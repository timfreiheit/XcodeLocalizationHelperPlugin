//  IDEKitHelper.m
//
//  Copyright (c) 2015 Ben Rudhart | www.app-grade.de
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "IDEKitHelper.h"
#import "XcodePrivate.h"


@implementation IDEKitHelper

+ (NSInteger)currentLineNumber {
    id currentEditor = [self currentEditor];

    if ([currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        IDESourceCodeEditor *sourceCodeEditor = currentEditor;

        return [sourceCodeEditor _currentOneBasedLineNubmer];
    } else if ([currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")]) {
        //        IDESourceCodeComparisonEditor *codeComparisonEditor = currentEditor;

        // TODO: get the lineNumber
        return 0;
    }

    return 0;
}

+ (NSString *)currentDocumentPath {
    NSDocument *currentDocument = [self currentDocument];

    return currentDocument.fileURL.path;
}

+ (NSString *)currentFilePath {
    NSString *documentPath = [self currentDocumentPath];
    NSString *projectPath = [self currentProjectPath];

    NSString *filePath = [documentPath stringByReplacingOccurrencesOfString:projectPath withString:@""];

    // remove beginning "/"
    if ([filePath rangeOfString:@"/"].location == 0) {
        return [filePath substringFromIndex:1];
    }

    return filePath;
}

+ (NSString *)currentProjectPath {
    IDEWorkspace *workspace = [self currentWorkspace];
    DVTFilePath *parentFilePath = workspace.representingFilePath.parentFilePath;

    // use parentFilePath.fileURL if file URL is required
    NSString *path = parentFilePath.pathString;

    return path;
}

+ (void)selectAndHighlightLineInCurrentDocument:(NSUInteger)lineNumber {
    DVTTextDocumentLocation *location = [self locationForCurrentDocumentLineNumber:lineNumber];

    if (location != nil) {
        [[self currentEditor] selectAndHighlightDocumentLocations:@[location]];
    }
}

+ (void)switchActiveTabToFile:(NSString *)file {
    NSString *projectPath = [IDEKitHelper projectPath];
    NSString *filePath = [projectPath stringByAppendingString:file];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];

    DVTDocumentLocation *documentLocation = [[DVTDocumentLocation alloc] initWithDocumentURL:fileURL timestamp:nil];
    IDEEditorOpenSpecifier *openSpecifier = [IDEEditorOpenSpecifier structureEditorOpenSpecifierForDocumentLocation:documentLocation
                                                                                                        inWorkspace:[self currentWorkspace]
                                                                                                              error:nil];

    IDEEditorContext *currentEditorContext = [self currentEditorContext];
    [currentEditorContext openEditorOpenSpecifier:openSpecifier];
}

+ (void)setDebuggerHiddenInActiveTab:(BOOL)hidden animated:(BOOL)animated {
    IDEEditorArea *editorArea = self.workspaceWindowController.editorArea;
    [editorArea _setShowDebuggerArea:!hidden animate:animated];
}


#pragma mark - Private

+ (NSString *)projectPath {
    NSString *documentPath = IDEKitHelper.currentDocumentPath;
    NSMutableArray *pathComponents = [documentPath.pathComponents mutableCopy];
    [pathComponents removeLastObject];
    [pathComponents removeLastObject];


    NSString *projectPath = @"";
    for (NSString *pathComponent in pathComponents) {
        projectPath = [projectPath stringByAppendingPathComponent:pathComponent];
    }

    return [projectPath stringByAppendingString:@"/"];
}

+ (IDEWorkspaceDocument *)currentWorkspaceDocument {
    NSWindowController *currentWindowController = [self workspaceWindowController];
    id document = [currentWindowController document];

    if (currentWindowController && [document isKindOfClass:NSClassFromString(@"IDEWorkspaceDocument")]) {
        return (IDEWorkspaceDocument *)document;
    }

    return nil;
}

+ (IDEWorkspaceWindowController *)workspaceWindowController {
    NSWindowController *windowController = [[NSApp keyWindow] windowController];

    if ([windowController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        return (IDEWorkspaceWindowController *)windowController;
    } else {
        NSArray *workspaceWindowControllers = [IDEWorkspaceWindowController workspaceWindowControllers];

        for (IDEWorkspaceWindowController *workspaceWindowController in workspaceWindowControllers) {
            if (workspaceWindowController.window == windowController.window.sheetParent) {
                return workspaceWindowController;
            }
        }
    }

    return nil;
}

+ (IDEEditorContext *)currentEditorContext {
    IDEWorkspaceWindowController *workspaceController = [self workspaceWindowController];
    IDEEditorArea *editorArea = [workspaceController editorArea];

    return [editorArea lastActiveEditorContext];
}

+ (IDEWorkspace *)currentWorkspace {
    return [[self currentWorkspaceDocument] workspace];
}

+ (id)currentEditor {
    IDEWorkspaceWindowController *workspaceController = [self workspaceWindowController];
    IDEEditorArea *editorArea = workspaceController.editorArea;
    IDEEditorContext *editorContext = [editorArea lastActiveEditorContext];

    return [editorContext editor];
}

+ (NSDocument *)currentDocument {
    id currentEditor = [self currentEditor];

    if ([currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        return ((IDESourceCodeEditor *)currentEditor).sourceCodeDocument;
    } else if ([currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")]) {
        return ((IDESourceCodeComparisonEditor *)currentEditor).primaryDocument;
    }

    return nil;
}

+ (NSTextView *)textView {
    id currentEditor = [self currentEditor];

    if ([currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        return [currentEditor textView];
    } else if ([currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")]) {
        return [currentEditor keyTextView];
    }

    return nil;
}

+ (DVTTextDocumentLocation *)locationForCurrentDocumentLineNumber:(NSInteger)lineNumber {
    id currentEditor = [self currentEditor];

    if ([currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        IDESourceCodeEditor *sourceCodeEditor = currentEditor;
        return [sourceCodeEditor _documentLocationForLineNumber:lineNumber];
    } else if ([currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")]) {
        //        IDESourceCodeComparisonEditor *codeComparisonEditor = currentEditor;
        
        // TODO: get the documentation for lineNumber
        return nil;
    }
    
    return nil;
}

@end
