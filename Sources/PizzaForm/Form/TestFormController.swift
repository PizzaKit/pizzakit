import UIKit
import PizzaKit
//import Carbon
import SnapKit

public class TestChooseOneController: UITableViewController {

    public struct Item: Equatable {
        public let id: String
        public let title: String
    }

    private struct State {
        var items: [Item]
        var selectedId: String?
    }

    private var state: State {
        didSet {
            render()
        }
    }

    private let updater = TableViewUpdater()
    private let onSelect: PizzaClosure<String>

    public init(
        title: String,
        items: [Item],
        selectedId: String?,
        onSelect: @escaping PizzaClosure<String>
    ) {
        self.state = .init(items: items, selectedId: selectedId)
        self.onSelect = onSelect
        super.init(style: .insetGrouped)
        navigationItem.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorInsetReference = .fromAutomaticInsets
        tableView.separatorInset = .zero
        navigationItem.largeTitleDisplayMode = .never
        updater.initialize(target: tableView)
        render()
    }

    private func render() {
        var items: [CellNode] = []

        state.items.forEach { item in
            items.append(
                .init(
                    component: CheckComponent(
                        id: item.id,
                        title: item.title,
                        needCheck: item.id == state.selectedId,
                        onSelect: { [weak self] in
                            self?.state.selectedId = item.id
                        }
                    )
                )
            )
        }

        updater.performUpdates(target: tableView, data: [
            .init(
                id: "main-section",
                header: nil,
                cells: items,
                footer: nil
            )
        ])
        // TODO: add footer
    }

}

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
            title: "Конфиденциальность",
            onSelect: nil
        )
        items.append(.init(component: confidentialItem))
        items.append(.init(component: TitleValueComponent(id: "version", title: "Версия iOS", description: "16.1", needArrow: state.showSecondSection)))

        if state.showSecondSection {
            let settingsItem = SimpleListComponent(
                id: "settings",
                iconName: "gear",
                iconBackgroundColor: .systemGray,
                title: "Настройки",
                onSelect: { [weak self] in
                    let newController = TestChooseOneController(
                        title: "Подключаться автоматичеки",
                        items: [
                            .init(
                                id: "1",
                                title: "Всегда"
                            ),
                            .init(
                                id: "2",
                                title: "Никогда"
                            )
                        ],
                        selectedId: "1",
                        onSelect: { newId in

                        }
                    )
                    self?.navigationController?.pushViewController(newController, animated: true)
                }
            )
            items.append(.init(component: settingsItem))
        }

        var otherItems: [CellNode] = []

        for i in 0..<50 {
            otherItems.append(.init(component: SimpleListComponent(
                id: "settings-\(i)",
                iconName: "gear",
                iconBackgroundColor: .systemGray,
                title: "Другое",
                onSelect: nil
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
