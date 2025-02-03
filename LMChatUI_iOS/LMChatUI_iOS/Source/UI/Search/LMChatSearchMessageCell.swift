//
//  LMChatSearchMessageCell.swift
//  LikeMindsChatCore
//
//  Created by Devansh Mohata on 16/04/24.
//

import UIKit

/// A table view cell that displays a search result message for a chatroom or conversation.
///
/// This cell shows the chatroom name as the title, a preview of the message with highlighted search text,
/// the sender’s name prepended to the message preview, the date of the message, and an indicator if the user
/// has not joined the chatroom.
public class LMChatSearchMessageCell: LMTableViewCell {

    /**
     A content model that encapsulates the data required to configure an `LMChatSearchMessageCell`.

     Conforms to `LMChatSearchCellDataProtocol` for consistent handling of search cell data.
     */
    public struct ContentModel: LMChatSearchCellDataProtocol {
        /// The identifier of the chatroom.
        public var chatroomID: String
        /// An optional identifier of the message.
        public var messageID: String?
        /// The name of the chatroom.
        public let chatroomName: String
        /// The message content.
        public let message: String
        /// The name of the sender.
        public let senderName: String
        /// The message timestamp as a `TimeInterval`.
        public let date: TimeInterval
        /// A Boolean value indicating whether the user has joined the chatroom.
        public let isJoined: Bool
        /// The text that should be highlighted in the message (usually matching the search query).
        public let highlightedText: String

        /**
         Initializes a new instance of `ContentModel`.

         - Parameters:
            - chatroomID: The unique identifier for the chatroom.
            - messageID: An optional identifier for the message.
            - chatroomName: The display name of the chatroom.
            - message: The content of the message.
            - senderName: The name of the sender.
            - date: The timestamp when the message was sent.
            - isJoined: A Boolean flag indicating whether the user has joined the chatroom.
            - highlightedText: The portion of text to highlight (typically matching the search query).
         */
        public init(
            chatroomID: String, messageID: String?, chatroomName: String,
            message: String, senderName: String, date: TimeInterval,
            isJoined: Bool, highlightedText: String
        ) {
            self.chatroomID = chatroomID
            self.messageID = messageID
            self.chatroomName = chatroomName
            self.message = message
            self.senderName = senderName
            self.date = date
            self.isJoined = isJoined
            self.highlightedText = highlightedText
        }
    }

    // MARK: - UI Components

