# HapticFeedback

[![Platforms](https://img.shields.io/badge/platforms-_iOS_|_macOS_|_watchOS-lightgrey.svg?style=flat)](https://developer.apple.com/resources/)
[![SPM supported](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://mit-license.org)

Backward compatibilty for SwiftUI Sensory Feedback API (iOS 17).

## Installation

The implementation is encapsulated in a single file, so you can simply drag the `HapticFeedback.swift` file into your project to use it.

#### Requirements

* iOS 14.0+, macCatalyst 14.0+, macOS 11.0+, watchOS 7.0+
* Swift 5.7

#### Swift Package Manager

To use the `HapticFeedback`, add the following dependency in your `Package.swift`:
```swift
.package(url: "https://github.com/dm-zharov/swift-haptic-feedback.git", from: "1.0.0")
```

Finally, add `import HapticFeedback` to your source code.

##  Quick Start

####  Basic

```swift
struct MyView: View {
    @State private var showAccessory = false

    var body: some View {
        Button("Backword compatible ") {
            showAccessory.toggle()
        }
        .hapticFeedback(.selection, trigger: showAccessory) // Compatible with iOS 14.0, macOS 11.0, watchOS 7.0
        
        Button("System Sensory Feedback API") {
            showAccessory.toggle()
        }
        .sensoryFeedback(.selection, trigger: showAccessory) // Only works on iOS 17.0, macOS 14.0, watchOS 10.0
    }
}
```

####  Basic (UIKit / AppKit / WatchKit)

```swift
HapticFeedbackManager.defaultPerformer.perform(.selection)
```

## Knowledge

* [SwiftUI Sensory Feedback](https://useyourloaf.com/blog/swiftui-sensory-feedback/)
* [NSHapticFeedbackPerformer](https://developer.apple.com/documentation/appkit/nshapticfeedbackperformer)
