//
//  LMChatPollView.swift
//  LikeMindsChatUI
//
//  Created by Pushpendra Singh on 24/07/24.
//

import UIKit

/**
 * Protocol that defines the delegate methods for handling poll-related interactions in the chat UI.
 * This protocol should be implemented by the class that wants to handle poll actions.
 */
public protocol LMChatPollViewDelegate: AnyObject {
    /**
     * Called when the user taps on the vote count button for a specific poll option.
     * - Parameters:
     *   - chatroomId: The unique identifier of the chatroom containing the poll
     *   - messageId: The unique identifier of the message containing the poll
     *   - optionID: The unique identifier of the poll option. If nil, represents the overall poll vote count
     */
    func didTapVoteCountButton(
        for chatroomId: String, messageId: String, optionID: String?)

    /**
     * Called when the user taps to vote on a specific poll option.
     * - Parameters:
     *   - chatroomId: The unique identifier of the chatroom containing the poll
     *   - messageId: The unique identifier of the message containing the poll
     *   - optionID: The unique identifier of the poll option being voted on
     */
    func didTapToVote(
        for chatroomId: String, messageId: String, optionID: String)

    /**
     * Called when the user taps the submit button to finalize their vote.
     * - Parameters:
     *   - chatroomId: The unique identifier of the chatroom containing the poll
     *   - messageId: The unique identifier of the message containing the poll
     */
    func didTapSubmitVote(for chatroomId: String, messageId: String)

    /**
     * Called when the user taps to edit their existing vote.
     * - Parameters:
     *   - chatroomId: The unique identifier of the chatroom containing the poll
     *   - messageId: The unique identifier of the message containing the poll
     */
    func editVoteTapped(for chatroomId: String, messageId: String)

    /**
     * Called when the user taps to add a new option to the poll.
     * - Parameters:
     *   - chatroomId: The unique identifier of the chatroom containing the poll
     *   - messageId: The unique identifier of the message containing the poll
     */
    func didTapAddOption(for chatroomId: String, messageId: String)
}

/**
 * A custom view that displays a poll in the chat interface.
 * This view handles the display and interaction of polls, including:
 * - Poll question and options
 * - Voting functionality
 * - Vote count display
 * - Option addition
 * - Vote editing
 * - Poll expiration
 */
open class LMChatPollView: LMBasePollView {
    // MARK: UI Elements
    
