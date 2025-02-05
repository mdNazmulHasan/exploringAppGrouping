//
//  ContentView.swift
//  AppB
//
//  Created by Md Nazmul Hasan on 5/2/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            VStack {
                Button("Allow") {
                    sendResponseAndReturn(response: "Allowed")
                }
                .padding()

                Button("Deny") {
                    sendResponseAndReturn(response: "Denied")
                }
                .padding()
            }
        }

        func sendResponseAndReturn(response: String) {
            if let sharedDefaults = UserDefaults(suiteName: "group.nazmul.shared") {
                sharedDefaults.set(response, forKey: "appBResponse")
                sharedDefaults.synchronize() // Ensure data is saved
            }
            
            // Open AppA before exiting
            if let url = URL(string: "appA://response") {
                UIApplication.shared.open(url)
            }

            // Delay exit slightly to ensure AppA has time to launch
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
}

#Preview {
    ContentView()
}
