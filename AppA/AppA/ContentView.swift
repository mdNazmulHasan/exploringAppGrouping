//
//  ContentView.swift
//  AppA
//
//  Created by Md Nazmul Hasan on 5/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var message = "Waiting for response..."
        @Environment(\.scenePhase) private var scenePhase // Detect when AppA becomes active

        var body: some View {
            VStack {
                Text(message)
                    .padding()

                Button("Open AppB") {
                    openAppB()
                }
            }
            .onAppear {
                readSharedData()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    readSharedData() // Refresh response when AppA becomes active
                }
            }
        }

        func openAppB() {
            if let url = URL(string: "appB://open") {
                UIApplication.shared.open(url)
            }
        }

        func readSharedData() {
            if let sharedDefaults = UserDefaults(suiteName: "group.nazmul.shared") {
                if let response = sharedDefaults.string(forKey: "appBResponse") {
                    message = "Response: \(response)"
                }
            }
        }
}

#Preview {
    ContentView()
}
