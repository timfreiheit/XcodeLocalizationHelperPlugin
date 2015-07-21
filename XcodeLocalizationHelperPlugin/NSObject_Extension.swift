//
//  NSObject_Extension.swift
//
//  Created by Tim Freiheit on 17.07.15.
//  Copyright (c) 2015 Tim Freiheit. All rights reserved.
//

import Foundation

extension NSObject {
    class func pluginDidLoad(bundle: NSBundle) {
        let appName = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? NSString
        if appName == "Xcode" {
        	if sharedPlugin == nil {
        		sharedPlugin = Plugin(bundle: bundle)
        	}
        }
    }
}