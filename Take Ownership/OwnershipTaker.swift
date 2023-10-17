import Foundation
import Security
import ServiceManagement
import SwiftUI

class OwnershipTaker {
    private let fileManager = FileManager.default
    private let takeOwnershipScript = loadTakeOwnershipScript()
    
    func takeOwnership(_ url: URL) -> Bool {
        return changeOwnership(TaskData(path: url.path, userName: NSUserName(), group: "staff"))
    }
    
    private func changeOwnership(_ taskData: TaskData) -> Bool {
        let script = enrichWithUserParams(takeOwnershipScript, taskData)
        if (script.isEmpty) {
            // todo log
            return false
        }
        
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", script]
        task.launch()
        task.waitUntilExit()
        
        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: taskData.path)
            return fileAttributes[.ownerAccountName] as! String == taskData.userName 
                && fileAttributes[.groupOwnerAccountName] as! String == taskData.group
        } catch {
            return false
            // todo log
        }
    }
    
    private func enrichWithUserParams(_ script: String, _ taskData: TaskData) -> String {
        let replacements = [
            "%user": taskData.userName,
            "%group": taskData.group,
            "%path": taskData.path
        ]
        
        var enrichedScript = script
        for (placeholder, value) in replacements {
            enrichedScript = enrichedScript.replacingOccurrences(of: placeholder, with: value)
        }
        
        return enrichedScript
    }
    
    private static func loadTakeOwnershipScript() -> String {
        if let scriptPath = Bundle.main.path(forResource: "takeOwnershipScript", ofType: "txt") {
            do {
                return try String(contentsOfFile: scriptPath, encoding: .utf8)
            } catch {
                print("Error reading script file: \(error)") // todo log error
            }
        }
        return ""
    }
}
