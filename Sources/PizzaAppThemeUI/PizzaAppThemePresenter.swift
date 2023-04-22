import PizzaKit
import PizzaForm
import PizzaServices
import UIKit
import Combine

public class PizzaAppThemePresenter: FormPresenter {

    public weak var delegate: FormPresenterDelegate?

    private let appThemeService: PizzaAppThemeService
    private var bag = Set<AnyCancellable>()

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

        delegate?.modify {
            $0.navigationItem.title = .localized(key: "apptheme.pres.title")
            $0.navigationItem.largeTitleDisplayMode = .never
        }
    }

    private func render(theme: PizzaAppTheme) {
        var sections: [Section] = []

        let appThemeSection = Section(
            id: "app_theme_section",
            header: .init(
                component: TitleComponent(
                    id: "app_theme_header",
                    text: .localized(key: "apptheme.pres.switch.header"),
                    style: .defaultHeader
                )
            ),
            cells: [
                .init(
                    component: SwitchComponent(
                        id: "app_theme_switch",
                        text: .localized(key: "apptheme.pres.switch.text"),
                        value: theme.themeType == .automatic,
                        isEnabled: true,
                        onChanged: { [weak self] isOn in
                            self?.appThemeService.value.themeType = isOn ? .automatic : .light
                        }
                    )
                )
            ],
            footer: .init(
                component: TitleComponent(
                    id: "app_theme_footer",
                    text: .localized(key: "apptheme.pres.switch.footer"),
                    style: .defaultFooter
                )
            )
        )
        sections.append(appThemeSection)

        if theme.themeType != .automatic {
            let manualThemeSelectionSection = Section(
                id: "app_manual_theme_section",
                cells: [
                    .init(
                        component: CheckComponent(
                            id: "app_manual_theme_light",
                            title: .localized(key: "apptheme.pres.select.light"),
                            needCheck: theme.themeType == .light,
                            onSelect: { [weak self] in
                                self?.appThemeService.value.themeType = .light
                            }
                        )
                    ),
                    .init(
                        component: CheckComponent(
                            id: "app_manual_theme_dark",
                            title: .localized(key: "apptheme.pres.select.dark"),
                            needCheck: theme.themeType == .dark,
                            onSelect: { [weak self] in
                                self?.appThemeService.value.themeType = .dark
                            }
                        )
                    )
                ],
                footer: .init(
                    component: TitleComponent(
                        id: "app_manual_theme_footer",
                        text: .localized(key: "apptheme.pres.select.footer"),
                        style: .defaultFooter
                    )
                )
            )
            sections.append(manualThemeSelectionSection)
        }

        var colorCells: [CellNode] = []
        for (index, color) in PizzaAppTheme.allTintColors.enumerated() {
            let isSelected = color == theme.tintColor
            colorCells.append(
                .init(
                    component: CheckColorComponent(
                        id: color.hex,
                        title: PizzaAppThemeUIColorsNameHelper.colorNames[index],
                        color: color,
                        isChecked: isSelected,
                        onSelect: { [weak self] in
                            self?.appThemeService.value.tintColorIndex = index
                        }
                    )
                )
            )
        }
        let sectionWithColors = Section(
            id: "app_theme_colors_section",
            header: .init(
                component: TitleComponent(
                    id: "app_theme_colors_header",
                    text: .localized(key: "apptheme.pres.color.header"),
                    style: .defaultHeader
                )
            ),
            cells: colorCells,
            footer: .init(
                component: TitleComponent(
                    id: "app_theme_colors_footer",
                    text: .localized(key: "apptheme.pres.color.footer"),
                    style: .defaultFooter
                )
            )
        )
        sections.append(sectionWithColors)

        delegate?.render(sections: sections)
    }

}
