//
//  ConversationViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

/**
 A view-data class that mirrors the properties of `Conversation`.

 This class can be used in UI layers or other scenarios where a mutable,
 class-based model is preferred. It keeps the domain/networking-focused
 `Conversation` separate from the UI or intermediate logic.
 */
public class ConversationViewData {
    // MARK: - Properties
    public var id: String?
    public var chatroomId: String?
    public var communityId: String?
    public var member: MemberViewData?
    public var answer: String
    public var createdAt: String?
    public var state: ConversationStateViewData
    public var attachments: [AttachmentViewData]?
    public var lastSeen: Bool?
    public var ogTags: LinkOGTagsViewData?
    public var date: String?
    public var isEdited: Bool?
    public var memberId: String?
    public var replyConversationId: String?
    public var deletedBy: String?
    public var createdEpoch: Int?
    public var attachmentCount: Int?
    public var attachmentUploaded: Bool?
    public var uploadWorkerUUID: String?
    public var temporaryId: String?
    public var localCreatedEpoch: Int?
    public var reactions: [ReactionViewData]?
    public var isAnonymous: Bool?
    public var allowAddOption: Bool?
    public var pollType: Int?
    public var pollTypeText: String?
    public var submitTypeText: String?
    public var expiryTime: Int?
    public var multipleSelectNum: Int?
    public var multipleSelectState: Int?
    public var polls: [PollViewData]?
    public var toShowResults: Bool?
    public var pollAnswerText: String?
    public var replyChatroomId: String?
    public var deviceId: String?
    public var hasFiles: Bool?
    public var hasReactions: Bool?
    public var lastUpdated: Int?
    public var deletedByMember: MemberViewData?
    public var replyConversation: ConversationViewData?
    public var conversationStatus: ConversationStatusViewData?
    public var widgetId: String
    public var widget: WidgetViewData?

    // MARK: - Initializer
    public init(answer: String, state: ConversationStateViewData, widgetId: String) {
        self.answer = answer
        self.state = state
        self.widgetId = widgetId
    }
}
