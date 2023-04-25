import PizzaCore
import Foundation
import UIKit
import SPIndicator
import Combine
import Defaults

public class PizzaDeveloperModeService {

    // MARK: - Nested Types

    public enum ServiceError: Error {
        case internalError
        case verificationFailed
    }

    // MARK: - Properties

    public var isDeveloperMode: Bool {
        modeSubject.value
    }
    public var isDeveloperModePublisher: AnyPublisher<Bool, Never> {
        modeSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    private let modeSubject: CurrentValueSubject<Bool, Never>
    private let sault: String
    private let deviceID: String
    private let publicKey: String
    private let onNeedShowIndicator: PizzaClosure<Result<PizzaSigningCryptoHelpers.LifeTime, Error>>?

    // MARK: - Initialization

    public init(
        sault: String,
        deviceID: String,
        publicKey: String,
        onNeedShowIndicator: PizzaClosure<Result<PizzaSigningCryptoHelpers.LifeTime, Error>>?
    ) {
        self.sault = sault
        self.deviceID = deviceID
        self.publicKey = publicKey
        self.onNeedShowIndicator = onNeedShowIndicator
        self.modeSubject = .init(
            Self.verifyDeveloperMode(
                sault: sault,
                deviceID: deviceID,
                publicKey: publicKey
            )
        )
    }

    // MARK: - Methods

    public func tryTurnOn(
        option: Int,
        signature: String
    ) {
        // save to user defaults to restore it at next launch
        Defaults[.signature] = signature
        Defaults[.option] = option

        let isVerified = Self.verifyDeveloperMode(
            sault: sault,
            deviceID: deviceID,
            publicKey: publicKey
        )
        modeSubject.send(isVerified)

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
