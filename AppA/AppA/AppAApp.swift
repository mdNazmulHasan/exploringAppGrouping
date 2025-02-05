//
//  AppAApp.swift
//  AppA
//
//  Created by Md Nazmul Hasan on 5/2/25.
//

import SwiftUI

@main
struct AppAApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "appA" {
            // Read the response when the app is opened via URL
            NotificationCenter.default.post(name: Notification.Name("UpdateAppA"), object: nil)
        }
        return true
    }
}
