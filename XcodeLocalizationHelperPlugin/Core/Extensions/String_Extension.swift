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