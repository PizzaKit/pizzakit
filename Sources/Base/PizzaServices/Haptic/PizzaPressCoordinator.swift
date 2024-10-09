import UIKit
import Combine
import PizzaCore

public class PizzaPressCoordinator: NSObject {

    private let onPressedSubject = CurrentValueSubject<Bool, Never>(false)
    public var onPressedPublisher: PizzaRPublisher<Bool, Never> {
        PizzaCurrentValueRPublisher(subject: onPressedSubject)
    }

    private var progressSubject = CurrentValueSubject<CGFloat, Never>(0)
    public var progressPublisher: PizzaRPublisher<CGFloat, Never> {
        PizzaCurrentValueRPublisher(subject: progressSubject)
    }

    private var shortTouchSubject = CurrentValueSubject<Void, Never>(())
    public var shortTouchPublisher: PizzaRPublisher<Void, Never> {
        PizzaCurrentValueRPublisher(subject: shortTouchSubject)
    }

    private var displayLink: CADisplayLink?
    private var secondsToFillProgress: Double = 1

    private var pressTimeInterval: TimeInterval?

    public func reset(animated: Bool) {
        if animated {
            onPressedSubject.value = false
            if displayLink == nil {
                runDisplayLink()
            }
        } else {
            progressSubject.send(0)
        }

    }

    public func configure(isPressed: Bool) {
        if isPressed {
            pressTimeInterval = Date().timeIntervalSince1970

            stopDisplayLink()
            if progressSubject.value < 1 {
                runDisplayLink()
            }
        } else {
            guard let pressTimeInterval else {
                return
            }
            let diff = Date().timeIntervalSince1970 - pressTimeInterval
            if diff <= 0.1 && progressSubject.value < 0.15 {
                shortTouchSubject.send(())
                progressSubject.send(0.15)
                stopDisplayLink()
                runDisplayLink()
            }

            // если нужно чтобы после completion-а можно было бы
            // вернуть прогресс в ноль - в данный момент такого не нужно
//            if displayLink == nil {
//                runDisplayLink()
//            }
        }

        self.onPressedSubject.send(isPressed)
    }

    private func stopDisplayLink() {
        self.displayLink?.invalidate()
        self.displayLink = nil
    }

    private func runDisplayLink() {
        displayLink = CADisplayLink(
            target: self,
            selector: #selector(handleDisplayLink)
        )
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc
    private func handleDisplayLink(displaylink: CADisplayLink) {
        var newProgress = self.progressSubject.value
        let interval = displaylink.targetTimestamp - displaylink.timestamp
        let diffToAdd = 1 / (secondsToFillProgress / interval)
        if onPressedSubject.value {
            newProgress += CGFloat(diffToAdd)
        } else {
            newProgress -= CGFloat(diffToAdd)
        }

        self.progressSubject.send(newProgress.clamped(to: 0...1))

        if newProgress <= 0 || newProgress >= 1 {
            stopDisplayLink()
        }
    }

}
