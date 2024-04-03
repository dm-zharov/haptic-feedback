#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(WatchKit)
import WatchKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(CoreHaptics)
import CoreHaptics
#endif

/// Represents a type of haptic and/or audio feedback that can be played.
@available(visionOS, unavailable)
public struct HapticFeedback: Equatable, Sendable {
    fileprivate enum FeedbackType: Hashable, Sendable {
        case start
        case stop
        case alignment
        case decrease
        case increase
        case levelChange
        case selection
        case success
        case warning
        case error
        case impactWeight(_ weight: HapticFeedback.Weight, intensity: Double)
        case impactFlexibility(_ flexibility: HapticFeedback.Flexibility, intensity: Double)
    }
    
    fileprivate let type: FeedbackType
    
    private init(type: FeedbackType) {
        self.type = type
    }
    
    /// Indicates that a task or action has completed.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let success = HapticFeedback(type: .success)

    /// Indicates that a task or action has produced a warning of some kind.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let warning = HapticFeedback(type: .warning)

    /// Indicates that an error has occurred.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let error = HapticFeedback(type: .error)
    
    /// Indicates that a UI element’s values are changing.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let selection = HapticFeedback(type: .selection)
    
    /// Indicates that an important value increased above a significant
    /// threshold.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let increase = HapticFeedback(type: .increase)
    
    /// Indicates that an important value decreased below a significant
    /// threshold.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let decrease = HapticFeedback(type: .decrease)

    /// Indicates that an activity started.
    ///
    /// Use this haptic when starting a timer or any other activity that can be
    /// explicitly started and stopped.
    ///
    /// Only plays feedback on watchOS.
    public static let start = HapticFeedback(type: .start)
    
    /// Indicates that an activity stopped.
    ///
    /// Use this haptic when stopping a timer or other activity that was
    /// previously started.
    ///
    /// Only plays feedback on watchOS.
    public static let stop = HapticFeedback(type: .stop)

    /// Indicates the alignment of a dragged item.
    ///
    /// For example, use this pattern in a drawing app when the user drags a
    /// shape into alignment with another shape.
    ///
    /// Only plays feedback on macOS.
    public static let alignment = HapticFeedback(type: .alignment)
    
    /// Indicates movement between discrete levels of pressure.
    ///
    /// For example, as the user presses a fast-forward button on a video
    /// player, playback could increase or decrease and haptic feedback could be
    /// provided as different levels of pressure are reached.
    ///
    /// Only plays feedback on macOS.
    public static let levelChange = HapticFeedback(type: .levelChange)
    
    /// Provides a physical metaphor you can use to complement a visual
    /// experience.
    ///
    /// Use this to provide feedback for UI elements colliding. It should
    /// supplement the user experience, since only some platforms will play
    /// feedback in response to it.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static let impact: HapticFeedback = .impact(weight: .light, intensity: 1.0)

    /// Provides a physical metaphor you can use to complement a visual
    /// experience.
    ///
    /// Use this to provide feedback for UI elements colliding. It should
    /// supplement the user experience, since only some platforms will play
    /// feedback in response to it.
    ///
    /// Not all platforms will play different feedback for different weights and
    /// intensities of impact.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static func impact(weight: HapticFeedback.Weight, intensity: Double = 1.0) -> HapticFeedback {
        HapticFeedback(type: .impactWeight(weight, intensity: intensity))
    }

    /// Provides a physical metaphor you can use to complement a visual
    /// experience.
    ///
    /// Use this to provide feedback for UI elements colliding. It should
    /// supplement the user experience, since only some platforms will play
    /// feedback in response to it.
    ///
    /// Not all platforms will play different feedback for different
    /// flexibilities and intensities of impact.
    ///
    /// Only plays feedback on iOS and watchOS.
    public static func impact(flexibility: HapticFeedback.Flexibility, intensity: Double = 1.0) -> HapticFeedback {
        HapticFeedback(type: .impactFlexibility(flexibility, intensity: intensity))
    }
}

@available(visionOS, unavailable)
extension HapticFeedback {

    /// The weight to be represented by a type of feedback.
    ///
    /// `Weight` values can be passed to
    /// `SensoryFeedback.impact(flexibility:intensity:)`.
    public enum Weight: Equatable, Sendable {

        /// Indicates a collision between small or lightweight UI objects.
        case light