    /**
     * Main container stack view for the bottom section of the poll.
     * Contains the add option button, meta information, and action buttons.
     */
    open private(set) lazy var bottomStack: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 16
        return stack
    }()

    /**
     * Main container stack view for the top section of the poll.
     * Contains the poll type label and meta information.
     */
    open private(set) lazy var topStack: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()

    /**
     * Button for submitting the user's vote.
     * Appears when the poll is active and the user hasn't voted yet.
     */
    open private(set) lazy var submitButton: LMButton = {
        let button = LMButton.createButton(
            with: Constants.shared.strings.submitVote, image: nil,
            textColor: Appearance.shared.colors.white,
            textFont: Appearance.shared.fonts.buttonFont2,
            contentSpacing: .init(top: 12, left: 20, bottom: 12, right: 20))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Appearance.shared.colors.white
        button.backgroundColor = Appearance.shared.colors.appTintColor
        return button
    }()

    /**
     * Stack view containing meta information at the bottom of the poll.
     * Includes vote count and other relevant information.
     */
    open private(set) lazy var bottomMetaStack: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()

    /**
     * Stack view containing meta information at the top of the poll.
     * Includes poll type icon and expiration date.
     */
    open private(set) lazy var topMetaStack: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()

    /**
     * Spacer view in the top meta stack to ensure proper layout.
     */
    open private(set) lazy var topMetaStackSpacer: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 4).isActive = true
        return view
    }()

    /**
     * Label displaying the answer/vote count information.
     * Shows the total number of votes and allows interaction to view detailed vote counts.
     */
    open private(set) lazy var answerTitleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.textColor = Appearance.shared.colors.appTintColor
        label.font = Appearance.shared.fonts.textFont1
        label.text = ""
        label.isUserInteractionEnabled = true
        return label
    }()

    /**
     * Button for editing an existing vote.
     * Appears when the user has already voted and the poll allows vote changes.
     */
    open private(set) lazy var editVoteButton: LMButton = {
        let button = LMButton.createButton(
            with: Constants.shared.strings.editVote, image: nil,
            textColor: Appearance.shared.colors.white,
            textFont: Appearance.shared.fonts.buttonFont2,
            contentSpacing: .init(top: 12, left: 20, bottom: 12, right: 20))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Appearance.shared.colors.white
        button.backgroundColor = Appearance.shared.colors.appTintColor
        return button
    }()

    /**
     * Button for adding a new option to the poll.
     * Only visible if the poll allows adding new options.
     */
    open private(set) lazy var addOptionButton: LMButton = {
        let button = LMButton.createButton(
            with: Constants.shared.strings.addNewOption,
            image: Constants.shared.images.plusIcon.withSystemImageConfig(
                pointSize: 12), textColor: Appearance.shared.colors.black,
            textFont: Appearance.shared.fonts.buttonFont1,
            contentSpacing: .init(top: 12, left: 0, bottom: 12, right: 0),
            imageSpacing: 2)
        button.tintColor = Appearance.shared.colors.black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /**
     * Stack view containing the poll question and selection count information.
     */
    open private(set) lazy var questionAndSelectcount: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 2
        return stack
    }()

    // MARK: Data Variables
    
    /**
     * Delegate object that handles poll-related interactions.
     */
    public weak var delegate: LMChatPollViewDelegate?
    
    /**
     * The unique identifier of the chatroom containing this poll.
     */
    public var chatroomId: String?
    
    /**
     * The unique identifier of the message containing this poll.
     */
    public var messageId: String?

    // MARK: setupViews
    
    /**
     * Sets up the view hierarchy and adds all subviews to their respective containers.
     * This method is called during initialization and should not be called directly.
     */
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
    
    /**
     * Sets up the Auto Layout constraints for all views in the hierarchy.
     * This method is called during initialization and should not be called directly.
     */
    open override func setupLayouts() {
        super.setupLayouts()

        pinSubView(subView: containerView)
        let standardMargin: CGFloat = 8
        questionContainerStackView.addConstraint(
            top: (containerView.topAnchor, 4),
            leading: (containerView.leadingAnchor, standardMargin),
            trailing: (containerView.trailingAnchor, -standardMargin))

        optionStackView.addConstraint(
            top: (questionContainerStackView.bottomAnchor, standardMargin + 8),
            leading: (questionContainerStackView.leadingAnchor, 0),
            trailing: (questionContainerStackView.trailingAnchor, 0))

        addOptionButton.addConstraint(
            leading: (bottomStack.leadingAnchor, 0),
            trailing: (bottomStack.trailingAnchor, 0))

        bottomStack.addConstraint(
            top: (optionStackView.bottomAnchor, standardMargin),
            bottom: (containerView.bottomAnchor, -standardMargin),
            leading: (optionStackView.leadingAnchor, 0),
            trailing: (optionStackView.trailingAnchor, 0))

        bottomMetaStack.trailingAnchor.constraint(
            lessThanOrEqualTo: bottomStack.trailingAnchor, constant: -16
        ).isActive = true
        pollImageView.setWidthConstraint(with: 22)
        pollImageView.setHeightConstraint(with: 22)
    }

    // MARK: setupAppearance
    
    /**
     * Configures the visual appearance of the poll view and its subviews.
     * This method is called during initialization and should not be called directly.
     */
    open override func setupAppearance() {
        super.setupAppearance()

        addOptionButton.layer.borderColor =
            Appearance.shared.colors.pollOptionBorderColor.cgColor
        addOptionButton.layer.borderWidth = 1
        addOptionButton.layer.cornerRadius = 8
        expiryDateLabel.cornerRadius(with: 11)
        submitButton.layer.cornerRadius = 8
        editVoteButton.layer.cornerRadius = 8
    }

    // MARK: setupActions
    
    /**
     * Sets up all the target-action pairs for the interactive elements.
     * This method is called during initialization and should not be called directly.
     */
    open override func setupActions() {
        super.setupActions()

        submitButton.addTarget(
            self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        editVoteButton.addTarget(
            self, action: #selector(editVoteTapped), for: .touchUpInside)
        answerTitleLabel.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self, action: #selector(voteCountTapped)))
        addOptionButton.addTarget(
            self, action: #selector(didTapAddOption), for: .touchUpInside)
    }

    /**
     * Handles the submit button tap action.
     * Notifies the delegate to submit the user's vote.
     */
    @objc
    open func didTapSubmitButton() {
        guard let chatroomId,
            let messageId
        else { return }
        delegate?.didTapSubmitVote(for: chatroomId, messageId: messageId)
    }

    /**
     * Handles the edit vote button tap action.
     * Notifies the delegate to allow the user to edit their vote.
     */
    @objc
    open func editVoteTapped() {
        guard let chatroomId,
            let messageId
        else { return }

        delegate?.editVoteTapped(for: chatroomId, messageId: messageId)
    }

    /**
     * Handles the vote count label tap action.
     * Notifies the delegate to show detailed vote counts.
     */
    @objc
    open func voteCountTapped() {
        guard let chatroomId,
            let messageId
        else { return }

        delegate?.didTapVoteCountButton(
            for: chatroomId, messageId: messageId, optionID: nil)
    }

    /**
     * Handles the add option button tap action.
     * Notifies the delegate to allow adding a new option to the poll.
     */
    @objc
    open func didTapAddOption() {
        guard let chatroomId,
            let messageId
        else { return }

        delegate?.didTapAddOption(for: chatroomId, messageId: messageId)
    }

    // MARK: configure
    
    /**
     * Configures the poll view with the provided data and delegate.
     * - Parameters:
     *   - data: The poll data to display
     *   - delegate: The delegate object to handle poll interactions
     */
    open func configure(
        with data: PollInfoData, delegate: LMChatPollViewDelegate?
    ) {
        self.delegate = delegate
        self.chatroomId = data.chatroomId
        self.messageId = data.messageId

        questionTitle.text = data.question
        pollTypeLabel.text = data.pollTypeWithSubmitText()
        optionSelectCountLabel.text = data.optionStringFormatted
        optionSelectCountLabel.isHidden = !data.isShowOption

        optionStackView.removeAllArrangedSubviews()

        data.options?.forEach { option in
            let optionView = LMUIComponents.shared.pollOptionView.init()
            optionView.translatesAutoresizingMaskIntoConstraints = false
            optionView.configure(with: option, delegate: self)
            optionStackView.addArrangedSubview(optionView)
        }

        answerTitleLabel.text = data.pollAnswerTextUpdated()
        expiryDateLabel.text = data.expiryDateFormatted
        expiryDateLabel.backgroundColor =
            data.isPollExpired
            ? Appearance.shared.colors.red
            : Appearance.shared.colors.appTintColor

        addOptionButton.isHidden = !(data.allowAddOption ?? false)

        editVoteButton.isHidden = !(data.isShowEditVote ?? false)

        submitButton.isHidden = !(data.isShowSubmitButton ?? false)
        submitButton.isEnabled = (data.enableSubmitButton ?? false)
        submitButton.alpha = (data.enableSubmitButton ?? false) ? 1 : 0.5
    }
}

// MARK: LMChatDisplayPollWidgetProtocol

/**
 * Extension that conforms to the LMChatDisplayPollWidgetProtocol to handle poll option interactions.
 */
extension LMChatPollView: LMChatDisplayPollWidgetProtocol {
    /**
     * Handles the tap action on a poll option's vote count.
     * - Parameter optionID: The unique identifier of the poll option
     */
    public func didTapVoteCountButton(optionID: String) {
        guard let chatroomId,
            let messageId
        else { return }
        delegate?.didTapVoteCountButton(
            for: chatroomId, messageId: messageId, optionID: optionID)
    }

    /**
     * Handles the tap action to vote on a poll option.
     * - Parameter optionID: The unique identifier of the poll option
     */
    public func didTapToVote(optionID: String) {
        guard let chatroomId,
            let messageId
        else { return }
        delegate?.didTapToVote(
            for: chatroomId, messageId: messageId, optionID: optionID)
    }
}
