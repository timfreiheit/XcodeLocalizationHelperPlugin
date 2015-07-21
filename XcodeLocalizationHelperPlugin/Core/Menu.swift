

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
            
            let readyAlert: NSAlert = NSAlert()
            readyAlert.messageText = "Generation completed"
            readyAlert.informativeText = "Add all files in \(projectDir)/Localization to your project."
            readyAlert.alertStyle = NSAlertStyle.InformationalAlertStyle
            readyAlert.addButtonWithTitle("OK")
            readyAlert.runModal()
            
        }else {
            let error = NSError(domain: "No Project open", code:42, userInfo:nil);
            NSAlert(error: error).runModal()
        }
    }
    
}