        /// Indicates a collision between medium-sized or medium-weight UI
        /// objects.
        case medium

        /// Indicates a collision between large or heavyweight UI objects.
        case heavy
    }
}

@available(visionOS, unavailable)
extension HapticFeedback {

    /// The flexibility to be represented by a type of feedback.
    ///
    /// `Flexibility` values can be passed to
    /// `SensoryFeedback.impact(flexibility:intensity:)`.
    public enum Flexibility: Equatable, Sendable {

        /// Indicates a collision between hard or inflexible UI objects.
        case rigid

        /// Indicates a collision between solid UI objects of medium
        /// flexibility.
        case solid

        /// Indicates a collision between soft or flexible UI objects.
        case soft
    }
}

@available(visionOS, unavailable)
extension HapticFeedback {
    /// A Boolean value that indicates whether the device supports haptic feedback.
    public static var isAvailable: Bool {
        #if !os(watchOS)
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
        #else
        true
        #endif
    }
    
    /// Gives haptic feedback to the user.
    ///
    /// Haptic feedback is played only:
    /// - On a device with a supported Taptic Engine.
    /// - When the app is running in the foreground.
    /// - When the System Haptics setting is enabled.
    #if os(iOS) || targetEnvironment(macCatalyst)
    @MainActor
    #endif
    public func play() {
        HapticFeedbackManager.defaultPerformer.perform(type)
    }
}

#if canImport(SwiftUI)
@available(visionOS, unavailable)
private struct FeedbackGenerator<T>: ViewModifier where T: Equatable {
    private let trigger: T
    private let feedback: HapticFeedback
    private let condition: ((T, T) -> Bool)?
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            content.sensoryFeedback(SensoryFeedback(feedback.type), trigger: trigger) { oldValue, newValue in
                if let condition {
                    return condition(oldValue, newValue)
                } else {
                    return true
                }
            }
        } else {
            content.onChange(of: trigger) { [oldValue = trigger] newValue in
                if let condition, !condition(oldValue, newValue) {
                    return
                } else {
                    feedback.play()
                }
            }
        }
    }
    
    init(trigger: T, feedback: HapticFeedback, condition: ((T, T) -> Bool)? = nil) {
        self.trigger = trigger
        self.feedback = feedback
        self.condition = condition
    }
}

@available(visionOS, unavailable)
private struct CustomFeedbackGenerator<T>: ViewModifier where T: Equatable {
    private let trigger: T
    private let feedback: (T, T) -> HapticFeedback?
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            content.sensoryFeedback(trigger: trigger) { oldValue, newValue in
                if let feedback = feedback(oldValue, newValue) {
                    return SensoryFeedback(feedback.type)
                } else {
                    return nil
                }
            }
        } else {
            content.onChange(of: trigger) { [oldValue = trigger] newValue in
                if let feedback = feedback(oldValue, newValue) {
                    feedback.play()
                }
            }
        }
    }
    
    init(trigger: T, feedback: @escaping (T, T) -> HapticFeedback?) {
        self.trigger = trigger
        self.feedback = feedback
    }
}

@available(visionOS, unavailable)
extension View {
    /// Plays the specified `feedback` when the provided `trigger` value
    /// changes.
    ///
    /// For example, you could play feedback when a state value changes:
    ///
    ///     struct MyView: View {
    ///         @State private var showAccessory = false
    ///
    ///         var body: some View {
    ///             ContentView()
    ///                 .hapticFeedback(.selection, trigger: showAccessory)
    ///                 .onLongPressGesture {
    ///                     showAccessory.toggle()
    ///                 }
    ///
    ///             if showAccessory {
    ///                 AccessoryView()
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - feedback: Which type of feedback to play.
    ///   - trigger: A value to monitor for changes to determine when to play.
    public func hapticFeedback<T>(_ feedback: HapticFeedback, trigger: T) -> some View where T : Equatable {
        modifier(FeedbackGenerator(trigger: trigger, feedback: feedback))
    }

