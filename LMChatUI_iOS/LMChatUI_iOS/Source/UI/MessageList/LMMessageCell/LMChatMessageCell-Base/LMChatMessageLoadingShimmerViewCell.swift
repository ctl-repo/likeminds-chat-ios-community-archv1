//
//  LMChatMessageLoadingShimmerView.swift
//  Pods
//
//  Created by Anurag Tyagi on 28/10/24.
//


import Foundation

open class LMChatMessageLoadingShimmerViewCell: LMChatMessageCell {
    
    open private(set) lazy var messageContainerView: LMView = {
        let view = LMView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    open private(set) lazy var stackView: LMStackView = {
        let stack = LMStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 8
        return stack
    }()
    
    
    open override func setupViews() {
        super.setupViews()
        addSubview(stackView)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: stackView, padding: .init(top: 16, left: 10, bottom: 0, right: 0))
        
        let shimmer = LMChatMessageTypingShimmer()
        shimmer.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(shimmer)
        
        let uiView = UIView()
        uiView.setHeightConstraint(with: 20)
        
        stackView.addArrangedSubview(uiView)
    }
}
