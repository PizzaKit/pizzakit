import PizzaCore
import Foundation
import UIKit
import SPIndicator
import Combine
import Defaults

public protocol PizzaDeveloperModeService {
    var valuePublisher: PizzaRPublisher<Bool, Never> { get }

    /// Метод для попытки включения
    func tryTurnOn(
        option: Int,
        signature: String,
        onNeedShowIndicator: PizzaClosure<Result<PizzaSigningCryptoHelpers.LifeTime, Error>>?
    )
}

public class PizzaDeveloperModeServiceImpl: PizzaDeveloperModeService {

    // MARK: - Nested Types

    public enum ServiceError: Error {
        case internalError
        case verificationFailed
    }

    // MARK: - PizzaDeveloperModeService

    public lazy var _valuePublisher = PizzaPassthroughRPublisher<Bool, Never>(
        currentValue: { [weak self] in
            guard let self else { return false }
            return Self.verifyDeveloperMode(
                sault: self.sault,
                deviceID: self.deviceID,
                publicKey: self.publicKey
            )
        }
    )
    public var valuePublisher: PizzaRPublisher<Bool, Never> {
        _valuePublisher
    }

    // MARK: - Properties

    private let sault: String
    private let deviceID: String
    private let publicKey: String

    // MARK: - Initialization

    public init(
        sault: String,
        deviceID: String,
        publicKey: String
    ) {
        self.sault = sault
        self.deviceID = deviceID
        self.publicKey = publicKey
    }

    // MARK: - Methods

    public func tryTurnOn(
        option: Int,
        signature: String,
        onNeedShowIndicator: PizzaClosure<Result<PizzaSigningCryptoHelpers.LifeTime, Error>>?
    ) {
        // save to user defaults to restore it at next launch
        Defaults[.signature] = signature
        Defaults[.option] = option

        _valuePublisher.setNeedsUpdate()
        let isVerified = _valuePublisher.value

        if isVerified {
            guard let lifeTime: PizzaSigningCryptoHelpers.LifeTime = .from(
                optionNumber: option,
                appVersion: UIApplication.appVersion ?? "<none>",
                date: Date()
            ) else {
                onNeedShowIndicator?(.failure(ServiceError.internalError))
                return
            }
            onNeedShowIndicator?(.success(lifeTime))
        } else {
            onNeedShowIndicator?(.failure(ServiceError.verificationFailed))
        }
    }

    // MARK: - Private Methods

    private static func verifyDeveloperMode(
        sault: String,
        deviceID: String,
        publicKey: String
    ) -> Bool {
        let option = Defaults[.option]
        let signature = Defaults[.signature]
        guard let option, let signature else {
            resetUserDefaults()
            return false
        }
        guard let lifeTime: PizzaSigningCryptoHelpers.LifeTime = .from(
            optionNumber: option,
            appVersion: UIApplication.appVersion ?? "<none>",
            date: Date()
        ) else {
            return false
        }
        let digest = PizzaSigningCryptoHelpers.createMessageDigest(
            string: deviceID,
            sault: sault,
            lifeTime: lifeTime
        )
        let isVerified = PizzaSigningCryptoHelpers.verifySignature(
            signature: signature,
            messageDigest: digest,
            publicKey: publicKey
        )
        return isVerified
    }

    // MARK: - Private Methods

    private func tryTurnOn(
        option: Int,
        signature: String,
        showIndicatorAtEnd: Bool
    ) {

    }

    private static func resetUserDefaults() {
        Defaults[.signature] = nil
        Defaults[.option] = nil
    }

}

fileprivate extension Defaults.Keys {
    static let signature = Defaults.Key<String?>("developer_mode_sign")
    static let option = Defaults.Key<Int?>("developer_mode_option")
}
