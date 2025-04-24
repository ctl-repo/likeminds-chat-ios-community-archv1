//
//  LMChatAnalytics.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 08/05/24.
//

import Foundation

// MARK: - LMChatAnalyticsProtocol

/// A protocol for tracking analytics events in LMChat.
///
/// Conforming types should implement the `trackEvent(for:eventProperties:)` method
/// to track or record analytics events.
public protocol LMChatAnalyticsProtocol {
    /// Tracks an analytics event.
    ///
    /// - Parameters:
    ///   - eventName: The name of the event to track.
    ///   - eventProperties: A dictionary containing additional properties or metadata about the event.
    func trackEvent(
        for eventName: LMChatAnalyticsEventName,
        eventProperties: [String: AnyHashable]
    )
}

// MARK: - LMChatAnalytics

/// The default implementation of `LMChatAnalyticsProtocol`.
///
/// This class prints event information to the console, then delegates
/// the event-handling to `LMChatCore.shared.coreCallback`.
final class LMChatAnalytics: LMChatAnalyticsProtocol {
    /// Tracks an analytics event by printing to the console,
    /// then calling the corresponding callback in `LMChatCore`.
    ///
    /// - Parameters:
    ///   - eventName: The name of the event to track.
    ///   - eventProperties: A dictionary containing additional properties or metadata about the event.
    public func trackEvent(
        for eventName: LMChatAnalyticsEventName,
        eventProperties: [String: AnyHashable]
    ) {
        LMChatCore.shared.coreCallback?.onEventTriggered(
            eventName: eventName,
            eventProperties: eventProperties
        )
    }
}

// MARK: - LMChatAnalyticsEventName

/// A list of analytics event names used throughout LMChat.
///
/// Each case represents a specific event in the system. They include
/// chatroom events, direct messaging events, notification events,
/// reaction events, search events, voice note events, and more.
///
/// - Important: Raw values correspond to the string identifiers sent
///   to the analytics provider or used for internal tracking.
public enum LMChatAnalyticsEventName: String {
    // Chatroom Events
    case chatroomLinkClicked = "chatroom_link_clicked"
    case userTagsSomeone = "user_tags_someone"  
    case chatroomMuted = "chatroom_muted"  
    case chatroomUnmuted = "chatroom_unmuted"  
    case chatroomResponded = "chatroom_responded"
    case chatRoomDeleted = "chatroom_deleted"
    case chatRoomFollowed = "chatroom_followed"  
    case chatRoomLeft = "chatroom_left"
    case chatRoomOpened = "chatroom_opened"  
    case chatRoomShared = "chatroom_shared"
    case chatRoomUnfollowed = "chatroom_unfollowed"  
    case chatroomAutoFollow = "auto_follow_enabled"
    case setChatroomTopic = "current_topic_updated"  
    case pinnedChatroomViewed = "pinned_chatrooms_viewed" 
    case viewChatroomParticipants = "view_chatroom_participants" 

    // DM Events
    case dmScreenOpened = "direct_messages_screen_opened"  
    case dmChatroomCreated = "dm_chatroom_created" 
    case dmRequestSent = "dm_request_sent"
    case dmRequestResponded = "dm_request_responded"
    case dmSent = "dm_sent"
    case dmBlock = "dm_blocked"
    case dmUnblock = "dm_unblocked"

    // Notification Events
    case notificationReceived = "notification_received"
    case notificationClicked = "notification_clicked"

    // Reaction Events
    case reactionsClicked = "reactions_click"
    case reactionAdded = "reaction_added"  
    case reactionListOpened = "reaction_list_opened"  
    case reactionRemoved = "reaction_removed"  

    // Search Events
    case searchIconClicked = "clicked_search_icon"  
    case searchCrossIconClicked = "clicked_cross_search_icon"  
    case chatroomSearched = "chatroom_searched"  
    case chatroomSearchClosed = "chatroom_search_closed"
    case messageSearched = "message_searched"  
    case messageSearchClosed = "message_search_closed"

    // Voice Note Events
    case voiceNoteRecorded = "voice_message_recorded"  
    case voiceNotePreviewed = "voice_message_previewed"  
    case voiceNoteCanceled = "voice_message_canceled"  
    case voiceNoteSent = "voice_message_sent"  
    case voiceNotePlayed = "voice_message_played"  

    // Onboarding Flow
    case communityTabClicked = "community_tab_clicked"
    case communityFeedClicked = "community_feed_clicked"

    // Attachment Events
    case imageViewed = "image_viewed"  
    case videoPlayed = "video_played"  
    case audioPlayed = "audio_played"  
    case chatLinkClicked = "chat_link_clicked"  

    // Message Action Events
    case messageEdited = "message_edited"  
    case messageDeleted = "message_deleted"  
    case messageCopied = "message_copied"  
    case messageReply = "message_reply"  
    case replyPrivately = "reply_privately" 

    // Reporting Events
    case messageReported = "message_reported" 

    // Sync Related Events
    case syncComplete = "sync_complete"

    // Third Party Share Events
    case thirdPartySharing = "third_party_sharing"
    case thirdPartyAbandoned = "third_party_abandoned"

    // Home and UI Events
    case homeFeedPageOpened = "home_feed_page_opened"
    case emoticonTrayOpened = "emoticon_tray_opened"

    // Poll events
    case pollVoted = "poll_voted"
    case pollVotingSkiped = "poll_voting_skipped"
    case pollVotingEdited = "poll_voting_edited"
    case pollCreationCompleted = "poll_creation_completed"
    case pollOptionCreated = "poll_option_created"
    case pollAnswersViewed = "poll_answers_viewed"
    case pollResultsToggled = "poll_results_toggled"
    
    case companyInfo = "Company_Info"
    case buyStock = "Buy_Stock"
    case sellStock = "Sell_Stock"
    case defaultValue = "Default_Value"
    case portfolioReview = "Portfolio_Review"
    case stockShare = "Stock_Share"

}

public enum LMChatAnalyticsKeys: String {
    case chatroomId = "chatroom_id"
    case chatroomName = "chatroom_name"
    case chatroomTitle = "chatroom_title"
    case chatroomType = "chatroom_type"
    case communityName = "community_name"
    case conversationId = "conversation_id"
    case pollOptionId = "poll_option_id"
    case messageId = "message_id"
    case communityId = "community_id"
    case uuid = "uuid"
    case source = "source"
    case receiver
    case status
    case senderId = "sender_id"
    case receiverId = "receiver_id"
    case reported
    case reportedReason = "reported reason"
    case blockedUser = "blocked user"
    case type
    case reason
}

public enum LMChatAnalyticsSource: String {
    case messageReactionsFromLongPress = "long press"
    case messageReactionsFromReactionButton = "reaction button"
    case communityTab = "community_tab"
    case homeFeed = "home_feed"
    case exploreFeed = "explore_feed"
    case notification = "notification"
    case deepLink = "deep_link"
    case pollResult = "poll_result"
    case messageReactions = "message_reactions"
    case directMessagesScreen = "direct_messages_screen"
    case chatroomOverflowMenu = "chatroom_overflow_menu"
}