    /**
     The label that displays the chatroom name.

     Uses the shared heading font and black text color.
     */
    lazy var titleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Testing"  // Placeholder text; updated via configuration.
        label.font = Appearance.shared.fonts.headingFont1
        label.textColor = Appearance.shared.colors.black
        return label
    }()

    /**
     The label that displays the message content.

     Configured to allow up to two lines of text.
     */
    lazy var subtitleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Notification"  // Placeholder text; updated via configuration.
        label.numberOfLines = 2
        return label
    }()

    /**
     The label that displays the formatted date of the message.

     Uses a secondary heading font and black text color.
     */
    lazy var dateLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = ""
        label.font = Appearance.shared.fonts.headingFont2
        label.textColor = Appearance.shared.colors.black
        return label
    }()

    /**
     A label that indicates if the user has not joined the chatroom.

     Displays a message such as "chat room not joined yet" using a specific font and gray text color.
     */
    lazy var isJoinedLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "chat room not joined yet"
        label.font = Appearance.shared.fonts.headingFont2
        label.textColor = Appearance.shared.colors.gray51
        return label
    }()

    /**
     A separator view to visually separate cells or sections.

     Currently set with a light gray background color.
     */
    lazy var sepratorView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .lightGray
        return view
    }()

    // MARK: - Setup Methods

    /**
     Sets up the view hierarchy for the cell.

     Adds the container view to the cell's content view, and then adds all subviews (titleLabel,
     subtitleLabel, isJoinedLabel, dateLabel, and sepratorView) to the container view.
     */
    open override func setupViews() {
        super.setupViews()

        contentView.addSubview(containerView)

        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(isJoinedLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(sepratorView)
    }

    /**
     Configures the layout constraints for the cell's subviews.

     The container view is pinned to the content view, and the subviews within the container view are laid out
     with appropriate spacing. The separator view is set to be hidden by default.
     */
    open override func setupLayouts() {
        super.setupLayouts()

        // Constrain containerView to the contentView's top, leading, and trailing edges.
        containerView.addConstraint(
            top: (contentView.topAnchor, 0),
            leading: (contentView.leadingAnchor, 0),
            trailing: (contentView.trailingAnchor, 0)
        )
        containerView.bottomAnchor.constraint(
            lessThanOrEqualTo: contentView.bottomAnchor
        ).isActive = true

        // Position the titleLabel at the top-left of the containerView.
        titleLabel.addConstraint(
            top: (containerView.topAnchor, 8),
            leading: (containerView.leadingAnchor, 8)
        )

        // Position the subtitleLabel below the titleLabel.
        subtitleLabel.addConstraint(
            top: (titleLabel.bottomAnchor, 8),
            leading: (titleLabel.leadingAnchor, 0)
        )
        subtitleLabel.trailingAnchor.constraint(
            lessThanOrEqualTo: containerView.trailingAnchor, constant: -8
        ).isActive = true

        // Position the isJoinedLabel below the subtitleLabel.
        isJoinedLabel.addConstraint(
            top: (subtitleLabel.bottomAnchor, 8),
            leading: (subtitleLabel.leadingAnchor, 0)
        )

        // Position the separator view below the isJoinedLabel and above the containerView's bottom.
        sepratorView.addConstraint(
            bottom: (containerView.bottomAnchor, 0),
            leading: (titleLabel.leadingAnchor, 0),
            trailing: (dateLabel.trailingAnchor, 0)
        )
        sepratorView.topAnchor.constraint(
            equalTo: isJoinedLabel.bottomAnchor, constant: 8
        ).isActive = true
        sepratorView.setHeightConstraint(with: 1)

        // Position the dateLabel at the top-right of the containerView.
        dateLabel.addConstraint(
            top: (titleLabel.topAnchor, 0),
            trailing: (containerView.trailingAnchor, -8)
        )
        dateLabel.leadingAnchor.constraint(
            greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8
        ).isActive = true

        // Initially hide the separator view.
        sepratorView.isHidden = true
    }

    // MARK: - Configuration Method

    /**
     Configures the cell with the provided content model.

     Updates the title, subtitle (with highlighted search text), joined indicator, and date label.
     The sender’s name is prepended to the message content and highlighted according to the search query.

     - Parameter data: A `ContentModel` instance containing the data to display.
     */
    open func configure(with data: ContentModel) {
        // Set the chatroom name as the title.
        titleLabel.text = data.chatroomName

        // Create an attributed string from the message text.
        var attrText = GetAttributedTextWithRoutes.getAttributedText(
            from: data.message,
            andPrefix: "@",
            allowLink: false,
            allowHashtags: false
        )

        // Highlight the portion of the text that matches the search query.
        attrText = GetAttributedTextWithRoutes.detectAndHighlightText(
            in: attrText, text: data.highlightedText
        )

        // Create an attributed string for the sender's name with specific text attributes.
        let senderName = NSAttributedString(
            string: "\(data.senderName): ",
            attributes: [
                .foregroundColor: Appearance.shared.colors.textColor,
                .font: Appearance.shared.fonts.textFont1,
            ]
        )

        // Prepend the sender's name to the message.
        attrText.insert(senderName, at: .zero)

        // Set the formatted attributed text to the subtitle label.
        subtitleLabel.attributedText = attrText

        // Hide the "not joined" label if the user has joined the chatroom.
        isJoinedLabel.isHidden = data.isJoined

        // Format the date and set it to the date label.
        dateLabel.text = LMChatDateUtility.formatDate(data.date)
    }
}
