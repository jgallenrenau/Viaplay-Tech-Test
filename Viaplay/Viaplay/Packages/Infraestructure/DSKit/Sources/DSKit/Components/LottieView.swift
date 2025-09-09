import SwiftUI
import Lottie

public struct LottieView: UIViewRepresentable {
    let name: String                 // "Loading"
    var loopMode: LottieLoopMode = .loop
    var accessibilityLabel: String?
    var accessibilityHint: String?

    public func makeUIView(context: Context) -> UIView {
        let container = UIView()
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: container.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode

        // Preferred: explicit subdirectory lookup (name WITHOUT folder or ".json")
        if let anim = LottieAnimation.named(name, bundle: .module) {
            animationView.animation = anim
        } else if let url = Bundle.module.url(forResource: name, withExtension: "json"),
                  let anim = LottieAnimation.filepath(url.path) {
            animationView.animation = anim
        }

        if let label = accessibilityLabel {
            animationView.isAccessibilityElement = true
            animationView.accessibilityLabel = label
        }
        if let hint = accessibilityHint {
            animationView.accessibilityHint = hint
        }

        animationView.play()
        return container
    }

    public func updateUIView(_ uiView: UIView, context: Context) { }
}
