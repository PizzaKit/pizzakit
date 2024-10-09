import UIKit
import CoreHaptics
import Combine

public class PizzaHapticPlayerWrapper {

    private var continuousPlayer: CHHapticAdvancedPatternPlayer?
    private var engine: CHHapticEngine?
    private var dateStarted: Date?

    private var bag = Set<AnyCancellable>()

    private lazy var supportsHaptics: Bool = {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }()

    public struct Config {
        let intensityStart: Float
        let intensityMultiplier: Float
        let sharpnessStart: Float
        let sharpnessMultiplier: Float
        let needSuccessHapticAtEnd: Bool

        public static var withHapticAtEnd: Config {
            .init(
                intensityStart: 0.15,
                intensityMultiplier: 0.28,
                sharpnessStart: 0.1,
                sharpnessMultiplier: 0.2,
                needSuccessHapticAtEnd: true
            )
        }
        public static var withoutHapticAtEnd: Config {
            .init(
                intensityStart: 0.15,
                intensityMultiplier: 0.28,
                sharpnessStart: 0.1,
                sharpnessMultiplier: 0.2,
                needSuccessHapticAtEnd: false
            )
        }
    }
    private let config: Config

    public init(config: Config) {
        self.config = config
        if supportsHaptics {
            createEngine()
            createContinuousHapticPlayer()
        }
        addObservers()
    }

    private func createEngine() {
        // Create and configure a haptic engine.
        do {
            engine = try CHHapticEngine()
        } catch {
            PizzaLogger.logError(
                label: .logLabel,
                error: error
            )
        }

        // Mute audio to reduce latency for collision haptics.
        engine?.playsHapticsOnly = true

        // The stopped handler alerts you of engine stoppage.
        engine?.stoppedHandler = { reason in
            PizzaLogger.log(
                label: .logLabel,
                level: .error,
                message: "Stop Handler: The engine stopped for reason: \(reason.rawValue)"
            )
        }

        // The reset handler provides an opportunity to restart the engine.
        engine?.resetHandler = { [weak self] in

            PizzaLogger.log(
                label: .logLabel,
                level: .info,
                message: "Reset Handler: Restarting the engine."
            )

            do {
                // Try restarting the engine.
                try self?.engine?.start()

                // Recreate the continuous player.
                self?.createContinuousHapticPlayer()

            } catch {
                PizzaLogger.logError(
                    label: .logLabel,
                    error: error
                )
            }
        }

        // Start the haptic engine for the first time.
        do {
            try self.engine?.start()
        } catch {
            PizzaLogger.logError(
                label: .logLabel,
                error: error
            )
        }
    }

    private func createContinuousHapticPlayer() {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                               value: 1)

        // Create a sharpness parameter:
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                               value: 1)

        // Create a continuous event with a long duration from the parameters.
        let continuousEvent = CHHapticEvent(eventType: .hapticContinuous,
                                            parameters: [intensity, sharpness],
                                            relativeTime: 0,
                                            duration: 100)

        do {
            // Create a pattern from the continuous haptic event.
            let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])

            // Create a player from the continuous haptic pattern.
            continuousPlayer = try engine?.makeAdvancedPlayer(with: pattern)

        } catch {
            PizzaLogger.logError(
                label: .logLabel,
                error: error
            )
        }
    }

    private func addObservers() {
        NotificationCenter.default
            .publisher(for: UIApplication.didEnterBackgroundNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.engine?.stop(completionHandler: { error in
                    if let error {
                        PizzaLogger.logError(
                            label: .logLabel,
                            error: error
                        )
                        return
                    }
                    self?.isPlayerPlaying = false
                })
            }
            .store(in: &bag)

        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.engine?.start(completionHandler: { error in
                    if let error {
                        PizzaLogger.logError(
                            label: .logLabel,
                            error: error
                        )
                        return
                    }
                })
            }
            .store(in: &bag)
    }

    private var isPlayerPlaying = false
//    private var wasFinalTickPlayed = false

    public func configure(progress: CGFloat) {
//        print("progress: \(progress)")
        if progress >= 1 {
            do {
                try continuousPlayer?.stop(atTime: CHHapticTimeImmediate)
                self.isPlayerPlaying = false
            } catch {
                PizzaLogger.logError(
                    label: .logLabel,
                    error: error
                )
            }

            if config.needSuccessHapticAtEnd {
                UIFeedbackGenerator.impactOccurred(.notificationSuccess)
            }
        } else if progress > 0 {

            // The intensity should be highest at the top, opposite of the iOS y-axis direction, so subtract.
            let dynamicIntensity: Float = config.intensityStart + Float(progress) * config.intensityMultiplier

            // Dynamic parameters range from -0.5 to 0.5 to map the final sharpness to the [0,1] range.
            let dynamicSharpness: Float = config.sharpnessStart + Float(progress) * config.sharpnessMultiplier

//            print("dynamicIntensity: \(dynamicIntensity), dynamicSharpness: \(dynamicSharpness)")

            let intensityParameter = CHHapticDynamicParameter(
                parameterID: .hapticIntensityControl,
                value: dynamicIntensity.clamped(to: 0...1),
                relativeTime: 0
            )

            let sharpnessParameter = CHHapticDynamicParameter(
                parameterID: .hapticSharpnessControl,
                value: dynamicSharpness.clamped(to: 0...1),
                relativeTime: 0
            )

            // Send dynamic parameters to the haptic player.
            do {
                try continuousPlayer?.sendParameters([intensityParameter, sharpnessParameter],
                                                    atTime: 0)
            } catch {
                PizzaLogger.logError(
                    label: .logLabel,
                    error: error
                )
            }

            let isStartedFarAway: Bool = {
                guard let dateStarted else {
                    return false
                }
                let diff = Date().timeIntervalSince1970 - dateStarted.timeIntervalSince1970
                return diff >= 30
            }()
            if !isPlayerPlaying || isStartedFarAway {
                do {
                    // Begin playing continuous pattern.
                    try continuousPlayer?.start(atTime: CHHapticTimeImmediate)
                    self.isPlayerPlaying = true
                    self.dateStarted = Date()
                } catch {
                    PizzaLogger.logError(
                        label: .logLabel,
                        error: error
                    )
                }
            }

        } else {
            do {
                try continuousPlayer?.stop(atTime: CHHapticTimeImmediate)
                self.isPlayerPlaying = false
            } catch {
                PizzaLogger.logError(
                    label: .logLabel,
                    error: error
                )
            }
        }

//        if progress <= 0.1 {
//            wasFinalTickPlayed = false
//        }

    }

}

private extension String {
    static var logLabel: String { "haptic_player_wrapper" }
}
