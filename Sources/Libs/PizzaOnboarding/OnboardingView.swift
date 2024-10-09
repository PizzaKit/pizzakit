import UIKit
import SwiftUI
import PizzaKit
import SnapKit
import SFSafeSymbols
import PizzaIcon

public struct PizzaOnboardingScreenItem {

    public enum Icon {
        case appIcon
        case customAsset(Image)
        case pizzaIcon(PizzaIcon)
    }

    public let title: String
    public let description: String
    public let icon: Icon

    public init(
        title: String,
        description: String,
        icon: Icon
    ) {
        self.title = title
        self.description = description
        self.icon = icon
    }
}

public struct PizzaOnboardingConfig {
    public let appIconName: String
    public let skipButtonTitle: String
    public let completeButtonTitle: String
    public let nextButtonTitle: String
    public let items: [PizzaOnboardingScreenItem]

    public init(
        appIconName: String,
        skipButtonTitle: String,
        completeButtonTitle: String,
        nextButtonTitle: String,
        items: [PizzaOnboardingScreenItem]
    ) {
        self.appIconName = appIconName
        self.skipButtonTitle = skipButtonTitle
        self.items = items
        self.completeButtonTitle = completeButtonTitle
        self.nextButtonTitle = nextButtonTitle
    }
}

extension View {
    func opacityTranslation(
        geometry: GeometryProxy,
        translation: CGFloat,
        allParts: Int,
        currentPart: Int
    ) -> some View {
        modifier(
            OpacityTranslationModifier(
                geometry: geometry,
                translation: translation,
                allParts: allParts,
                currentPart: currentPart
            )
        )
    }
}

struct OpacityTranslationModifier: ViewModifier {

    let geometry: GeometryProxy
    let translation: CGFloat
    let allParts: Int
    let currentPart: Int

    func body(content: Content) -> some View {
        let globalFrame = geometry.frame(in: .global)
        let minX = globalFrame.minX

        let intermediateCoeff: CGFloat = CGFloat(allParts) - CGFloat(currentPart) + 1
        let coeff = intermediateCoeff - minX / globalFrame.width * CGFloat(allParts) * 1.5

        return content
            .opacity({ () -> Double in
                return Double(coeff)
            }())
            .transformEffect({ () -> CGAffineTransform in
                return .init(translationX: translation - translation * min(coeff, 1), y: 0)
            }())
    }

}

struct OnboardingScreenView: View {

    private enum Constants {
        static let appIconSize: CGFloat = 150
        static let appIconCornerRadius: CGFloat = 33
        static let assetSize: CGFloat = 300
        static let assetCornerRadius: CGFloat = 16
        static let sfSymbolFontSize: CGFloat = 90

        static let imageToTitleSpacing: CGFloat = 50
        static let titleToSubtitleSpacing: CGFloat = 18

        static let translation: CGFloat = 10

        static let buttonBorderRadius: CGFloat = 14
    }

    let onCompleted: PizzaEmptyClosure?
    let onSkip: PizzaEmptyClosure?

    let config: PizzaOnboardingConfig

    private struct Item {
        let index: Int
        let screenItem: PizzaOnboardingScreenItem
    }
    @State
    private var items: [Item]
    @State private var selection: Int = 0

