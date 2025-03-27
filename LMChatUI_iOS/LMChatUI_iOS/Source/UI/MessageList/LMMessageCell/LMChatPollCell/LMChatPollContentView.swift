//
//  LMChatPollContentView.swift
//  LikeMindsChat
//
//  Created by Pushpendra Singh on 24/07/24.
//

import Foundation

/**
 * LMChatPollContentView
 * 
 * A custom content view class that handles the display and interaction of poll messages in the chat.
 * This class inherits from LMChatMessageContentView and provides specialized functionality for poll-type messages.
 *
 * Key Features:
 * - Custom poll display view with rounded corners
 * - Support for poll data visualization
 * - Built-in retry and loading states
 * - Automatic layout management
 *
 * Example:
 * ```swift
 * let pollView = LMChatPollContentView()
 * pollView.setDataView(messageData, index: indexPath)
 * ```
 */
open class LMChatPollContentView: LMChatMessageContentView {
    
    /**
     * pollDisplayView
     * 
     * A lazy-loaded view that handles the actual display of poll content.
     * This view is responsible for rendering the poll question, options, and voting interface.
     *
     * Properties:
     * - Translates autoresizing mask into constraints
     * - Clear background
     * - 12pt corner radius for rounded appearance
     *
     * The view is initialized using the shared UI components from LMUIComponents.
     */
    open private(set) lazy var pollDisplayView: LMChatPollView = {
        let view = LMUIComponents.shared.pollDisplayView.init().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .clear
        view.cornerRadius(with: 12)
        return view
    }()
    
    /**
     * setupViews
     * 
     * Configures the view hierarchy and adds necessary subviews.
     * This method is called during view initialization to set up the UI structure.
     *
     * Implementation Details:
     * - Adds pollDisplayView to bubbleView at index 2
     * - Adds cancelRetryContainerStackView to pollDisplayView
     */
    open override func setupViews() {
        super.setupViews()
        bubbleView.addArrangeSubview(pollDisplayView, atIndex: 2)
        pollDisplayView.addSubview(cancelRetryContainerStackView)
    }
    
    /**
     * setupLayouts
     * 
     * Sets up the Auto Layout constraints for the view and its subviews.
     * This method is responsible for defining the size and position of all UI elements.
     *
     * Layout Details:
     * - Poll display view width is set to 70% of screen width
     * - Cancel/retry container is centered in the poll display view
     */
    open override func setupLayouts() {
        super.setupLayouts()
        pollDisplayView.widthAnchor.constraint(equalToConstant: Self.widthOfScreen * 0.70).isActive = true
        cancelRetryContainerStackView.centerXAnchor.constraint(equalTo: pollDisplayView.centerXAnchor).isActive = true
        cancelRetryContainerStackView.centerYAnchor.constraint(equalTo: pollDisplayView.centerYAnchor).isActive = true
    }
    
    /**
     * setDataView
     * 
     * Updates the view with new message data and handles the display state.
     *
     * Parameters:
     * - data: The content model containing message data
     * - index: The index path of the message in the collection view
     *
     * Implementation Details:
     * - Hides text label for poll messages
     * - Updates retry button state based on message status
     * - Handles deleted message state
     * - Configures poll display with poll data
     * - Ensures proper view hierarchy
     */
    open override func setDataView(_ data: LMChatMessageCell.ContentModel, index: IndexPath) {
        super.setDataView(data, index: index)
        self.textLabel.isHidden = true
        updateRetryButton(data)
        if data.message.isDeleted == true {
            pollDisplayView.isHidden = true
        } else {
            pollDisplayPreview(data.message.pollInfoData)
        }
        pollDisplayView.bringSubviewToFront(cancelRetryContainerStackView)
        bubbleView.layoutIfNeeded()
    }

    /**
     * pollDisplayPreview
     * 
     * Configures the poll display view with poll data.
     *
     * Parameters:
     * - pollData: Optional PollInfoData containing poll information
     *
     * Implementation Details:
     * - Handles nil poll data case
     * - Shows/hides poll display view based on data availability
     * - Configures poll view with provided data
     */
    func pollDisplayPreview(_ pollData: PollInfoData?) {
        guard let pollData else {
            pollDisplayView.isHidden = true
            return
        }
        pollDisplayView.isHidden = false
        pollDisplayView.configure(with: pollData, delegate: nil)
    }
     
    /**
     * updateRetryButton
     * 
     * Updates the visibility of retry and loading views based on message status.
     *
     * Parameters:
     * - data: The content model containing message status information
     *
     * Implementation Details:
     * - Shows loading view for messages in sending state
     * - Shows retry view for failed messages
     */
    func updateRetryButton(_ data: LMChatMessageCell.ContentModel) {
        loaderView.isHidden = !(data.message.messageStatus == .sending)
        retryView.isHidden = !(data.message.messageStatus == .failed)
    }
    
    /**
     * prepareToResuse
     * 
     * Prepares the view for reuse in a collection view cell.
     * This method is called when the view is about to be reused for a new cell.
     */
    override func prepareToResuse() {
        super.prepareToResuse()
    }
}
