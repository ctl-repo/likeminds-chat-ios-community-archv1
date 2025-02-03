//
//  LMHomeFeedSecretChatroomInviteCell.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation
import UIKit

/// A protocol that defines delegate methods for handling actions on secret chatroom invite cells.
protocol LMChatHomeFeedSecretChatroomInviteCellDelegate: AnyObject {
    /**
     Called when the accept button is tapped in the secret chatroom invite cell.

     - Parameter data: The content model associated with the secret chatroom invite.
     */
    func didTapAcceptButton(
        in data: LMChatHomeFeedSecretChatroomInviteCell.ContentModel)

    /**
     Called when the reject button is tapped in the secret chatroom invite cell.

     - Parameter data: The content model associated with the secret chatroom invite.
     */
    func didTapRejectButton(
        in data: LMChatHomeFeedSecretChatroomInviteCell.ContentModel)
}

/// A table view cell that displays a secret chatroom invite in the home feed.
///
/// The cell presents the chatroom details and includes two action buttons: one for accepting
/// the invite and another for rejecting it. It uses a custom content model to hold invite data
/// and forwards button actions to its delegate.
open class LMChatHomeFeedSecretChatroomInviteCell: LMTableViewCell {

    // MARK: - Content Model

    /**
     A model representing the data required to display a secret chatroom invite.

     This model encapsulates the chatroom view data, invite metadata such as timestamps and status,
     as well as the view data for both the invite sender and receiver.
     */
    public struct ContentModel {
        /// The view data for the chatroom associated with the invite.
        public let chatroom: ChatroomViewData

        /// The timestamp when the invite was created.
        public let createdAt: Int64

        /// The unique identifier of the invite.
        public let id: Int

        /// The status of the invite.
        public let inviteStatus: Int

        /// The timestamp when the invite was last updated.
        public let updatedAt: Int64

        /// The view data for the member who sent the invite.
        public let inviteSender: MemberViewData

        /// The view data for the member who received the invite.
        public let inviteReceiver: MemberViewData

        /**
         Initializes a new instance of `ContentModel` with the provided values.

         - Parameters:
            - chatroom: The chatroom view data.
            - createdAt: The timestamp when the invite was created.
            - id: The unique identifier of the invite.
            - inviteStatus: The status of the invite.
            - updatedAt: The timestamp when the invite was last updated.
            - inviteSender: The member view data for the invite sender.
            - inviteReceiver: The member view data for the invite receiver.
         */
        public init(
            chatroom: ChatroomViewData, createdAt: Int64, id: Int,
            inviteStatus: Int, updatedAt: Int64, inviteSender: MemberViewData,
            inviteReceiver: MemberViewData
        ) {
            self.chatroom = chatroom
            self.createdAt = createdAt
            self.id = id
            self.inviteStatus = inviteStatus
            self.updatedAt = updatedAt
            self.inviteSender = inviteSender
            self.inviteReceiver = inviteReceiver
        }
    }

    // MARK: - Properties

    /// The content model containing the secret chatroom invite data for this cell.
    public var data: ContentModel?

    /// The delegate for handling accept and reject button actions.
    weak var delegate: LMChatHomeFeedSecretChatroomInviteCellDelegate?

    // MARK: UI Elements

    /**
     A view that displays the chatroom details.

     This view is obtained from the shared UI components and is used to present chatroom-related data.
     */
    open private(set) lazy var chatroomView: LMChatHomeFeedChatroomView = {
        let view = LMUIComponents.shared.homeFeedChatroomView.init()
            .translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        return view
    }()

    /**
     A separator view used to visually separate the cell's content.

     This view typically appears as a thin line at the bottom of the cell.
     */
    open private(set) lazy var sepratorView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()