    init(
        config: PizzaOnboardingConfig,
        onCompleted: PizzaEmptyClosure?,
        onSkip: PizzaEmptyClosure?
    ) {
        self.onCompleted = onCompleted
        self.onSkip = onSkip
        self.config = config
        self.items = config.items.enumerated().map {
            .init(index: $0.offset, screenItem: $0.element)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(config.skipButtonTitle) {
                    onSkip?()
                }
                .buttonStyle(.plain)
                .foregroundStyle(.tint)
                .padding()
                .opacity({
                    if selection == items.last?.index {
                        return 0
                    }
                    return 1
                }())
            }
            TabView(selection: $selection) {
                ForEach(items, id: \.index) { item in
                    ZStack {
                        GeometryReader(content: { geometry in
                            ZStack {
                                VStack {
                                    Spacer()
                                    switch item.screenItem.icon {
                                    case .appIcon:
                                        Image(uiImage: UIImage(named: config.appIconName)!)
                                            .resizable()
                                            .clipShape(
                                                RoundedRectangle(
                                                    cornerRadius: Constants.appIconCornerRadius
                                                )
                                            )
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: Constants.appIconSize)
                                            .opacityTranslation(
                                                geometry: geometry,
                                                translation: Constants.translation,
                                                allParts: 3,
                                                currentPart: 1
                                            )
                                    case .customAsset(let image):
                                        image
                                            .resizable()
                                            .clipShape(
                                                RoundedRectangle(
                                                    cornerRadius: Constants.assetCornerRadius
                                                )
                                            )
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: Constants.assetSize)
                                            .opacityTranslation(
                                                geometry: geometry,
                                                translation: Constants.translation,
                                                allParts: 3,
                                                currentPart: 1
                                            )
                                    case .pizzaIcon(let icon):
                                        PizzaSUIIconView(icon: icon, shouldBounce: true)
                                            .opacityTranslation(
                                                geometry: geometry,
                                                translation: Constants.translation,
                                                allParts: 3,
                                                currentPart: 1
                                            )
                                    }

                                    Spacer()
                                        .frame(height: min(max(geometry.size.height / 18, 12), 50))

                                        Text(
                                            item
                                                .screenItem
                                                .title
                                                .split(symbol: "|")
                                                .map { part in
                                                    var str = AttributedString(part.string)
                                                    str.font = .title.weight(.bold)
                                                    str.foregroundColor = {
                                                        if part.isInside {
                                                            return Color.accentColor
                                                        }
                                                        return Color.primary
                                                    }()
                                                    return str
                                                }
                                            .reduce(AttributedString(), { partialResult, current in
                                                partialResult + current
                                            })
                                        )
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                        .opacityTranslation(
                                            geometry: geometry,
                                            translation: Constants.translation,
                                            allParts: 3,
                                            currentPart: 2
                                        )

                                    Spacer()
                                        .frame(height: 18)

                                    Text(item.screenItem.description)
                                        .font(.system(size: 16))
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                        .opacityTranslation(
                                            geometry: geometry,
                                            translation: Constants.translation,
                                            allParts: 3,
                                            currentPart: 3
                                        )

                                    Spacer(minLength: 60)
                                }
                                .frame(maxWidth: PizzaDesignConstants.maxSmallWidth)
                            }
                            .frame(maxWidth: .infinity)
                        })

                    }
                    .tag(item.index)
                }
            }
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .tabViewStyle(.page(indexDisplayMode: .always))

            Button {
                if selection == items.last?.index {
                    onCompleted?()
                } else {
                    withAnimation {
                        selection = (selection + 1) % items.count
                    }
                }
            } label: {
                HStack {
                    if selection == items.last?.index {
                        Text(config.completeButtonTitle)
                    } else {
                        Text(config.nextButtonTitle)
                        Image(systemSymbol: .arrowRight)
                            .offset(y: 0.3)
                    }

                }
                .frame(maxWidth: .infinity)
            }
            .buttonBorderShape(.roundedRectangle(radius: Constants.buttonBorderRadius))
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .font(.system(size: 17, weight: .semibold))
            .padding()
            .frame(maxWidth: PizzaDesignConstants.maxSmallWidth)
        }
        .frame(maxWidth: .infinity)
    }
}

struct OnboardingScreenView_Previews: PreviewProvider {

    static var previews: some View {
        OnboardingScreenView(
            config: .init(
                appIconName: "AppIcon",
                skipButtonTitle: "Skip",
                completeButtonTitle: "Complete",
                nextButtonTitle: "Next",
                items: [
                    .init(
                        title: "New in our app\n|NAME OF APP|",
                        description: "New feature description",
                        icon: .pizzaIcon(
                            .init(
                                sfSymbol: .rosette
                            )
                            .apply(
                                preset: .teaserDimmedBGColoredLarge, 
                                color: .tintColor
                            )
                        )
                    ),
                    .init(
                        title: "Start using today",
                        description: "Available from now for all users",
                        icon: .pizzaIcon(
                            .init(
                                sfSymbol: .gearshape2
                            )
                            .apply(preset: .teaserTransparentLarge, color: .tintColor)
                        )
                    )
                ]
            ),
            onCompleted: {
                print("oncompleted")
            },
            onSkip: {
                print("onskip")
            }
        )
    }
}
