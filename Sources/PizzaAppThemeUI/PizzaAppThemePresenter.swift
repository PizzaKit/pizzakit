import PizzaKit
import PizzaServices
import UIKit
import Combine

public class PizzaAppThemePresenter: ComponentPresenter {

    public weak var delegate: ComponentPresenterDelegate?

    private let appThemeService: PizzaAppThemeService
    private var bag = Set<AnyCancellable>()
    private let feedbackGenerator = UISelectionFeedbackGenerator()

    public init(appThemeService: PizzaAppThemeService) {
        self.appThemeService = appThemeService
    }

    public func touch() {
        appThemeService
            .valueSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] theme in
                self?.render(theme: theme)
            }
            .store(in: &bag)

        delegate?.controller.do {
            $0.navigationItem.title = .localized(key: "apptheme.pres.title")
            $0.navigationItem.largeTitleDisplayMode = .never
        }
    }

    private func render(theme: PizzaAppTheme) {
        var sections: [ComponentSection] = []

        let appThemeSection = ComponentSection(
            id: "app_theme_section",
            header: TitleComponent(
                id: "app_theme_header",
                text: .localized(key: "apptheme.pres.switch.header"),
                insets: .defaultHeader
            ),
            cells: [
                SwitchComponent(
                    id: "app_theme_switch",
                    text: .localized(key: "apptheme.pres.switch.text"),
                    value: theme.themeType == .automatic,
                    isEnabled: true,
                    onChanged: { [weak self] isOn in
                        let isCurrentLight = UIApplication.allWindows
                            .first(where: { $0.isKeyWindow })?
                            .traitCollection.userInterfaceStyle == .light
                        self?.appThemeService.value.themeType = isOn
                            ? .automatic
                            : (isCurrentLight ? .light : .dark)
                    }
                )
            ],
            footer: TitleComponent(
                id: "app_theme_footer",
                text: .localized(key: "apptheme.pres.switch.footer"),
                insets: .defaultFooter
            )
        )
        sections.append(appThemeSection)

        if theme.themeType != .automatic {
            let manualThemeSelectionSection = ComponentSection(
                id: "app_manual_theme_section",
                cells: [
                    ListComponent(
                        id: "app_manual_theme_light",
                        title: .localized(key: "apptheme.pres.select.light"),
                        selectableContext: .init(
                            shouldDeselect: true,
                            onSelect: { [weak self] in
                                self?.feedbackGenerator.selectionChanged()
                                self?.appThemeService.value.themeType = .light
                            }
                        ),
                        trailingContent: theme.themeType == .light ? .check : nil
                    ),
                    ListComponent(
                        id: "app_manual_theme_dark",
                        title: .localized(key: "apptheme.pres.select.dark"),
                        selectableContext: .init(
                            shouldDeselect: true,
                            onSelect: { [weak self] in
                                self?.feedbackGenerator.selectionChanged()
                                self?.appThemeService.value.themeType = .dark
                            }
                        ),
                        trailingContent: theme.themeType == .dark ? .check : nil
                    )
                ],
                footer: TitleComponent(
                    id: "app_manual_theme_footer",
                    text: .localized(key: "apptheme.pres.select.footer"),
                    insets: .defaultFooter
                )
            )
            sections.append(manualThemeSelectionSection)
        }

        var colorComponents: [any IdentifiableComponent] = []
        for (index, color) in PizzaAppTheme.allTintColors.enumerated() {
            let isSelected = color == theme.tintColor
            colorComponents.append(
                ListComponent(
                    id: color.hex,
                    icon: .system(.init(sfSymbol: nil, backgroundColor: color)),
                    title: PizzaAppThemeUIColorsNameHelper.colorNames[index],
                    selectableContext: .init(
                        shouldDeselect: true,
                        onSelect: { [weak self] in
                            self?.feedbackGenerator.selectionChanged()
                            self?.appThemeService.value.tintColorIndex = index
                        }
                    ),
                    trailingContent: isSelected ? .check : nil
                )
            )
        }
        let sectionWithColors = ComponentSection(
            id: "app_theme_colors_section",
            header: TitleComponent(
                id: "app_theme_colors_header",
                text: .localized(key: "apptheme.pres.color.header"),
                insets: .defaultHeader
            ),
            cells: colorComponents,
            footer: TitleComponent(
                id: "app_theme_colors_footer",
                text: .localized(key: "apptheme.pres.color.footer"),
                insets: .defaultFooter
            )
        )
        sections.append(sectionWithColors)

        delegate?.render(sections: sections)
    }

}
