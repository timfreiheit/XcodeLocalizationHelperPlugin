

import AppKit

class GenerateLocalizationSourcesMenu {
    
    func getProjectDir() -> String?{
        return  IDEKitHelper.currentProjectPath();
    }
    
    func doMenuAction(){
        
        var projectDir = getProjectDir()
        if let projectDir = projectDir {
            var generator = FileGenerator()
            generator.generateFromProject(projectDir)
        }else {
            let error = NSError(domain: "No Project open", code:42, userInfo:nil);
            NSAlert(error: error).runModal()
        }
    
    }
    
}