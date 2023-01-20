import UIKit
import PizzaKit
import Carbon
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

        updater.performUpdates(target: tableView, data: [
            .init(id: "section", cells: items)
        ])
    }

}
