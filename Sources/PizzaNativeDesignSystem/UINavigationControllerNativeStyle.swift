import UIKit
import PizzaKit

public class UINavigationControllerNativeStyle: UIStyle<UINavigationController> {

    public let supportLargeTitle: Bool

    public init(supportLargeTitle: Bool) {
        self.supportLargeTitle = supportLargeTitle
    }

    public override func apply(for navController: UINavigationController) {
        let largeTitleAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 34, weight: .bold).roundedIfNeeded,
            .foregroundColor: UIColor.palette.label,
            .paragraphStyle: NSMutableParagraphStyle().do {
                $0.alignment = .left
            }
        ]
        let standardTitleAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold).roundedIfNeeded,
            .foregroundColor: UIColor.palette.label,
            .paragraphStyle: NSMutableParagraphStyle().do {
                $0.alignment = .left
            }
        ]

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        standardAppearance.largeTitleTextAttributes = largeTitleAttributes
        standardAppearance.titleTextAttributes = standardTitleAttributes

        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.largeTitleTextAttributes = largeTitleAttributes
        scrollAppearance.titleTextAttributes = standardTitleAttributes

        navController.navigationBar.standardAppearance = standardAppearance
        navController.navigationBar.scrollEdgeAppearance = scrollAppearance

        navController.navigationBar.prefersLargeTitles = supportLargeTitle
    }

}

public class UINavigationControllerTransparentStyle: UIStyle<UINavigationController> {

    public override func apply(for navController: UINavigationController) {
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithTransparentBackground()

        navController.navigationBar.standardAppearance = scrollAppearance
        navController.navigationBar.scrollEdgeAppearance = scrollAppearance

        navController.navigationBar.prefersLargeTitles = false
    }

}
