//
//  LMChatPollOptionView.swift
//  LikeMindsChatUI
//
//  Created by Pushpendra Singh on 24/07/24.
//

import UIKit

public protocol LMChatDisplayPollWidgetProtocol: AnyObject {
    func didTapVoteCountButton(optionID: String)
    func didTapToVote(optionID: String)
}

open class LMChatPollOptionView: LMBasePollOptionView {
    
    // MARK: UI Elements
    open private(set) lazy var outerStackView: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    open private(set) lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = Appearance.shared.colors.appTintColor.withAlphaComponent(0.1)
        progress.trackTintColor = Appearance.shared.colors.clear
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    open private(set) lazy var voteCountContainer: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = Appearance.shared.colors.clear
        return view
    }()
    
    open private(set) lazy var voteCount: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setTitle("Vote Count", for: .normal)
        button.setImage(nil, for: .normal)
        button.setFont(Appearance.shared.fonts.buttonFont1)
        button.setTitleColor(Appearance.shared.colors.gray155, for: .normal)
        return button
    }()
    
    open private(set) lazy var innerContainerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = Appearance.shared.colors.clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    open private(set) lazy var checkmarkIcon: LMImageView = {
        let image = Constants.shared.images.checkmarkIconFilled
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(font: Appearance.shared.fonts.headingFont1))
        
        let imageView = LMImageView(image: image)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Appearance.shared.colors.appTintColor
        return imageView
    }()
    
    open private(set) lazy var checkMarkIconStackView: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: Data Variables
    open var selectedPollColor: UIColor {
        return Appearance.shared.colors.appTintColor
    }
    
    open var notSelectedPollColor: UIColor {
        return UIColor(r: 230, g: 235, b: 245)
    }
    
    public weak var delegate: LMChatDisplayPollWidgetProtocol?
    public var optionID: String?
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        
        addSubview(containerView)
        containerView.addSubview(outerStackView)
        
        voteCountContainer.addSubview(voteCount)
        
        outerStackView.addArrangedSubview(innerContainerView)
        outerStackView.addArrangedSubview(voteCountContainer)
        
        innerContainerView.addSubview(progressView)
        innerContainerView.addSubview(stackView)
        innerContainerView.addSubview(checkMarkIconStackView)
        checkMarkIconStackView.addArrangedSubview(checkmarkIcon)
        
        stackView.addArrangedSubview(optionLabel)
        stackView.addArrangedSubview(addedByLabel)
    }
    
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        pinSubView(subView: containerView)
        containerView.pinSubView(subView: outerStackView)
        
        innerContainerView.addConstraint(leading: (outerStackView.leadingAnchor, 0),
                                         trailing: (outerStackView.trailingAnchor, 0))
        innerContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        voteCount.addConstraint(top: (voteCountContainer.topAnchor, 0),
                                bottom: (voteCountContainer.bottomAnchor, 0),
                                leading: (voteCountContainer.leadingAnchor, 8))
        voteCount.trailingAnchor.constraint(lessThanOrEqualTo: voteCountContainer.trailingAnchor, constant: -8).isActive = true
        
        stackView.addConstraint(top: (innerContainerView.topAnchor, 8),
                                bottom: (innerContainerView.bottomAnchor, -8),
                                leading: (innerContainerView.leadingAnchor, 12))
        
        checkMarkIconStackView.addConstraint(leading: (stackView.trailingAnchor, 8),
                                    trailing: (innerContainerView.trailingAnchor, -12),
                                    centerY: (stackView.centerYAnchor, 0))
        checkmarkIcon.setWidthConstraint(with: 24)
        checkmarkIcon.setHeightConstraint(with: 24)
        
        innerContainerView.pinSubView(subView: progressView)
        
        optionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        addedByLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        optionLabel.numberOfLines = 0
        optionLabel.lineBreakMode = .byCharWrapping
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        
        innerContainerView.clipsToBounds = true
        innerContainerView.layer.cornerRadius = 10
        innerContainerView.layer.borderWidth = 1
        innerContainerView.layer.borderColor = Appearance.shared.colors.pollOptionBorderColor.cgColor
        innerContainerView.backgroundColor = Appearance.shared.colors.white
    }
    
    
    // MARK: setupActions
    open override func setupActions() {
        voteCount.addTarget(self, action: #selector(didTapVoteCount), for: .touchUpInside)
        innerContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapVote)))
    }
    
    @objc
    open func didTapVoteCount() {
        guard let optionID else { return }
        
        delegate?.didTapVoteCountButton(optionID: optionID)
    }
    
    @objc
    open func didTapVote() {
        guard let optionID else { return }
        
        delegate?.didTapToVote(optionID: optionID)
    }
    
    open func configure(with data: PollViewData, delegate: LMChatDisplayPollWidgetProtocol?) {
        self.delegate = delegate
        self.optionID = data.id
        
        optionLabel.text = data.text
        
        addedByLabel.text = "Added By \(data.member?.name ?? "")"
        addedByLabel.isHidden = data.member?.name?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != false
        
        voteCountContainer.isHidden = !(data.showVoteCount ?? false)
        voteCount.setTitle("\(data.noVotes ?? 0) vote\((data.noVotes ?? 0) < 2 ? "" : "s")", for: .normal)
        
        checkmarkIcon.isHidden = !(data.showTickButton ?? false)
        
        progressView.isHidden = !(data.showProgressBar ?? false)
        progressView.progress = Float((data.percentage ?? 0) / 100)
        progressView.progressTintColor = (data.isSelected ?? false) ? selectedPollColor.withAlphaComponent(0.2) : notSelectedPollColor
        
        innerContainerView.layer.borderColor = (data.isSelected ?? false) ? selectedPollColor.cgColor : notSelectedPollColor.cgColor
        optionLabel.textColor = (data.isSelected ?? false) ? selectedPollColor : Appearance.shared.colors.black
    }
}
