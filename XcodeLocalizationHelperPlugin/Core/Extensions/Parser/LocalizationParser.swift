//
//  LocalizationParser.swift
//
//  Created by Tim Freiheit on 19.07.15.
//  Copyright (c) 2015 AppGrade. All rights reserved.
//

import Foundation

let kRegularExpressionPattern: String = "(\"(\\S+.*\\S+)\"|(\\S+.*\\S+))\\s*=\\s*\"(.*)\";$"
let stringLineRegularExpression = NSRegularExpression(pattern: kRegularExpressionPattern, options: nil, error: nil)!

let kVariablePattern : String = "[a-zA-Z_]*"
let variableRegularExpression = NSRegularExpression(pattern: kVariablePattern, options: nil, error: nil)!

/**
 * parses .strings files to their different localizations
 */
class LocalizationParser {
    
    func localizationsFromContentsOfFile(filePath: String) -> [Localization]? {
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
        
        var localizations: [Localization] = []
        
        //var lineOffset = 0
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
                var localization = Localization(key: key, value: value, language: languageDesignation, tableName: tableName)
                localizations.append(localization)
            }
            /*var lineRange: NSRange = (string! as NSString).lineRangeForRange(NSMakeRange(lineOffset, 0))
            lineOffset += lineRange.length*/
            
        })
        return localizations
    }
    
    func readFileContent (filePath: String) -> String? {
        var error: NSError?
        var string = String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: &error)
        if string == nil {
            //println("Count not read \(filePath) using UTF8")
            string = String(contentsOfFile: filePath, encoding: NSUTF16StringEncoding, error: &error)
            if (string == nil) {
                println("\(error?.localizedDescription)")
            }
        }
        return string
    }
    
    /**
     * filters all keys which are not valid variable identifiers
     */
    func filterNotValidKeys(localizations : [Localization]) -> [Localization] {
        return localizations.filter({ (l) in
            
            let range: NSRange = NSMakeRange(0, count(l.key))
            
            var result = variableRegularExpression.matchesInString(l.key, options: nil, range: range) as? [NSTextCheckingResult]
            if let result = result {
                for r in result {
                    if r.range.length == range.length {
                        return true
                    }
                }
            }
            return false
        })
        
    }
}