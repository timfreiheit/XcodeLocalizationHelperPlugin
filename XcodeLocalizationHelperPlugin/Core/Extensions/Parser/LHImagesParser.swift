//
//  LHImagesParser.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 23.07.15.
//  Copyright (c) 2015 AppGrade. All rights reserved.
//

import Foundation

import AppKit

class LHImagesParser {
    
    static let imageTypes = ["png","jpg"]
 
    func searchImages(dir : String) -> [LHImage] {
        
        let ignoredPaths = LHPreferences.ignoredPaths ?? []
        
        var images : [LHImage] = []
        
        let fileManager = NSFileManager.defaultManager()
        let enumerator = fileManager.enumeratorAtPath(dir)!
        
        loop: for element in enumerator {
            if let element  = element as? String {
                
                // check if file should be ignored
                for path in ignoredPaths {
                    if (element.startsWith(path)) {
                        continue loop
                    }
                }
                
                //check if file is an image
                if (LHImagesParser.imageTypes.contains { $0 != nil && element.endWith($0!) }){
                    println(element)
                    var fileName = element.fileNameFromImagePath()
                    var path = dir + "/" + element

                    let image = LHImage(name: fileName, path: path)
                    images.append(image)
                }
            }
        }
        
        return images
    }
    
    /**
    * filters all keys which are not valid variable identifiers
    */
    func filterNotValidKeys(images : [LHImage]) -> [LHImage] {
        return images.filter({ (l) in
            validNameRegularExpression.matchesFully(l.name)
        })
    }
    
}

private extension String {
    func fileNameFromImagePath() -> String {
        
        var fileName : String?
        for component in self.pathComponents {
            
            if (component.endWith(".imageset")) {
                fileName = component.stringByReplacingOccurrencesOfString(".imageset", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                break
            }
            
            if (component.endWith(".appiconset")) {
                fileName = component.stringByReplacingOccurrencesOfString(".appiconset", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                break
            }
            
            if (component.endWith(".launchimage")) {
                fileName = component.stringByReplacingOccurrencesOfString(".launchimage", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                break
            }
            
        }
        
        if (fileName == nil) {
            fileName = self.lastPathComponent.stringByDeletingPathExtension
            // remove @2x, @3x modifiers
            fileName = fileName?.stringByReplacingOccurrencesOfString("@2x", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            fileName = fileName?.stringByReplacingOccurrencesOfString("@3x", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        
        // fileName should never be nil at this point
        return fileName ?? self
    }
}