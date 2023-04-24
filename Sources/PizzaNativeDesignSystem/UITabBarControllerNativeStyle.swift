import UIKit
import PizzaKit

public class UITabBarControllerNativeStyle: UIStyle<UITabBarController> {

    public override func apply(for tabBarController: UITabBarController) {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 10, weight: .medium).roundedIfNeeded,
            .foregroundColor: UIColor.palette.labelSecondary
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 10, weight: .medium).roundedIfNeeded,
            .foregroundColor: UIColor.tintColor
        ]

        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
    }

}
