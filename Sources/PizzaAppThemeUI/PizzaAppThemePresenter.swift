import PizzaKit
import PizzaServices
import UIKit
import Combine
import PizzaComponents

public struct PizzaAppThemePresenterClosureActionsHandler: PizzaAppThemePresenterActionsHandler {

    private let closure: PizzaEmptyClosure

    public init(closure: @escaping PizzaEmptyClosure) {
        self.closure = closure
    }

    public func proActionCompleted() {
        closure()
    }

}

public protocol PizzaAppThemePresenterActionsHandler {
    func proActionCompleted()
}

public class PizzaAppThemePresenter: ComponentPresenter {

    private struct State {
        var changingEnabled: Bool
        var theme: PizzaAppTheme
    }

    public weak var delegate: ComponentPresenterDelegate?

    private let appThemeService: PizzaAppThemeService
    private let proVersionService: PizzaProVersionService?
    private let actionsHandler: PizzaAppThemePresenterActionsHandler?
    private var bag = Set<AnyCancellable>()
    private let feedbackGenerator = UISelectionFeedbackGenerator()

    private var state: State {
        didSet {
            render()
        }
    }

    public init(
        appThemeService: PizzaAppThemeService,
        proVersionService: PizzaProVersionService?,
        actionsHandler: PizzaAppThemePresenterActionsHandler?
    ) {
        self.appThemeService = appThemeService
        self.proVersionService = proVersionService
        self.actionsHandler = actionsHandler
        self.state = .init(changingEnabled: false, theme: .default)
        self.state = .init(
            changingEnabled: proVersionService?.valuePublisher.value ?? true,
            theme: appThemeService.valuePublisher.value
        )
    }

    public func touch() {
        appThemeService
            .valuePublisher
            .withoutCurrentValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] theme in
                self?.state.theme = theme
            }
            .store(in: &bag)

        proVersionService?
            .valuePublisher
            .withoutCurrentValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPro in
                self?.state.changingEnabled = isPro
            }
            .store(in: &bag)

        delegate?.controller.do {
            $0.navigationItem.title = .localized(key: "apptheme.pres.title")
            $0.navigationItem.largeTitleDisplayMode = .never
        }

        render()
    }

    private func render() {
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
                    value: state.theme.themeType == .automatic,
                    isEnabled: true,
                    onChanged: { [weak self] isOn in
                        guard let self else { return }
                        let isCurrentLight = UIApplication.allWindows
                            .first(where: { $0.isKeyWindow })?
                            .traitCollection.userInterfaceStyle == .light
                        if isOn {
                            appThemeService.valuePublisher.value.themeType = .automatic
                        } else if state.changingEnabled {
                            appThemeService.valuePublisher.value.themeType = isCurrentLight
                                ? .light
                                : .dark
                        } else {
                            render()
                            actionsHandler?.proActionCompleted()
                        }
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

        if state.theme.themeType != .automatic {
            let manualThemeSelectionSection = ComponentSection(
                id: "app_manual_theme_section",
                cells: [
                    ListComponent(
                        id: "app_manual_theme_light",
                        title: .localized(key: "apptheme.pres.select.light"),
                        selectableContext: .init(
                            shouldDeselect: true,
                            onSelect: { [weak self] in
                                guard
                                    let self,
                                    appThemeService.valuePublisher.value.themeType != .light
                                else { return }
                                if state.changingEnabled {
                                    feedbackGenerator.selectionChanged()
                                    appThemeService.valuePublisher.value.themeType = .light
                                } else {
                                    actionsHandler?.proActionCompleted()
                                }
                            }
                        ),
                        trailingContent: state.theme.themeType == .light ? .check : nil
                    ),
                    ListComponent(
                        id: "app_manual_theme_dark",
                        title: .localized(key: "apptheme.pres.select.dark"),
                        selectableContext: .init(
                            shouldDeselect: true,
                            onSelect: { [weak self] in
                                guard
                                    let self,
                                    appThemeService.valuePublisher.value.themeType != .dark
                                else { return }
                                if state.changingEnabled {
                                    feedbackGenerator.selectionChanged()
                                    appThemeService.valuePublisher.value.themeType = .dark
                                } else {
                                    actionsHandler?.proActionCompleted()
                                }
                            }
                        ),
                        trailingContent: state.theme.themeType == .dark ? .check : nil
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
            let isSelected = color == state.theme.tintColor
            colorComponents.append(
                ListComponent(
                    id: color.hex,
                    icon: .background(color: color),
                    title: PizzaAppThemeUIColorsNameHelper.colorNames[index],
                    selectableContext: .init(
                        shouldDeselect: true,
                        onSelect: { [weak self] in
                            guard
                                let self,
                                !isSelected
                            else { return }
                            if state.changingEnabled {
                                feedbackGenerator.selectionChanged()
                                appThemeService.valuePublisher.value.tintColorIndex = index
                            } else {
                                actionsHandler?.proActionCompleted()
                            }
                        }
                    ),
                    trailingContent: {
                        if isSelected {
                            return .check
                        }
                        if !state.changingEnabled {
                            return .sfSymbol(.lock)
                        }
                        return nil
                    }()
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
