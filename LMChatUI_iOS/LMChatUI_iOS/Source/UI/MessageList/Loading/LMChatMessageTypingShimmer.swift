//
//  LMChatMessageLoading 2.swift
//  Pods
//
//  Created by Anurag Tyagi on 28/10/24.
//


//
//  LMChatMessageLoading.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 01/05/24.
//

import Foundation

@IBDesignable
open class LMChatMessageTypingShimmer: LMView {
    
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    var receivedBubble = Constants.shared.images.bubbleReceived.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21), resizingMode: .stretch)
        .withRenderingMode(.alwaysTemplate)
    var incomingColor = Appearance.shared.colors.incomingColor
    
    open private(set) lazy var incomingImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.backgroundColor = Appearance.shared.colors.clear
        return image
    }()
    
    open private(set) lazy var incomingMessageTitleView: LMChatShimmerView = {
        let view = LMUIComponents.shared.shimmerView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setHeightConstraint(with: 14)
        view.cornerRadius(with: 7)
        view.setWidthConstraint(with: 160)
        view.backgroundColor = Appearance.shared.colors.previewSubtitleTextColor
        return view
    }()
    
    open private(set) lazy var incomingMessageTitleView2: LMChatShimmerView = {
        let view = LMUIComponents.shared.shimmerView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setHeightConstraint(with: 14)
        view.setWidthConstraint(with: 100)
        view.cornerRadius(with: 7)
        view.backgroundColor = Appearance.shared.colors.previewSubtitleTextColor
        return view
    }()
    
    open private(set) lazy var incomingStackContainer: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = 8
        view.backgroundColor = Appearance.shared.colors.clear
        return view
    }()
    
    open override func setupAppearance() {
        super.setupAppearance()
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(incomingImageView)
        
        incomingStackContainer.addArrangedSubview(incomingMessageTitleView)
        incomingStackContainer.addArrangedSubview(incomingMessageTitleView2)
        
        incomingImageView.addSubview(incomingStackContainer)
        
        incomingImageView.tintColor = incomingColor
        incomingImageView.image = receivedBubble
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: containerView)
        NSLayoutConstraint.activate([
            incomingImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            incomingImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            incomingStackContainer.leadingAnchor.constraint(equalTo: incomingImageView.leadingAnchor, constant: 12),
            incomingStackContainer.trailingAnchor.constraint(equalTo: incomingImageView.trailingAnchor, constant: -30),
            incomingStackContainer.topAnchor.constraint(equalTo: incomingImageView.topAnchor,constant: 12),
            incomingStackContainer.bottomAnchor.constraint(equalTo: incomingImageView.bottomAnchor,constant: -12),
        ])
    }
}
