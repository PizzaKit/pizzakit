import SwiftUI
import WidgetKit

public extension View {
    func containerBackgroundForWidget<Background>(
        @ViewBuilder background: @escaping () -> Background
    ) -> some View where Background: View {
        modifier(ContainerBackgroundForWidgetModifier(background: background))
    }
}

public struct ContainerBackgroundForWidgetModifier<Background>: ViewModifier where Background: View {

    public let background: () -> Background

    public func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.containerBackground(for: .widget) {
                background()
            }
        } else {
            ZStack {
                background()
                content
                    .padding()
            }
        }
    }

}
