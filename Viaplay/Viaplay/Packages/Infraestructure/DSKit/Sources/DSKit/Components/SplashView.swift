import SwiftUI

#if canImport(UIKit)
import UIKit

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
        VStack {
            Spacer()
            animatedLogo()
            Spacer()
        }
    }
    
    // MARK: - Animated Logo
    @ViewBuilder
    private func animatedLogo() -> some View {
        ZStack {
            // Background circle - fixed size for perfect centering
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 250, height: 250)
                .scaleEffect(scaleEffect)
                .opacity(opacity)
            
            // Icon perfectly centered in the circle
            Group {
                if let appIconModule = UIImage(named: "AppIcon", in: .module, compatibleWith: nil) {
                    let _ = print("✅ [SplashView] AppIcon loaded successfully from DSKit module bundle")
                    Image(uiImage: appIconModule)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } else if let appIconMain = UIImage(named: "AppIcon", in: .main, compatibleWith: nil) {
                    let _ = print("✅ [SplashView] AppIcon loaded successfully from main bundle")
                    Image(uiImage: appIconMain)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } else {
                    let _ = print("❌ [SplashView] AppIcon not found in module nor main bundle, using fallback")
                    // Fallback to system icon - bigger
                    Image(systemName: "play.rectangle.fill")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                }
            }
            .scaleEffect(scaleEffect)
            .opacity(opacity)
            .rotationEffect(.degrees(rotationAngle))
        }
        .frame(width: 350, height: 350)
        .shadow(color: DSPalette.shadow.opacity(0.3), radius: 20, x: 0, y: 10)
    }
    
    // MARK: - Animations
    private func startAnimations() {
        // First animation: appear with scale and opacity
        withAnimation(.easeOut(duration: 0.8)) {
            self.scaleEffect = 2.0
            self.opacity = 1.0
        }
        
        // Second animation: dramatic grow - bigger growth
        withAnimation(.easeInOut(duration: 1.0).delay(0.8)) {
            self.scaleEffect = 5.0
        }
        
        // Third animation: subtle rotation during growth
        withAnimation(.easeInOut(duration: 0.8).delay(1.0)) {
            self.rotationAngle = 25
        }
        
        // Fourth animation: scale down to normal
        withAnimation(.easeInOut(duration: 0.6).delay(1.5)) {
            self.scaleEffect = 3.0
            self.rotationAngle = 0
        }
        
        // Fifth animation: final pulse  - bigger pulse
        withAnimation(.easeInOut(duration: 0.4).delay(2.0)) {
            self.scaleEffect = 1.5
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

#else
// Fallback for platforms without UIKit
public struct SplashView: View {
    public let onAnimationEnd: () -> Void
    
    public init(onAnimationEnd: @escaping () -> Void) {
        self.onAnimationEnd = onAnimationEnd
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Text("Viaplay")
                .font(.largeTitle)
                .foregroundColor(.white)
            Spacer()
        }
        .background(Color.blue)
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onAnimationEnd()
            }
        }
    }
}
#endif
