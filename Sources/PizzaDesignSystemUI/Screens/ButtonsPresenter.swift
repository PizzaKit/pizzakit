import SFSafeSymbols
import UIKit
import PizzaKit
import PizzaComponents

class ButtonsPresenter: ComponentPresenter {

    var delegate: ComponentPresenterDelegate?

    func touch() {
        delegate?.controller.do {
            $0.navigationItem.largeTitleDisplayMode = .never
            $0.navigationItem.title = "Button styles"
        }

        delegate?.render(sections: [
            .init(
                id: "section",
                cells: [
                    ButtonsComponent(
                        id: "button_1",
                        buttonStyle: .allStyles.standard(
                            title: "large, primary",
                            size: .large,
                            type: .primary
                        )
                    ),
                    ButtonsComponent(
                        id: "button_2",
                        buttonStyle: .allStyles.standard(
                            title: "large, secondary",
                            size: .large,
                            type: .secondary
                        )
                    ),
                    ButtonsComponent(
                        id: "button_3",
                        buttonStyle: .allStyles.standard(
                            title: "large, tertiary",
                            size: .large,
                            type: .tertiary
                        )
                    ),

                    ButtonsComponent(
                        id: "button_4",
                        buttonStyle: .allStyles.standard(
                            title: "medium, primary",
                            size: .medium,
                            type: .primary
                        )
                    ),
                    ButtonsComponent(
                        id: "button_5",
                        buttonStyle: .allStyles.standard(
                            title: "medium, secondary",
                            size: .medium,
                            type: .secondary
                        )
                    ),
                    ButtonsComponent(
                        id: "button_6",
                        buttonStyle: .allStyles.standard(
                            title: "medium, tertiary",
                            size: .medium,
                            type: .tertiary
                        )
                    ),

                    ButtonsComponent(
                        id: "button_7",
                        buttonStyle: .allStyles.standard(
                            title: "small, primary",
                            size: .small,
                            type: .primary
                        )
                    ),
                    ButtonsComponent(
                        id: "button_8",
                        buttonStyle: .allStyles.standard(
                            title: "small, secondary",
                            size: .small,
                            type: .secondary
                        )
                    ),
                    ButtonsComponent(
                        id: "button_9",
                        buttonStyle: .allStyles.standard(
                            title: "small, tertiary",
                            size: .small,
                            type: .tertiary
                        )
                    )
                ]
            )
        ])
    }

}

struct ButtonsComponent: IdentifiableComponent {

    let id: String
    let buttonStyle: UIStyle<UIButton>

    func createRenderTarget() -> ButtonsComponentView {
        ButtonsComponentView()
    }

    func render(in renderTarget: ButtonsComponentView, renderType: RenderType) {
        renderTarget.configure(buttonStyle: buttonStyle)
    }

}

class ButtonsComponentView: PizzaView {

    private lazy var button = UIButton()

    override func commonInit() {
        super.commonInit()

        button.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(12)
            }
        }
    }

    func configure(buttonStyle: UIStyle<UIButton>) {
        button.apply(style: buttonStyle)
    }

}
