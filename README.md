# HapticFeedback

[![Platforms](https://img.shields.io/badge/platforms-_iOS_|_macOS_|_watchOS-lightgrey.svg?style=flat)](https://developer.apple.com/resources/)
[![SPM supported](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://mit-license.org)

## Features

Backport of SwiftUI Sensory Feedback API (iOS 17).

```swift
// Native API. Only works on iOS 17, macOS 14, watchOS 10
.sensoryFeedback(.selection, trigger: value)

// Backport. Compatible with iOS 14, macOS 11, watchOS 7
.hapticFeedback(.selection, trigger: value)
```

Directly play Haptic Feedback.

```swift
// Determines if device supports haptic feedback
HapticFeedback.isAvailable

// Plays selection feedback
HapticFeedback.selection.play()

// Plays impact feedback
HapticFeedback.impact(weight: .heavy, intensity: 0.5).play()
```

## Installation

The implementation is encapsulated in a single file, so you can simply drag the `HapticFeedback.swift` file into your project to use it.

#### Requirements

* iOS 14.0+, macCatalyst 14.0+, macOS 11.0+, watchOS 7.0+
* Swift 5.9

#### Swift Package Manager

To use the `HapticFeedback`, add the following dependency in your `Package.swift`:
```swift
.package(url: "https://github.com/dm-zharov/haptic-feedback.git", from: "1.0.0")
```

Finally, add `import HapticFeedback` to your source code.

## Usage

#### Trigger On Value Changes

The haptic feedback plays when the trigger values changes.

```swift
struct MyView: View {
    @State private var showAccessory = false

    var body: some View {
        Button("Backport") {
            showAccessory.toggle()
        }
        .hapticFeedback(.selection, trigger: showAccessory)
    }
}
```

#### Trigger With Condition Closure

For more control over when you trigger the feedback use the condition closure version of the view modifier.

```swift
.hapticFeedback(.selection, trigger: showAccessory) { oldValue, newValue in
    return newValue == true
}
```

#### Trigger With Feedback Closure

For control over what feedback plays use the feedback closure version of the view modifier.

```swift
.hapticFeedback(trigger: isFinished) { oldValue, newValue in
    return newValue ? .success : .error
}
```

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Knowledge

* [SwiftUI Sensory Feedback](https://useyourloaf.com/blog/swiftui-sensory-feedback/)
* [NSHapticFeedbackPerformer](https://developer.apple.com/documentation/appkit/nshapticfeedbackperformer)
* [UIFeedbackGenerator](https://developer.apple.com/documentation/uikit/uifeedbackgenerator)
* [WKInterfaceDevice.play(_:)](https://developer.apple.com/documentation/watchkit/wkinterfacedevice/1628128-play)

## Author

Dmitriy Zharov, contact@zharov.dev

## License

HapticFeedback is available under the MIT license. See the [LICENSE file](https://github.com/dm-zharov/haptic-feedback/blob/master/LICENSE) for more info.
