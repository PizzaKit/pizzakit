import Foundation

public struct PizzaEmailPayload {

    // MARK: - Public Properties

    public let recipient: String
    public let subject: String?
    public let body: String?

    // MARK: - Initializaion

    public init(
        recipient: String,
        subject: String? = nil,
        body: String? = nil
    ) {
        self.recipient = recipient
        self.subject = subject
        self.body = body
    }

}
