import SwiftUI

struct GlassModifier: ViewModifier {
    var cornerRadius: CGFloat
    var shadowOpacity: Double
    var borderOpacity: Double
    var padding: CGFloat
    
    init(
        cornerRadius: CGFloat = 28,
        shadowOpacity: Double = 0.35,
        borderOpacity: Double = 0.25,
        padding: CGFloat = 20
    ) {
        self.cornerRadius = cornerRadius
        self.shadowOpacity = shadowOpacity
        self.borderOpacity = borderOpacity
        self.padding = padding
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        
        #if os(visionOS)
        if #available(visionOS 1.0, *) {
            content
                .padding(padding)
                .glassBackgroundEffect()
                .overlay(
                    shape
                        .stroke(Color.white.opacity(borderOpacity), lineWidth: 1)
                )
                .shadow(
                    color: Color.black.opacity(shadowOpacity),
                    radius: 28,
                    x: 0,
                    y: 18
                )
        } else {
            fallback(content: content, shape: shape)
        }
        #else
        fallback(content: content, shape: shape)
        #endif
    }
    
    @ViewBuilder
    private func fallback(content: Content, shape: RoundedRectangle) -> some View {
        content
            .padding(padding)
            .background(
                .ultraThinMaterial,
                in: shape
            )
            .overlay(
                shape
                    .stroke(Color.white.opacity(borderOpacity), lineWidth: 1)
            )
            .shadow(
                color: Color.black.opacity(shadowOpacity),
                radius: 24,
                x: 0,
                y: 16
            )
    }
}

extension View {
    func glassBackground(
        cornerRadius: CGFloat = 28,
        shadowOpacity: Double = 0.35,
        borderOpacity: Double = 0.25,
        padding: CGFloat = 20
    ) -> some View {
        modifier(
            GlassModifier(
                cornerRadius: cornerRadius,
                shadowOpacity: shadowOpacity,
                borderOpacity: borderOpacity,
                padding: padding
            )
        )
    }
}
