import Foundation
import UIKit

extension UIView {
    /// - Parameter radius: The corner radius value. If not specified, the view will use half of its height to create a circular shape.
    func addCornerRadius(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    func applyOverlay(alpha: CGFloat = 0.25) {
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(alpha)
        overlay.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(overlay)

        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: self.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func applyGlassmorphism() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 20
        blurView.clipsToBounds = true
        blurView.alpha = 0.7

        self.insertSubview(blurView, at: 0)

        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        self.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        self.clipsToBounds = true
    }
    
    func applyGradientBackground(startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.0, y: 1.0)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.gradientStartColor.cgColor, UIColor.gradientEndColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint

        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
