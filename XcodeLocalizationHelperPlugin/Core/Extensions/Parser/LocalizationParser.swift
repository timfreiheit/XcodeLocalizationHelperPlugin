//
//  LocalizationParser.swift
//
//  Created by Tim Freiheit on 19.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation

/**
 * parses .strings files to their different localizations
 */
class LocalizationParser {
    
    func localizationsFromContentsOfFile(filePath: String) -> [LHLocalization]? {
        var tableName: String? = filePath.lastPathComponent.stringByDeletingPathExtension
        if tableName == nil {
            return nil
        }
        
        var string = readFileContent(filePath)
        
        if string == nil {
            println("Error while reading file")
            return nil
        }
        var pathComponents = filePath.pathComponents
        
        // try to parse the language of the file
        var languageDesignation: String? = nil
        var languageFolder = pathComponents[pathComponents.count - 2];
        if languageFolder.endWith(".lproj") {
            languageDesignation = languageFolder.stringByDeletingPathExtension
        }
        
        var localizations: [LHLocalization] = []
        
        (string! as NSString).enumerateLinesUsingBlock({(line, stop) in
            var keyRange: NSRange?
            var valueRange: NSRange?
            var key: String? = nil
            var value: String? = nil
            
            let range: NSRange = NSMakeRange(0, count(line))
            var result = stringLineRegularExpression.firstMatchInString(line, options: nil, range: range)
            
            // parse key and value from line
            if result?.range.location != NSNotFound && result?.numberOfRanges == 5 {
                keyRange = result?.rangeAtIndex(2)
                if keyRange == nil || keyRange?.location == NSNotFound {
                    keyRange = result?.rangeAtIndex(3)
                }
                valueRange = result?.rangeAtIndex(4)
                if let keyRange = keyRange {
                    key = (line as NSString).substringWithRange(keyRange)
                }
                if let valueRange = valueRange {
                    value = (line as NSString).substringWithRange(valueRange)
                }
            }
            if let key = key , value = value, tableName = tableName {
                var localization = LHLocalization(key: key, value: value, language: languageDesignation, tableName: tableName, fileName: filePath)
                localizations.append(localization)
            }
            
        })
        return localizations
    }
    
    func readFileContent (filePath: String) -> String? {
        var error: NSError?
        var string = String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: &error)
        if string == nil {
            string = String(contentsOfFile: filePath, encoding: NSUTF16StringEncoding, error: &error)
            if (string == nil) {
                println("\(error?.localizedDescription)")
            }
        }
        return string
    }
    
    
    /**
    * search all available .strings files
    */
    func searchLocalizationFiles(dir : String) -> [String] {
        
        var ignoredPaths = LHPreferences.ignoredPaths ?? []
        
        var files: [String] = []
        
        let fileManager = NSFileManager.defaultManager()
        let enumerator = fileManager.enumeratorAtPath(dir)!
        
        loop: for element in enumerator {
            if let element  = element as? String {
                if element.endWith(".strings") {
                    // check if file should be ignored
                    for path in ignoredPaths {
                        if (element.startsWith(path)) {
                            continue loop
                        }
                    }
                    files.append(element)
                }
            }
        }
        
        return files;
    }
    
    /**
     * filters all keys which are not valid variable identifiers
     */
    func filterNotValidKeys(localizations : [LHLocalization]) -> [LHLocalization] {
        return localizations.filter({ (l) in
            validNameRegularExpression.matchesFully(l.key)
        })
    }
}