    /// Plays the specified `feedback` when the provided `trigger` value changes
    /// and the `condition` closure returns `true`.
    ///
    /// For example, you could play feedback for certain state transitions:
    ///
    ///     struct MyView: View {
    ///         @State private var phase = Phase.inactive
    ///
    ///         var body: some View {
    ///             ContentView(phase: $phase)
    ///                 .hapticFeedback(.selection, trigger: phase) { old, new in
    ///                     old == .inactive || new == .expanded
    ///                 }
    ///         }
    ///
    ///         enum Phase {
    ///             case inactive
    ///             case preparing
    ///             case active
    ///             case expanded
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - feedback: Which type of feedback to play.
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///   - condition: A closure to determine whether to play the feedback when
    ///     `trigger` changes.
    public func hapticFeedback<T>(
        _ feedback: HapticFeedback,
        trigger: T,
        condition: @escaping (T, T) -> Bool
    ) -> some View where T : Equatable {
        modifier(FeedbackGenerator(trigger: trigger, feedback: feedback, condition: condition))
    }

    /// Plays feedback when returned from the `feedback` closure after the
    /// provided `trigger` value changes.
    ///
    /// For example, you could play different feedback for different state
    /// transitions:
    ///
    ///     struct MyView: View {
    ///         @State private var phase = Phase.inactive
    ///
    ///         var body: some View {
    ///             ContentView(phase: $phase)
    ///                 .hapticFeedback(trigger: phase) { old, new in
    ///                     switch (old, new) {
    ///                         case (.inactive, _): return .success
    ///                         case (_, .expanded): return .impact
    ///                         default: return nil
    ///                     }
    ///                 }
    ///         }
    ///
    ///         enum Phase {
    ///             case inactive
    ///             case preparing
    ///             case active
    ///             case expanded
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///   - feedback: A closure to determine whether to play the feedback and
    ///     what type of feedback to play when `trigger` changes.
    public func hapticFeedback<T>(
        trigger: T,
        _ feedback: @escaping (T, T) -> HapticFeedback?
    ) -> some View where T : Equatable {
        modifier(CustomFeedbackGenerator(trigger: trigger, feedback: feedback))
    }
}
#endif

@available(visionOS, unavailable)
/// A set of methods and constants that a haptic feedback performer implements.
private protocol HapticFeedbackPerformer {
    /// Initiates a specific pattern of haptic feedback to the user.
    /// - Parameter feedback: A pattern of feedback to be provided to the user. For possible values, see `HapticFeedback`.
    func perform(_ feedbackType: HapticFeedback.FeedbackType)
}

/// An object that provides access to the haptic feedback management attributes.
@available(visionOS, unavailable)
private class HapticFeedbackManager {
    /// Requests a haptic feedback performer object that is based on the current device, accessibility settings, and user preferences.
    static var defaultPerformer: any HapticFeedbackPerformer {
        #if os(iOS) || targetEnvironment(macCatalyst)
        return _UIHapticFeedbackPerformer.shared
        #elseif os(macOS)
        return _NSHapticFeedbackPerformer.shared
        #elseif os(watchOS)
        return _WKHapticFeedbackPerformer.shared
        #else
        return _GenericFeedbackPerformer()
        #endif
    }
}

#if os(iOS) || targetEnvironment(macCatalyst)
private final class _UIHapticFeedbackPerformer: HapticFeedbackPerformer {
    private let _cache: [HapticFeedback.FeedbackType: UIFeedbackGenerator] = [:]

    @MainActor
    func perform(_ feedbackType: HapticFeedback.FeedbackType) {
        switch feedbackType {
        case .success:
            let feedbackGenerator = _cache[feedbackType, default: UINotificationFeedbackGenerator()] as? UINotificationFeedbackGenerator
            feedbackGenerator?.notificationOccurred(.success)
        case .warning:
            let feedbackGenerator = _cache[feedbackType, default: UINotificationFeedbackGenerator()] as? UINotificationFeedbackGenerator
            feedbackGenerator?.notificationOccurred(.warning)
        case .error:
            let feedbackGenerator = _cache[feedbackType, default: UINotificationFeedbackGenerator()] as? UINotificationFeedbackGenerator
            feedbackGenerator?.notificationOccurred(.error)
        case .selection, .increase, .decrease:
            let feedbackGenerator = _cache[feedbackType, default: UISelectionFeedbackGenerator()] as? UISelectionFeedbackGenerator
            feedbackGenerator?.selectionChanged()
        case let .impactWeight(weight, intensity):
            let feedbackGenerator = _cache[feedbackType, default: UIImpactFeedbackGenerator(style: .init(weight))] as? UIImpactFeedbackGenerator
            feedbackGenerator?.impactOccurred(intensity: intensity)
        case let .impactFlexibility(flexibility, intensity):
            let feedbackGenerator = _cache[feedbackType, default: UIImpactFeedbackGenerator(style: .init(flexibility))] as? UIImpactFeedbackGenerator
            feedbackGenerator?.impactOccurred(intensity: intensity)
        default:
            return
        }
        
        _cache[feedbackType]?.prepare()
    }
    
