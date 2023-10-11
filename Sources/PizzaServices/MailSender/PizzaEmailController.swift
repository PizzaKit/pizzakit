import UIKit
import MessageUI
import PizzaCore

final class PizzaMailController: MFMailComposeViewController {

    // MARK: - Properties

    var onClose: PizzaClosure<Error?>?

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mailComposeDelegate = self
    }

}

// MARK: - Methods

extension PizzaMailController {

    func setupInitialState(recipient: String, subject: String?, body: String?) {
        setToRecipients([recipient])
        setSubject(subject ?? "")
        setMessageBody(body ?? "", isHTML: false)
    }

}

// MARK: - MFMailComposeViewControllerDelegate

extension PizzaMailController: MFMailComposeViewControllerDelegate {

    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        onClose?(error)
    }

}
