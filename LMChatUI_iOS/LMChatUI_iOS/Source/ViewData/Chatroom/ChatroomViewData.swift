//
//  ChatroomViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/// A view-data class that mirrors the properties of `Chatroom`.
///
/// This class can be used for UI-related or other intermediate layers where
/// having a mutable class is convenient. It separates concerns from the more
/// restrictive, immutable `Chatroom` model used for decoding/network layers.
public class ChatroomViewData {

    // MARK: - Properties

    public var member: MemberViewData?
    public var id: String = ""
    public var title: String = ""
    public var createdAt: String?
    public var answerText: String?
    public var state: Int = 0
    public var unseenCount: Int?
    public var shareUrl: String?
    public var communityId: String?
    public var communityName: String?
    public var type: ChatroomTypeViewData?
    public var about: String?
    public var header: String?
    public var showFollowTelescope: Bool?
    public var showFollowAutoTag: Bool?
    public var cardCreationTime: String?
    public var participantsCount: Int?
    public var totalResponseCount: Int = 0
    public var muteStatus: Bool?
    public var followStatus: Bool?
    public var hasBeenNamed: Bool?
    public var hasReactions: Bool?
    public var date: String?
    public var isTagged: Bool?
    public var isPending: Bool?
    public var isPinned: Bool?
    public var isDeleted: Bool?
    public var userId: String?
    public var deletedBy: String?
    public var deletedByMember: MemberViewData?
    public var updatedAt: Int?
    public var lastSeenConversationId: String?
    public var lastConversationId: String?
    public var dateEpoch: Int?
    public var isSecret: Bool?
    public var secretChatroomParticipants: [Int]?
    public var secretChatroomLeft: Bool?
    public var reactions: [ReactionViewData]?
    public var topicId: String?
    public var topic: ConversationViewData?
    public var autoFollowDone: Bool?
    public var isEdited: Bool?
    public var access: Int?
    public var memberCanMessage: Bool?
    public var cohorts: [CohortViewData]?
    public var externalSeen: Bool?
    public var unreadConversationCount: Int?
    public var chatroomImageUrl: String?
    public var accessWithoutSubscription: Bool?
    public var lastConversation: ConversationViewData?
    public var lastSeenConversation: ConversationViewData?
    public var draftConversation: String?
    public var isConversationStored: Bool = false
    public var isDraft: Bool?
    public var totalAllResponseCount: Int?
    public var chatRequestCreatedAt: Int?
    public var chatRequestState: ChatRequestStateViewData?
    public var chatRequestedById: String?
    public var chatRequestedByUser: MemberViewData?
    public var chatWithUserId: String?
    public var isPrivate: Bool?
    public var isPrivateMember: Bool?
    public var chatWithUser: MemberViewData?

    // MARK: - Initializer

    /// Default initializer. Properties can be set after initialization as needed.
    public init() {}
}
