import SwiftUI

public struct SplashView: View {
    
    public let onAnimationEnd: () -> Void
    
    @State private var scaleEffect = 0.0
    @State private var opacity = 0.0
    @State private var rotationAngle = 0.0
    
    public init(onAnimationEnd: @escaping () -> Void) {
        self.onAnimationEnd = onAnimationEnd
    }
    
    public var body: some View {
        ZStack {
            backgroundView()
            contentView()
        }
        .onAppear {
            startAnimations()
            navigateAfterDelay()
        }
    }
    
    // MARK: - Background View
    @ViewBuilder
    private func backgroundView() -> some View {
        DSPalette.brand
            .ignoresSafeArea(.all)
    }
    
    // MARK: - Content View
    @ViewBuilder
    private func contentView() -> some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                animatedLogo(maxWidth: geometry.size.width)
                Spacer()
            }
        }
    }
    
    // MARK: - Animated Logo
    @ViewBuilder
    private func animatedLogo(maxWidth: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: min(maxWidth * 0.6, 200))
                .scaleEffect(scaleEffect)
                .opacity(opacity)
            
            Image("AppIcon")
                .resizable()
                .scaledToFit()
                .frame(width: min(maxWidth * 0.4, 120))
                .scaleEffect(scaleEffect)
                .opacity(opacity)
                .rotationEffect(.degrees(rotationAngle))
        }
        .shadow(color: DSPalette.shadow.opacity(0.3), radius: 20, x: 0, y: 10)
    }
    
    // MARK: - Animations
    private func startAnimations() {
        // First animation: appear with scale and opacity (like Marvel)
        withAnimation(.easeOut(duration: 0.8)) {
            self.scaleEffect = 1.0
            self.opacity = 1.0
        }
        
        // Second animation: dramatic grow (Marvel effect)
        withAnimation(.easeInOut(duration: 1.0).delay(0.8)) {
            self.scaleEffect = 1.5
        }
        
        // Third animation: subtle rotation during growth
        withAnimation(.easeInOut(duration: 0.8).delay(1.0)) {
            self.rotationAngle = 15
        }
        
        // Fourth animation: scale down to normal (Marvel effect)
        withAnimation(.easeInOut(duration: 0.6).delay(1.5)) {
            self.scaleEffect = 1.0
            self.rotationAngle = 0
        }
        
        // Fifth animation: final pulse (Marvel effect)
        withAnimation(.easeInOut(duration: 0.4).delay(2.0)) {
            self.scaleEffect = 1.2
        }
        
        // Sixth animation: settle to final size
        withAnimation(.easeInOut(duration: 0.3).delay(2.4)) {
            self.scaleEffect = 1.0
        }
    }
    
    // MARK: - Navigation
    private func navigateAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.onAnimationEnd()
        }
    }
}

#if DEBUG
#Preview {
    SplashView(onAnimationEnd: {
        print("Splash animation completed")
    })
}
#endif
