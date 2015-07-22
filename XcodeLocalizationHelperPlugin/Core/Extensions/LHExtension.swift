//
//  String_Extension.swift
//
//  Created by Tim Freiheit on 19.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation

extension String {

    func endWith(s: String) -> Bool {
        var range = self.rangeOfString(s)
        if let range = range {
            return range.endIndex  == self.rangeOfString(self)!.endIndex
        }
        return false
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
}