import UIKit
import PizzaKit
//import Carbon
import SnapKit

public class TestFormController: UITableViewController {

    private struct State {
        var showSecondSection = false
        var section2value = false
    }

    private var state: State = .init() {
        didSet {
            render()
        }
    }

    private let updater = TableViewUpdater()

    public override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = .init(
            primaryAction: UIAction(
                title: "Change",
                handler: { [weak self] _ in
                    self?.modifyForm()
                }
            )
        )
        navigationItem.title = "Settings"
        tableView.layoutMargins = .zero

        updater.initialize(target: tableView)
        render()
    }

    private func modifyForm() {
        state.showSecondSection.toggle()
    }

    private func render() {
        var items: [CellNode] = []

        let confidentialItem = SimpleListComponent(
            id: "conf",
            iconName: "hand.raised.fill",
            iconBackgroundColor: .systemBlue,
            title: "Конфиденциальность"
        )
        items.append(.init(component: confidentialItem))

        if state.showSecondSection {
            let settingsItem = SimpleListComponent(
                id: "settings",
                iconName: "gear",
                iconBackgroundColor: .systemGray,
                title: "Настройки"
            )
            items.append(.init(component: settingsItem))
        }

        var otherItems: [CellNode] = []

        for i in 0..<50 {
            otherItems.append(.init(component: SimpleListComponent(
                id: "settings-\(i)",
                iconName: "gear",
                iconBackgroundColor: .systemGray,
                title: "Другое"
            )))
        }

        let header1Component = EmptyHeightComponent(height: 16)
        let header2Component = TitleComponent(
            text: state.showSecondSection ? "Показана" : "Не показана",
            style: .init(
                font: .systemFont(ofSize: 16),
                insets: .init(
                    top: 0,
                    leading: 12,
                    bottom: 6,
                    trailing: 12
                ),
                textColor: .tertiaryLabel,
                textAlignment: .left
            )
        )

        updater.performUpdates(target: tableView, data: [
            .init(
                id: "section-1",
                header: .init(component: header1Component),
                cells: items
            ),
            .init(
                id: "section-2",
                header: .init(component: header2Component),
                cells: otherItems
            )
        ])
    }

}
