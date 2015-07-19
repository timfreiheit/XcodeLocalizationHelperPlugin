XcodeLocalizationHelperPlugin
========================

This Xcode Plugin try to make it easier to work with localized strings by creating Constants for every key in your .strings    

When you are using constants to access localized strings you don't have to worry when you want to rename key or if you have any typos at any position.

## Generate Sources
- Select "Generate Localization Constants" under "Edit".
- All generated Source are now located in PROJECT_DIR/Localization
- add them to your project and your ready

### Example
Localizable.strings
````
"KEY" = "value";
````

Generated file:

```

//
//  Strings.swift
//
//  Created by LocalizationHelperPlugin.
//  Generated Source. No not modify
//
class Strings {
    
    private static func localized(key: String,comment: String = "") -> String {
        return NSLocalizedString(key,comment: comment)
    }
    
    static var KEY: String {
        get {
            return localized("KEY")
        }
    }
    
    static func KEY(comment: String) -> String {
        return localized("KEY", comment: comment)
    }
    
}


```