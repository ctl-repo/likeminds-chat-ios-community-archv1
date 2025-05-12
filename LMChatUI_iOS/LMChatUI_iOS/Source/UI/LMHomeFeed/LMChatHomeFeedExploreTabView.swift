//
//  LMChatHomeFeedExploreTabView.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 09/02/24.
//

import Kingfisher
import UIKit

@IBDesignable
open class LMChatHomeFeedExploreTabView: LMView {
    
    public struct ContentModel {
        public let tilesName: String
        public let tilesIcon: String?
        public let unreadCount: Int
        public let totalCount: Int
        
        init(tilesName: String, tilesIcon: String?, unreadCount: Int, totalCount: Int) {
            self.tilesName = tilesName
            self.tilesIcon = tilesIcon
            self.unreadCount = unreadCount
            self.totalCount = totalCount
        }
    }
    
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var subviewContainer: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.cornerRadius(with: 8)
        view.backgroundColor = Appearance.shared.colors.gray3
        return view
    }()
    
    open private(set) lazy var exploreContainerStackView: LMStackView = { [unowned self] in
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = 10
        return view
    }()

    open private(set) lazy var exploreNameContainerStackView: LMStackView = { [unowned self] in
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 10
        return view
    }()
    open private(set) lazy var exploreNameVerticalStack: LMStackView = { [unowned self] in
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 10
        return view
    }()
    
    
    open private(set) lazy var exploreTitleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Explore Groups"
        label.font = Appearance.shared.fonts.headingFont1
        label.textColor = Appearance.shared.colors.black
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    open private(set) lazy var exploreSubheading: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Connect, chat, and grow together"
        label.font = Appearance.shared.fonts.subHeadingFont1
        label.textColor = Appearance.shared.colors.previewSubtitleTextColor
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    open private(set) lazy var exploreIconImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 54)
        image.setHeightConstraint(with: 54)
        image.contentMode = .center
        image.image = Constants.shared.images.personCircleFillIcon.withSystemImageConfig(pointSize: 30)
        image.cornerRadius(with: 27)
        return image
    }()
    
    open private(set) lazy var spacerBetweenTitleAndArrowIcon: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.setWidthConstraint(with: 4, relatedBy: .greaterThanOrEqual)
        return view
    }()
    
    open private(set) lazy var rightArrowIconImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 18)
        image.setHeightConstraint(with: 18)
        image.contentMode = .scaleAspectFit
        image.image = Constants.shared.images.rightArrowIcon
        image.tintColor = .lightGray
        return image
    }()
    
    open private(set) lazy var chatroomCountBadgeLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = ""
        label.font = Appearance.shared.fonts.headingFont2
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.setWidthConstraint(with: 18, relatedBy: .greaterThanOrEqual)
        label.setHeightConstraint(with: 18)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.cornerRadius(with: 9)
        label.setPadding(with: UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        return label
    }()
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(exploreContainerStackView)
        exploreContainerStackView.addArrangedSubview(exploreIconImageView)
//        exploreContainerStackView.addArrangedSubview(exploreNameContainerStackView)
        exploreNameContainerStackView.addArrangedSubview(exploreTitleLabel)
        exploreNameContainerStackView.addArrangedSubview(spacerBetweenTitleAndArrowIcon)
        exploreNameContainerStackView.addArrangedSubview(chatroomCountBadgeLabel)
//        exploreNameContainerStackView.addArrangedSubview(rightArrowIconImageView)
        exploreContainerStackView.addArrangedSubview(exploreNameVerticalStack)
        exploreNameVerticalStack.addArrangedSubview(exploreNameContainerStackView)
        exploreNameVerticalStack.addArrangedSubview(exploreSubheading)
        exploreContainerStackView.addArrangedSubview(rightArrowIconImageView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: containerView)
        containerView.pinSubView(subView: exploreContainerStackView, padding: .init(top: 16, left: 16, bottom: -16, right: -16))
    }
    
    open func setData(_ data: ContentModel) {
        exploreTitleLabel.text = data.tilesName
        chatroomCountBadgeLabel.isHidden = false
        if data.unreadCount <= 0 {
            if data.totalCount <= 0 {
                chatroomCountBadgeLabel.isHidden = true
            } else  {
                chatroomCountBadgeLabel.text = data.totalCount > 99 ? "99+" : "\(data.totalCount) Chatrooms"
            }
        } else {
            chatroomCountBadgeLabel.text = data.unreadCount > 99 ? "99+" : "\(data.unreadCount) NEW"
        }
    }
}
