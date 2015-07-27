//
//  LHConstants.swift
//  XcodeLocalizationHelperPlugin
//
//  Created by Tim Freiheit on 22.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation

class PrefKeys {
    static let RunOnBuild = "XcodeLocalizationHelperPlugin_RunOnBuild"
    static let SplitOutput = "XcodeLocalizationHelperPlugin_SplitOutput"
    static let OutputPath = "XcodeLocalizationHelperPlugin_OutputPath"
    static let IgnoredPaths = "XcodeLocalizationHelperPlugin_IgnoredPaths"
}

let kRegularExpressionPattern: String = "(\"(\\S+.*\\S+)\"|(\\S+.*\\S+))\\s*=\\s*\"(.*)\";$"
let stringLineRegularExpression = NSRegularExpression(pattern: kRegularExpressionPattern, options: nil, error: nil)!

let kVariablePattern : String = "[a-zA-Z_][a-zA-Z_]*"
let variableRegularExpression = NSRegularExpression(pattern: kVariablePattern, options: nil, error: nil)!


let kValidNamePattern : String = "[a-zA-Z_][a-zA-Z_\\.\\-]*"
let validNameRegularExpression = NSRegularExpression(pattern: kValidNamePattern, options: nil, error: nil)!


let BASE_LANGUAGE = "Base"