    static let shared = _UIHapticFeedbackPerformer()
    private init() {}
}

extension UIImpactFeedbackGenerator.FeedbackStyle {
    fileprivate init(_ weight: HapticFeedback.Weight) {
        switch weight {
        case .heavy:
            self = .heavy
        case .medium:
            self = .medium
        case .light:
            self = .light
        }
    }
    
    fileprivate init(_ flexibility: HapticFeedback.Flexibility) {
        switch flexibility {
        case .rigid:
            self = .rigid
        case .solid:
            self = .medium
        case .soft:
            self = .soft
        }
    }
}
#endif

#if os(macOS)
private final class _NSHapticFeedbackPerformer: HapticFeedbackPerformer {
    func perform(_ feedbackType: HapticFeedback.FeedbackType) {
        if let pattern = NSHapticFeedbackManager.FeedbackPattern(feedbackType) {
            NSHapticFeedbackManager.defaultPerformer.perform(pattern, performanceTime: .default)
        }
    }
    
    static let shared = _NSHapticFeedbackPerformer()
    private init() {}
}

private extension NSHapticFeedbackManager.FeedbackPattern {
    fileprivate init?(_ feedbackType: HapticFeedback.FeedbackType) {
        switch feedbackType {
        case .alignment:
            self = .alignment
        case .levelChange:
            self = .levelChange
        default:
            return nil
        }
    }
}
#endif

#if os(watchOS)
private final class _WKHapticFeedbackPerformer: HapticFeedbackPerformer {
    func perform(_ feedbackType: HapticFeedback.FeedbackType) {
        if let hapticType = WKHapticType(feedbackType) {
            WKInterfaceDevice.current().play(hapticType)
        }
    }
    
    static let shared = _WKHapticFeedbackPerformer()
    private init() {}
}

private extension WKHapticType {
    init?(_ feedbackType: HapticFeedback.FeedbackType) {
        switch feedbackType {
        case .start:
            self = .start
        case .stop:
            self = .stop
        case .decrease:
            self = .directionDown
        case .increase:
            self = .directionUp
        case .selection:
            self = .click
        case .success:
            self = .success
        case .warning:
            self = .retry
        case .error:
            self = .failure
        default:
            return nil
        }
    }
}
#endif

@available(visionOS, unavailable)
private final class _GenericFeedbackPerformer: HapticFeedbackPerformer {
    func perform(_ feedbackType: HapticFeedback.FeedbackType) { }
}

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(visionOS, unavailable)
extension SensoryFeedback {
    fileprivate init(_ feedbackType: HapticFeedback.FeedbackType) {
        switch feedbackType {
        case .start:
            self = .start
        case .stop:
            self = .stop
        case .alignment:
            self = .alignment
        case .decrease:
            self = .decrease
        case .increase:
            self = .increase
        case .levelChange:
            self = .levelChange
        case .selection:
            self = .selection
        case .success:
            self = .success
        case .warning:
            self = .warning
        case .error:
            self = .error
        case let .impactWeight(weight, intensity: intensity):
            self = .impact(weight: .init(weight), intensity: intensity)
        case let .impactFlexibility(flexibility, intensity: intensity):
            self = .impact(flexibility: .init(flexibility), intensity: intensity)
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(visionOS, unavailable)
extension SensoryFeedback.Weight {
    fileprivate init(_ weight: HapticFeedback.Weight) {
        switch weight {
        case .heavy:
            self = .heavy
        case .medium:
            self = .medium
        case .light:
            self = .light
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(visionOS, unavailable)
extension SensoryFeedback.Flexibility {
    init(_ flexibility: HapticFeedback.Flexibility) {
        switch flexibility {
        case .rigid:
            self = .rigid
        case .solid:
            self = .solid
        case .soft:
            self = .soft
        }
    }
}
#endif
