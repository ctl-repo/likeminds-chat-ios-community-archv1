//
//  LMShimmeringView.swift
//  Pods
//
//  Created by Anurag Tyagi on 28/10/24.
//


import UIKit

open class LMShimmeringView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShimmerLayer()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShimmerLayer()
    }
    
    private func setupShimmerLayer() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        let lightColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        let darkColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        gradientLayer.colors = [darkColor, lightColor, darkColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)
        startShimmerAnimation()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func startShimmerAnimation() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
}
