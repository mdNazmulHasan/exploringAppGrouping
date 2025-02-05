# AppA & AppB Communication using App Groups & URL Schemes

This project demonstrates how to create two iOS apps (**AppA** and **AppB**) that communicate using **App Groups** and **Custom URL Schemes**. AppA launches AppB, and AppB returns a response ("Allow" or "Deny") to AppA before exiting.

## Features
- **AppA contains a button** to open AppB.
- **AppB contains two buttons** (Allow & Deny).
- **AppB saves the user's selection** in `UserDefaults` (shared App Group).
- **AppB then launches AppA** before exiting.
- **AppA reads the stored response** and updates the UI accordingly.

## Prerequisites
- Xcode 14+
- Swift 5+
- iOS 15+

## Setup Instructions

### 1. Enable App Groups
1. In Xcode, go to **Signing & Capabilities** for both AppA and AppB.
2. Add **App Groups** and create a new group (e.g., `group.com.yourcompany.shared`).
3. Ensure both apps use the same group.

### 2. Define URL Schemes
In **Info.plist**, add URL Schemes:
#### **AppA (Info.plist)**
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.yourcompany.appA</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>appA</string>
        </array>
    </dict>
</array>
```
#### **AppB (Info.plist)**
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.yourcompany.appB</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>appB</string>
        </array>
    </dict>
</array>
```

### 3. Implement AppA (Opens AppB & Reads Response)
```swift
import SwiftUI

struct ContentView: View {
    @State private var message = "Waiting for response..."
    @Environment(\.scenePhase) private var scenePhase

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
                readSharedData()
            }
        }
    }

    func openAppB() {
        if let url = URL(string: "appB://open") {
            UIApplication.shared.open(url)
        }
    }

    func readSharedData() {
        if let sharedDefaults = UserDefaults(suiteName: "group.com.yourcompany.shared"),
           let response = sharedDefaults.string(forKey: "appBResponse") {
            DispatchQueue.main.async {
                self.message = "Response: \(response)"
            }
        }
    }
}
```

### 4. Implement AppB (Saves Response & Opens AppA)
```swift
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
        if let sharedDefaults = UserDefaults(suiteName: "group.com.yourcompany.shared") {
            sharedDefaults.set(response, forKey: "appBResponse")
            sharedDefaults.synchronize()
        }
        if let url = URL(string: "appA://response") {
            UIApplication.shared.open(url)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}
```

## How It Works
1. **User taps "Open AppB" in AppA** → AppA opens AppB.
2. **User selects "Allow" or "Deny" in AppB**.
3. **AppB stores the response** in `UserDefaults` (App Group).
4. **AppB opens AppA (`appA://response`) and exits**.
5. **AppA reads the stored response** and updates the text.

## Notes
- This approach ensures seamless communication between two apps without background services.
- **App Groups** enable both apps to share data via `UserDefaults`.
- **Custom URL Schemes** allow AppB to open AppA automatically.

## License
This project is open-source. Feel free to modify and use it in your applications.

---
**Enjoy coding! 🚀**

