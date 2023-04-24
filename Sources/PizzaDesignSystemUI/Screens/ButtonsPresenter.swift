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
                        id: "component-1",
                        buttonConfiguration: {
                            var configuration = UIButton.Configuration.filled()
                            configuration.title = "Button filled"
                            return configuration
                        }()
                    ),
                    ButtonsComponent(
                        id: "component-2",
                        buttonConfiguration: {
                            var configuration = UIButton.Configuration.bordered()
                            configuration.title = "Button bordered"
                            return configuration
                        }()
                    ),
                    ButtonsComponent(
                        id: "component-3",
                        buttonConfiguration: {
                            var configuration = UIButton.Configuration.borderedProminent()
                            configuration.title = "Button borderedProminent"
                            return configuration
                        }()
                    ),
                    ButtonsComponent(
                        id: "component-4",
                        buttonConfiguration: {
                            var configuration = UIButton.Configuration.borderedTinted()
                            configuration.title = "Button borderedTinted"
                            return configuration
                        }()
                    ),
                    ButtonsComponent(
                        id: "component-5",
                        buttonConfiguration: {
                            var configuration = UIButton.Configuration.tinted()
                            configuration.title = "Button tinted"
                            return configuration
                        }()
                    ),
                    ButtonsComponent(
                        id: "component-6",
                        buttonConfiguration: {
                            var configuration = UIButton.Configuration.plain()
                            configuration.title = "Button plain"
                            return configuration
                        }()
                    ),
                    ButtonsComponent(
                        id: "component-7",
                        buttonConfiguration: {
                            var configuration = UIButton.Configuration.gray()
                            configuration.title = "Button gray"
                            return configuration
                        }()
                    )
                ]
            ),
            .init(
                id: "section-2",
                cells: [
                    ButtonsComponent(
                        id: "component-10",
                        buttonConfiguration: {
                            var configuration = UIButton.Configuration.plain()
                            configuration.title = "Remove account"
                            configuration.buttonSize = .large
                            configuration.titleAlignment = .center
                            configuration.cornerStyle = .large

                            return configuration
                        }()
                    )
                ]
            )
        ])
    }

}

struct ButtonsComponent: IdentifiableComponent {

    let id: String
    let buttonConfiguration: UIButton.Configuration

    func createRenderTarget() -> ButtonsComponentView {
        ButtonsComponentView()
    }

    func render(in renderTarget: ButtonsComponentView, renderType: RenderType) {
        renderTarget.configure(buttonConfiguration: buttonConfiguration)
    }

}

class ButtonsComponentView: PizzaView {

    private lazy var button = UIButton(primaryAction: .init(handler: { [weak self] _ in
        self?.changeButtonState()
    }))

    override func commonInit() {
        super.commonInit()

        button.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(12)
            }

        }
    }

    func configure(buttonConfiguration: UIButton.Configuration) {
        var newConfig = buttonConfiguration
        newConfig.titleTextAttributesTransformer = .init({ container in
            var new = container
            new.font = .preferredFont(forTextStyle: .body)
            return new
        })
        newConfig.buttonSize = .large
        newConfig.titleAlignment = .center
        newConfig.cornerStyle = .large
        newConfig.imagePadding = 8
        newConfig.preferredSymbolConfigurationForImage = .init(scale: .medium)
        button.configuration = newConfig
        button.configurationUpdateHandler = { button in
            var config = button.configuration

            config?.image = UIImage(
                systemSymbol: button.isHighlighted ? .cartFill : .cart
            )

            button.configuration = config
        }
    }

    private func changeButtonState() {
        if button.configuration?.showsActivityIndicator == true {
            button.configuration?.showsActivityIndicator = false
        } else {
            button.configuration?.showsActivityIndicator = true
        }
    }

}
