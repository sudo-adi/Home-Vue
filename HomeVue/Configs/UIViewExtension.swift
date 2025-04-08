//
//  UIViewExtension.swift
//  Home Vue
//
//  Created by student-2 on 09/12/24.
//

import Foundation
import UIKit

extension UIView {
    /// - Parameter radius: The corner radius value. If not specified, the view will use half of its height to create a circular shape.
    func addCornerRadius(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    func addBlurEffect(style: UIBlurEffect.Style = .dark) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.addSubview(blurEffectView)
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
