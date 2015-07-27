//
//  String_Extension.swift
//
//  Created by Tim Freiheit on 19.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation

// Nice helper function for dispatch_after
func dispatch_after_delay(delay: NSTimeInterval, queue: dispatch_queue_t, block: dispatch_block_t) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(time, queue, block)
}

extension String {

    func endWith(s: String) -> Bool {
        var range = self.rangeOfString(s)
        if let range = range {
            return range.endIndex  == self.rangeOfString(self)!.endIndex
        }
        return false
    }
    
    func startsWith(s: String) -> Bool {
        var range = self.rangeOfString(s)
        if let range = range {
            return range.startIndex  == self.rangeOfString(self)!.startIndex
        }
        return false
    }
    
    func toVariableNameFromValidName() -> String {
        return self.stringByReplacingOccurrencesOfString("-", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
            .stringByReplacingOccurrencesOfString(".", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}

extension Array {
    func combine(separator: String) -> String{
        var str : String = ""
        for (idx, item) in enumerate(self) {
            str += "\(item)"
            if idx < self.count-1 {
                str += separator
            }
        }
        return str
    }
    
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
    
    func contains<T>(predicate: (T?) -> Bool) -> Bool {
        return self.filter({predicate($0 as? T)}).count > 0
    }
    
}

extension NSRegularExpression {
    func matchesFully (string: String, options: NSMatchingOptions = nil) -> Bool {
        let range: NSRange = NSMakeRange(0, count(string))
        var result = self.matchesInString(string, options: options, range: range) as? [NSTextCheckingResult]
        if let result = result {
            for r in result {
                if r.range.length == range.length {
                    return true
                }
            }
        }
        return false
    }
}

extension NSFileManager {
    
    func lastModified(file: String) -> NSDate {
        var error : NSError?
        var attrs = self.attributesOfItemAtPath(file, error: &error)
        if let attrs = attrs where error == nil {
            return (attrs[NSFileModificationDate] as? NSDate) ?? NSDate(timeIntervalSince1970: 0)
        }
        return NSDate(timeIntervalSince1970: 0)
    }
    
}