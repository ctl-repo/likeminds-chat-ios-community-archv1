//
//  LMChatParticipantView.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 15/02/24.
//

import Foundation
import Kingfisher

@IBDesignable
open class LMChatParticipantView: LMView {
    
    public struct ContentModel {
        public let name: String
        public let designationDetail: String?
        public let profileImageUrl: String?
        public let customTitle: String?
        public let isPending: Bool
        
        init(name: String, designationDetail: String?, profileImageUrl: String?, customTitle: String?, isPending: Bool) {
            self.name = name
            self.designationDetail = designationDetail
            self.profileImageUrl = profileImageUrl
            self.customTitle = customTitle
            self.isPending = isPending
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
    
    open private(set) lazy var participantContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 10
        return view
    }()
    
    open private(set) lazy var participantNameAndDesignationContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 5
        return view
    }()
    
    open private(set) lazy var participantNameContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 4
        return view
    }()
    
    open private(set) lazy var participantDesignationContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 2
        return view
    }()
    
    open private(set) lazy var nameLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Participant name"
        label.font = Appearance.shared.fonts.headingFont1
        label.textColor = Appearance.shared.colors.black
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    open private(set) lazy var designationLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Software engineer @ Likeminds"
        label.font = Appearance.shared.fonts.textFont2
        label.numberOfLines = 1
        label.textColor = Appearance.shared.colors.textColor
        return label
    }()
    
    open private(set) lazy var customTitle: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "CM"
        label.font = Appearance.shared.fonts.textFont2
        label.numberOfLines = 1
        label.textColor = Appearance.shared.colors.textColor
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    open private(set) lazy var pendingTextLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Pending"
        label.font = Appearance.shared.fonts.textFont2
        label.numberOfLines = 1
        label.textColor = .systemGreen
        return label
    }()
    
    open private(set) lazy var spacerForNamesStackView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.setWidthConstraint(with: 4, relatedBy: .greaterThanOrEqual)
        return view
    }()
    
    open private(set) lazy var profileImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 54)
        image.setHeightConstraint(with: 54)
        image.image = Constants.shared.images.personCircleFillIcon
        image.cornerRadius(with: 27)
        return image
    }()
  
    open private(set) lazy var moreActionsContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 10
        return view
    }()
    
    open private(set) lazy var rejectImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 40)
        image.setHeightConstraint(with: 40)
        image.contentMode = .center
        image.image = Constants.shared.images.crossIcon.withSystemImageConfig(pointSize: 30, weight: .light, scale: .large)
        image.tintColor = .lightGray
        image.isUserInteractionEnabled = true
        return image
    }()
    
    open private(set) lazy var approveImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 40)
        image.setHeightConstraint(with: 40)
        image.contentMode = .center
        image.image = Constants.shared.images.checkmarkCircleIcon.withSystemImageConfig(pointSize: 30, weight: .light, scale: .large)
        image.tintColor = .systemGreen
        image.isUserInteractionEnabled = true
        return image
    }()
    
    open private(set) lazy var moreOptionsImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 40)
        image.setHeightConstraint(with: 40)
        image.contentMode = .center
        image.image = Constants.shared.images.ellipsisIcon
        image.tintColor = .black
        image.isUserInteractionEnabled = true
        return image
    }()
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(participantContainerStackView)
        participantDesignationContainerStackView.addArrangedSubview(designationLabel)
        participantNameContainerStackView.addArrangedSubview(nameLabel)
        participantNameContainerStackView.addArrangedSubview(customTitle)
        participantNameContainerStackView.addArrangedSubview(spacerForNamesStackView)
        participantNameAndDesignationContainerStackView.addArrangedSubview(participantNameContainerStackView)
        participantNameAndDesignationContainerStackView.addArrangedSubview(participantDesignationContainerStackView)
        participantContainerStackView.addArrangedSubview(profileImageView)
        participantContainerStackView.addArrangedSubview(participantNameAndDesignationContainerStackView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: containerView)
        containerView.pinSubView(subView: participantContainerStackView, padding: .init(top: 12, left: 16, bottom: -12, right: -16))
    }
    
    open func setData(_ data: ContentModel) {
        nameLabel.text = data.name
        designationLabel.text = data.designationDetail
        customTitle.text =  data.customTitle != nil ? "\(Constants.Strings.shared.dot) " + (data.customTitle ?? "") : nil
        let names =   data.name.components(separatedBy: " ")
        var nameCombined = ""
        if names.count > 2 {
            nameCombined = "\(names[0]) \(names[2])"
        } else if names.count > 1 {
            nameCombined = "\(names[0]) \(names[1])"
        } else {
            nameCombined = data.name
        }
        let placeholder = UIImage.generateLetterImage(name: nameCombined)
        if let imageUrl = data.profileImageUrl, let url = URL(string: imageUrl) {
            profileImageView.kf.setImage(with: url, placeholder: placeholder)
        } else {
            profileImageView.image = placeholder
        }
    }
}

