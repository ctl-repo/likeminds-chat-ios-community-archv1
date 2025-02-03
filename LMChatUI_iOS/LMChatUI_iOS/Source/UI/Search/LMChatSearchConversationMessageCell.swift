//
//  LMChatSearchConversationMessageCell.swift
//  Pods
//
//  Created by Anurag Tyagi on 01/02/25.
//

import UIKit

/// A table view cell that displays a conversation message search result.
///
/// This cell is used to present search results for conversation messages in the chat search interface.
/// It shows the sender's image, the sender's name, a highlighted version of the message text, and a formatted date.
public class LMChatSearchConversationMessageCell: LMTableViewCell {

    /**
     A content model representing the data needed to configure an `LMChatSearchConversationMessageCell`.

     Conforms to `LMChatSearchCellDataProtocol` so that it can be used in lists of search result cells.
     */
    public struct ContentModel: LMChatSearchCellDataProtocol {
        /// The identifier of the chatroom associated with the conversation.
        public var chatroomID: String
        /// An optional identifier for the specific message.
        public var messageID: String?
        /// The name of the chatroom.
        public let chatroomName: String
        /// The content of the conversation message.
        public let message: String
        /// The name of the sender.
        public let senderName: String
        /// The timestamp for the message as a `TimeInterval`.
        public let date: TimeInterval
        /// A Boolean indicating whether the user is joined to the chatroom.
        public let isJoined: Bool
        /// The text that should be highlighted in the message (e.g., matching search query).
        public let highlightedText: String
        /// An optional URL string for the sender's image.
        public let userImageUrl: String?

        /**
         Initializes a new instance of `ContentModel`.

         - Parameters:
            - chatroomID: The identifier of the chatroom.
            - messageID: An optional message identifier.
            - chatroomName: The name of the chatroom.
            - message: The conversation message text.
            - senderName: The name of the sender.
            - date: The timestamp of the message.
            - isJoined: A Boolean indicating if the user is joined to the chatroom.
            - highlightedText: The text to highlight within the message.
            - userImageUrl: An optional URL string for the sender's image.
         */
        public init(
            chatroomID: String, messageID: String?, chatroomName: String,
            message: String, senderName: String, date: TimeInterval,
            isJoined: Bool, highlightedText: String, userImageUrl: String?
        ) {
            self.chatroomID = chatroomID
            self.messageID = messageID
            self.chatroomName = chatroomName
            self.message = message
            self.senderName = senderName
            self.date = date
            self.isJoined = isJoined
            self.highlightedText = highlightedText
            self.userImageUrl = userImageUrl
        }
    }

    // MARK: - UI Components

    /**
     A custom image view to display the sender's profile image.

     Configured to have a circular appearance with a fixed width and height.
     */
    lazy var userImageIcon: LMImageView = {
        let image = LMImageView()
            .translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.setWidthConstraint(with: 60)
        image.setHeightConstraint(with: 60)
        image.cornerRadius(with: 30)
        return image
    }()

    /**
     A label used to display the sender's name.

     Uses a heading font style and black text color.
     */
    lazy var titleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Testing"  // Placeholder text; will be updated during configuration.
        label.font = Appearance.shared.fonts.headingFont1
        label.textColor = Appearance.shared.colors.black
        return label
    }()

    /**
     A label used to display the conversation message.

     Configured to allow multiple lines and uses a gray color for the text.
     */
    lazy var subtitleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Notification"  // Placeholder text; will be updated during configuration.
        label.numberOfLines = 0
        label.textColor = Appearance.shared.colors.gray102
        return label
    }()

    /**
     A label used to display the formatted date of the message.

     Uses a secondary heading font and a specific gray color.
     */
    lazy var dateLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = ""
        label.font = Appearance.shared.fonts.headingFont2
        label.textColor = Appearance.shared.colors.gray155
        return label
    }()

    // MARK: - Setup Methods

    /**
     Sets up the view hierarchy for the cell.

     Adds the container view and its subviews (userImageIcon, titleLabel, subtitleLabel, dateLabel)
     to the cell's content view.
     */
    open override func setupViews() {
        super.setupViews()

        contentView.addSubview(containerView)

        containerView.addSubview(userImageIcon)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(dateLabel)
    }

    /**
     Configures the layout constraints for the cell's subviews.

     Positions the container view to fill the content view, and lays out the user image,
     title, subtitle, and date labels with appropriate spacing.
     */
    open override func setupLayouts() {
        super.setupLayouts()

        // Constrain containerView to the contentView's edges.
        containerView.addConstraint(
            top: (contentView.topAnchor, 0),
            leading: (contentView.leadingAnchor, 0),
            trailing: (contentView.trailingAnchor, 0)
        )
        containerView.bottomAnchor.constraint(
            lessThanOrEqualTo: contentView.bottomAnchor
        ).isActive = true

        // Position userImageIcon within containerView.
        userImageIcon.addConstraint(
            top: (containerView.topAnchor, 8),
            leading: (containerView.leadingAnchor, 16)
        )
        userImageIcon.bottomAnchor.constraint(
            lessThanOrEqualTo: containerView.bottomAnchor, constant: -8
        ).isActive = true

        // Position titleLabel next to userImageIcon.
        titleLabel.addConstraint(
            top: (containerView.topAnchor, 8),
            leading: (userImageIcon.trailingAnchor, 8)
        )

        // Position subtitleLabel below titleLabel.
        subtitleLabel.addConstraint(
            top: (titleLabel.bottomAnchor, 8),
            leading: (userImageIcon.trailingAnchor, 8)
        )
        subtitleLabel.bottomAnchor.constraint(
            lessThanOrEqualTo: containerView.bottomAnchor, constant: -8
        ).isActive = true
        subtitleLabel.trailingAnchor.constraint(
            lessThanOrEqualTo: containerView.trailingAnchor, constant: -8
        ).isActive = true

        // Position dateLabel at the top-right of the containerView.
        dateLabel.addConstraint(
            top: (titleLabel.topAnchor, 0),
            trailing: (containerView.trailingAnchor, -16)
        )
        dateLabel.leadingAnchor.constraint(
            greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8
        ).isActive = true
    }

    // MARK: - Configuration Method

    /**
     Configures the cell with the provided content model.

     Updates the sender's name, applies highlighting to the message text based on the search query,
     formats the message date, and loads the sender's image.

     - Parameter data: A `ContentModel` instance containing the data to display.
     */
    open func configure(with data: ContentModel) {
        // Set the sender's name.
        titleLabel.text = data.senderName

        // Create an attributed string from the message and highlight the search text.
        var attrText = GetAttributedTextWithRoutes.getAttributedText(
            from: data.message,
            andPrefix: "@",
            allowLink: false,
            allowHashtags: false
        )
        attrText = GetAttributedTextWithRoutes.detectAndHighlightText(
            in: attrText, text: data.highlightedText
        )
        subtitleLabel.attributedText = attrText

        // Format and set the message date.
        dateLabel.text = LMChatDateUtility.formatDate(data.date)

        // Load the sender's image using Kingfisher with a placeholder generated from the sender's first name.
        if let image = data.userImageUrl {
            userImageIcon.kf.setImage(
                with: URL(string: image),
                placeholder: UIImage.generateLetterImage(
                    name: data.senderName.components(separatedBy: " ").first
                        ?? ""
                )
            )
        }
    }
}