    /**
     A button used for rejecting the secret chatroom invite.

     Configured with a cross icon, it uses the appearance settings defined in the shared constants.
     */
    public let rejectButton: LMButton = {
        let button = LMButton(type: .system)
            .translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.crossIcon, for: .normal)
        button.tintColor = Appearance.shared.colors.gray102
        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.setInsets(forContentPadding: .zero, imageTitlePadding: .zero)
        return button
    }()

    /**
     A button used for accepting the secret chatroom invite.

     Configured with a stroked checkmark icon and tinted with the app's primary color.
     */
    public let acceptButton: LMButton = {
        let button = LMButton(type: .system)
            .translatesAutoresizingMaskIntoConstraints()
        button.setImage(UIImage.strokedCheckmark, for: .normal)
        button.tintColor = Appearance.shared.colors.appTintColor
        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.setInsets(forContentPadding: .zero, imageTitlePadding: .zero)
        return button
    }()

    // MARK: - Setup Methods

    /**
     Configures the view hierarchy for the cell.

     Adds the container view to the content view, then adds the chatroom view and the separator view. The reject
     and accept buttons are added as arranged subviews to the chatroom container stack view.
     */
    open override func setupViews() {
        super.setupViews()
        contentView.addSubview(containerView)
        containerView.addSubview(chatroomView)
        chatroomView.chatroomContainerStackView.addArrangedSubview(rejectButton)
        chatroomView.chatroomContainerStackView.addArrangedSubview(acceptButton)
        containerView.addSubview(sepratorView)
    }

    /**
     Sets up the layout constraints for the cell's subviews.

     Positions the container view to fill the content view, and arranges the chatroom view, separator view,
     and buttons using Auto Layout constraints.
     */
    open override func setupLayouts() {
        super.setupLayouts()

        // Pin the container view to the content view.
        contentView.pinSubView(subView: containerView)
        NSLayoutConstraint.activate([
            // Position the chatroom view at the top and stretch it horizontally.
            chatroomView.topAnchor.constraint(equalTo: containerView.topAnchor),
            chatroomView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor),
            chatroomView.bottomAnchor.constraint(
                equalTo: sepratorView.topAnchor),

            // Position the separator view at the bottom of the container view.
            sepratorView.leadingAnchor.constraint(
                equalTo: chatroomView.chatroomImageView.leadingAnchor,
                constant: 5),
            sepratorView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor),
            sepratorView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor),
            sepratorView.heightAnchor.constraint(equalToConstant: 1),

            // Layout constraints for the accept button.
            acceptButton.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor, constant: -16),
            acceptButton.centerYAnchor.constraint(
                equalTo: chatroomView.chatroomContainerStackView.centerYAnchor),
            acceptButton.widthAnchor.constraint(equalToConstant: 50),
            acceptButton.heightAnchor.constraint(equalToConstant: 50),

            // Layout constraints for the reject button.
            rejectButton.trailingAnchor.constraint(
                equalTo: acceptButton.leadingAnchor, constant: -8),
            rejectButton.centerYAnchor.constraint(
                equalTo: acceptButton.centerYAnchor),
            rejectButton.widthAnchor.constraint(equalToConstant: 50),
            rejectButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    /**
     Configures the appearance of the cell's subviews.

     Sets background colors and other visual properties for the separator view, cell, and content view.
     */
    open override func setupAppearance() {
        super.setupAppearance()
        sepratorView.backgroundColor = Appearance.shared.colors.gray4
        backgroundColor = Appearance.shared.colors.clear
        contentView.backgroundColor = Appearance.shared.colors.clear
    }

    /**
     Sets up user interaction actions for the cell.

     Adds target-action pairs for the reject and accept buttons to handle user taps.
     */
    open override func setupActions() {
        super.setupActions()
        rejectButton.addTarget(
            self, action: #selector(didTapRejectButton), for: .touchUpInside)
        acceptButton.addTarget(
            self, action: #selector(didTapAcceptButton), for: .touchUpInside)
    }

    // MARK: - Button Actions

    /**
     Called when the reject button is tapped.

     This method checks for valid cell data and then notifies the delegate that the reject button was tapped.
     */
    @objc private func didTapRejectButton() {
        guard let data = data else { return }
        delegate?.didTapRejectButton(in: data)
    }

    /**
     Called when the accept button is tapped.

     This method checks for valid cell data and then notifies the delegate that the accept button was tapped.
     */
    @objc private func didTapAcceptButton() {
        guard let data = data else { return }
        delegate?.didTapAcceptButton(in: data)
    }

    // MARK: - Configuration

    /**
     Configures the cell with the provided content model.

     - Parameter data: The content model containing the secret chatroom invite data.

     The method saves the content model and updates the chatroom view with the invite details.
     */
    open func configure(with data: ContentModel) {
        self.data = data
        setChatroomData(data)
    }

    /**
     Sets the chatroom view data based on the provided content model.

     - Parameter data: The content model containing the secret chatroom invite data.

     Updates the chatroom view's labels and image based on the invite data. If a chatroom image URL is
     available, it loads the image asynchronously using Kingfisher; otherwise, a placeholder image is used.
     */
    open func setChatroomData(_ data: ContentModel) {
        // Update the last message label with the invite sender's name.
        chatroomView.lastMessageLabel.text =
            "\(data.inviteSender.name ?? "") sent you an invite"
        chatroomView.timestampLabel.isHidden = true
        chatroomView.chatroomCountBadgeLabel.isHidden = true

        // Update the chatroom name using the header from the chatroom view data.
        chatroomView.chatroomName(data.chatroom.header ?? "")

        // Hide icons that are not applicable for secret chatroom invites.
        chatroomView.muteIconImageView.isHidden = true
        chatroomView.announcementIconImageView.isHidden = true
        chatroomView.lockIconImageView.isHidden = true
        chatroomView.tagIconImageView.isHidden = true
        chatroomView.chatroomCountBadgeLabel.isHidden = true

        // Generate a placeholder image based on the chatroom title.
        let placeholder = UIImage.generateLetterImage(
            name: data.chatroom.title.components(separatedBy: " ").first ?? ""
        )

        // Load the chatroom image if a valid URL is provided; otherwise, use the placeholder.
        if let imageUrl = data.chatroom.chatroomImageUrl,
            let url = URL(string: imageUrl)
        {
            chatroomView.chatroomImageView.kf.setImage(
                with: url, placeholder: placeholder,
                options: [.fromMemoryCacheOrRefresh]
            )
        } else {
            chatroomView.chatroomImageView.image = placeholder
        }
    }
}
