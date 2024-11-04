//
//  LMChatBubbleShimmerView.swift
//  Pods
//
//  Created by Anurag Tyagi on 28/10/24.
//

import UIKit

open class LMChatBubbleShimmerView: UIView {
    
    private let shimmerView = LMShimmeringView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChatBubbleShimmer()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupChatBubbleShimmer()
    }
    
    private func setupChatBubbleShimmer() {
        shimmerView.layer.cornerRadius = 16
        shimmerView.clipsToBounds = true
        shimmerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shimmerView)
        
        NSLayoutConstraint.activate([
            shimmerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shimmerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shimmerView.topAnchor.constraint(equalTo: topAnchor),
            shimmerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
