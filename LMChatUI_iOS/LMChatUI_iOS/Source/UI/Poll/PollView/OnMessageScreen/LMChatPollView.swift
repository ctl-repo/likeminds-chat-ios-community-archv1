//
//  LMChatPollView.swift
//  LikeMindsChatUI
//
//  Created by Pushpendra Singh on 24/07/24.
//

import UIKit

public protocol LMChatPollViewDelegate: AnyObject {
    func didTapVoteCountButton(for chatroomId: String, messageId: String, optionID: String?)
    func didTapToVote(for chatroomId: String, messageId: String, optionID: String)
    func didTapSubmitVote(for chatroomId: String, messageId: String)
    func editVoteTapped(for chatroomId: String, messageId: String)
    func didTapAddOption(for chatroomId: String, messageId: String)
}

open class LMChatPollView: LMBasePollView {
    // MARK: UI Elements
    open private(set) lazy var bottomStack: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 16
        return stack
    }()
    
    open private(set) lazy var topStack: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    open private(set) lazy var submitButton: LMButton = {
        let button = LMButton.createButton(with: Constants.shared.strings.submitVote, image:nil, textColor: Appearance.shared.colors.white, textFont: Appearance.shared.fonts.buttonFont2, contentSpacing: .init(top: 12, left: 20, bottom: 12, right: 20))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Appearance.shared.colors.white
        button.backgroundColor = Appearance.shared.colors.appTintColor
        return button
    }()
    
    open private(set) lazy var bottomMetaStack: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    open private(set) lazy var topMetaStack: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    open private(set) lazy var topMetaStackSpacer: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 4).isActive = true
        return view
    }()
    
    open private(set) lazy var answerTitleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.textColor = Appearance.shared.colors.appTintColor
        label.font = Appearance.shared.fonts.textFont1
        label.text = ""
        label.isUserInteractionEnabled = true
        return label
    }()
    
    open private(set) lazy var editVoteButton: LMButton = {
        let button = LMButton.createButton(with: Constants.shared.strings.editVote, image: nil, textColor: Appearance.shared.colors.white, textFont: Appearance.shared.fonts.buttonFont2, contentSpacing: .init(top: 12, left: 20, bottom: 12, right: 20))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Appearance.shared.colors.white
        button.backgroundColor = Appearance.shared.colors.appTintColor
        return button
    }()
    
    open private(set) lazy var addOptionButton: LMButton = {
        let button = LMButton.createButton(with: Constants.shared.strings.addNewOption, image: Constants.shared.images.plusIcon.withSystemImageConfig(pointSize: 12), textColor: Appearance.shared.colors.black, textFont: Appearance.shared.fonts.buttonFont1, contentSpacing: .init(top: 12, left: 0, bottom: 12, right: 0), imageSpacing: 2)
        button.tintColor = Appearance.shared.colors.black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    open private(set) lazy var questionAndSelectcount: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 2
        return stack
    }()
    
    
    // MARK: Data Variables
    public weak var delegate: LMChatPollViewDelegate?
    public var chatroomId: String?
    public var messageId: String?
    
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        
        addSubview(containerView)
        containerView.addSubview(questionContainerStackView)
        
        questionContainerStackView.addArrangedSubview(topStack)
        questionContainerStackView.addArrangedSubview(questionAndSelectcount)
        questionAndSelectcount.addArrangedSubview(questionTitle)
        questionAndSelectcount.addArrangedSubview(optionSelectCountLabel)
        
        containerView.addSubview(optionStackView)
        containerView.addSubview(bottomStack)
        
        bottomStack.addArrangedSubview(addOptionButton)
        bottomStack.addArrangedSubview(bottomMetaStack)
        bottomStack.addArrangedSubview(submitButton)
        bottomStack.addArrangedSubview(editVoteButton)
        
        bottomMetaStack.addArrangedSubview(answerTitleLabel)
        topStack.addArrangedSubview(pollTypeLabel)
        topStack.addArrangedSubview(topMetaStack)
        topMetaStack.addArrangedSubview(pollImageView)
        topMetaStack.addArrangedSubview(topMetaStackSpacer)
        topMetaStack.addArrangedSubview(expiryDateLabel)
    }
    
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        pinSubView(subView: containerView)
        let standardMargin: CGFloat = 8
        questionContainerStackView.addConstraint(top: (containerView.topAnchor, 4),
                                                 leading: (containerView.leadingAnchor, standardMargin),
                                                 trailing: (containerView.trailingAnchor, -standardMargin))
        
        optionStackView.addConstraint(top: (questionContainerStackView.bottomAnchor, standardMargin + 8),
                                      leading: (questionContainerStackView.leadingAnchor, 0),
                                      trailing: (questionContainerStackView.trailingAnchor, 0))
        
        addOptionButton.addConstraint(leading: (bottomStack.leadingAnchor, 0),
                                      trailing: (bottomStack.trailingAnchor, 0))
        
        bottomStack.addConstraint(top: (optionStackView.bottomAnchor, standardMargin),
                                  bottom: (containerView.bottomAnchor, -standardMargin),
                                  leading: (optionStackView.leadingAnchor, 0),
                                  trailing: (optionStackView.trailingAnchor, 0))
        
        bottomMetaStack.trailingAnchor.constraint(lessThanOrEqualTo: bottomStack.trailingAnchor, constant: -16).isActive = true
        pollImageView.setWidthConstraint(with: 22)
        pollImageView.setHeightConstraint(with: 22)
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        
        addOptionButton.layer.borderColor = Appearance.shared.colors.pollOptionBorderColor.cgColor
        addOptionButton.layer.borderWidth = 1
        addOptionButton.layer.cornerRadius = 8
        expiryDateLabel.cornerRadius(with: 11)
        submitButton.layer.cornerRadius = 8
        editVoteButton.layer.cornerRadius = 8
    }
    
    
    // MARK: setupActions
    open override func setupActions() {
        super.setupActions()
        
        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        editVoteButton.addTarget(self, action: #selector(editVoteTapped), for: .touchUpInside)
        answerTitleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(voteCountTapped)))
        addOptionButton.addTarget(self, action: #selector(didTapAddOption), for: .touchUpInside)
    }
    
    @objc
    open func didTapSubmitButton() {
        guard let chatroomId,
              let messageId else { return }
        delegate?.didTapSubmitVote(for: chatroomId, messageId: messageId)
    }
    
    @objc
    open func editVoteTapped() {
        guard let chatroomId,
              let messageId else { return }
        
        delegate?.editVoteTapped(for: chatroomId, messageId: messageId)
    }
    
    @objc
    open func voteCountTapped() {
        guard let chatroomId,
              let messageId else { return }
        
        delegate?.didTapVoteCountButton(for: chatroomId, messageId: messageId, optionID: nil)
    }
    
    
    @objc
    open func didTapAddOption() {
        guard let chatroomId,
              let messageId else { return }
        
        delegate?.didTapAddOption(for: chatroomId, messageId: messageId)
    }
    
    
    // MARK: configure
    open func configure(with data: PollInfoData, delegate: LMChatPollViewDelegate?) {
        self.delegate = delegate
        self.chatroomId = data.chatroomId
        self.messageId = data.messageId
        
        questionTitle.text = data.question
        pollTypeLabel.text = data.pollTypeWithSubmitText()
//        optionSelectCountLabel.text = data.optionStringFormatted
//        optionSelectCountLabel.isHidden = !data.isShowOption
        
        optionSelectCountLabel.isHidden = true
        
        optionStackView.removeAllArrangedSubviews()
        
        data.options?.forEach { option in
            let optionView = LMUIComponents.shared.pollOptionView.init()
            optionView.translatesAutoresizingMaskIntoConstraints = false
            optionView.configure(with: option, delegate: self)
            optionStackView.addArrangedSubview(optionView)
        }
        
        answerTitleLabel.text = data.pollAnswerTextUpdated()
        expiryDateLabel.text = data.expiryDateFormatted
        expiryDateLabel.backgroundColor = data.isPollExpired ? Appearance.shared.colors.red : Appearance.shared.colors.appTintColor
        
        addOptionButton.isHidden = !(data.allowAddOption ?? false)
        
        editVoteButton.isHidden = !(data.isShowEditVote ?? false)
        
        submitButton.isHidden = !(data.isShowSubmitButton ?? false)
        submitButton.isEnabled = (data.enableSubmitButton ?? false)
        submitButton.alpha = (data.enableSubmitButton ?? false) ? 1 : 0.5
    }
}


// MARK: LMChatDisplayPollWidgetProtocol
extension LMChatPollView: LMChatDisplayPollWidgetProtocol {
    public func didTapVoteCountButton(optionID: String) {
        guard let chatroomId,
              let messageId else { return }
        delegate?.didTapVoteCountButton(for: chatroomId, messageId: messageId, optionID: optionID)
    }
    
    public func didTapToVote(optionID: String) {
        guard let chatroomId,
              let messageId else { return }
        delegate?.didTapToVote(for: chatroomId, messageId: messageId, optionID: optionID)
    }
}
