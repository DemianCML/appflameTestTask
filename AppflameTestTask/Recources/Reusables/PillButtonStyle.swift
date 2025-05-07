import SwiftUI

struct PillButtonStyle: ButtonStyle {
    let isSelected: Bool
    let selectedColor: Color = Color(.secondaryLightGreen)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(
                Capsule()
                    .fill(isSelected ? selectedColor : .clear)
            )
    }
}
