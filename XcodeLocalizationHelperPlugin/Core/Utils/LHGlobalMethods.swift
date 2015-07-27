//
//  LHGlobalMethods.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 27.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation


func measureTime(tag: String, block: () -> ()){
    
    let start = NSDate()
    block();
    let end = NSDate()
    
    let timeInterval: Double = end.timeIntervalSinceDate(start)
    println("Time \(tag): \(timeInterval) seconds")
}