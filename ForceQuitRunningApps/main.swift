//
//  main.swift
//  ForceQuitRunningApps
//
//  Created by Eric Smith on 8/25/25.
//

import Foundation
import AppKit

let workspace = NSWorkspace.shared
let runningApps = workspace.runningApplications

// Filter for visible, user-launched apps
let userApps = runningApps.filter { app in
    // Only apps with a bundle identifier (ignore background/system processes)
    guard app.bundleIdentifier != nil else { return false }

    // Only regular, visible GUI apps
    return app.activationPolicy == .regular
}

// If no apps to quit
guard !userApps.isEmpty else {
    print("No user-launched apps to quit.")
    exit(0)
}

// List apps for user confirmation
print("The following apps will be force quit:")
for app in userApps {
    if let name = app.localizedName {
        print("- \(name)")
    }
}

print("\nDo you want to force quit these apps? (y/n): ", terminator: "")
guard let response = readLine(), response.lowercased() == "y" else {
    print("Aborted.")
    exit(0)
}

// Quit apps safely
for app in userApps {
    guard let name = app.localizedName else { continue }
    
    // Attempt normal termination first
    if !app.terminate() {
        _ = app.forceTerminate()
    }
    
    print("Quit: \(name)")
}

print("\n✅ Done. All user-launched apps have been quit safely.")
