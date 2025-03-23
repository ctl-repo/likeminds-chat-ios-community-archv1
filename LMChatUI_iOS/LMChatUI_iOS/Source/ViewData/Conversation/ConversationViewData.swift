//
//  ConversationViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/// A view-data class that mirrors the properties of `ConversationViewData` from Kotlin.
///
/// This class can be used in UI layers or other scenarios where a mutable,
/// class-based model is preferred. It keeps the domain/networking-focused
/// `Conversation` separate from the UI or intermediate logic.
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
    public var deletedBy: String? {
        didSet {
            if let deletedBy = deletedBy, !deletedBy.isEmpty {
                isDeleted = true
            } else {
                isDeleted = false
            }
        }
    }
    public var createdEpoch: Int?
    public var attachmentCount: Int?
    public var attachmentUploaded: Bool?
    public var uploadWorkerUUID: String?
    public var temporaryId: String?
    public var localCreatedEpoch: Int?
    public var reactions: [ReactionViewData]?
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
    public var pollInfoData: PollInfoData?
    public var attachmentUploadedEpoch: Int?

    // MARK: Core Data Variables
    // All the variables are custom generated for handling the cases in UI
    // Boolean to check if the message is sent by the current user or not
    public var isIncoming: Bool?
    // Stores conversation state
    public var messageType: Int?
    // Boolean to check if the current message is deleted or not
    // Its state is updated everytime there is a change in deletedBy key
    public var isDeleted: Bool = false
    public var isShowMore: Bool = false
    // Store the message state for .sent, etc
    public var messageStatus: LMMessageStatus?
    // Stores the memberTitle
    public var memberTitle: String?
    // Stores the route formated chat message content
    public var message: String?
    // Stores the name of the user who sent the message
    // In case it is the current user, the text will be "You"
    public var createdBy: String?
    // Boolean to show/hide the profile photo
    // True in case the current chatroom is a DM Chatroom
    public var hideLeftProfileImage: Bool? = nil
    // Formatted String for created at to be used in UI
    public var createdTime: String? = nil

    // MARK: - Initializer
    public init(
        answer: String, state: ConversationStateViewData, widgetId: String
    ) {
        self.answer = answer
        self.state = state
        self.widgetId = widgetId
    }

    public init(
        id: String?,
        chatroomId: String?,
        communityId: String?,
        member: MemberViewData?,
        answer: String,
        createdAt: String?,
        state: ConversationStateViewData,
        attachments: [AttachmentViewData]?,
        lastSeen: Bool?,
        ogTags: LinkOGTagsViewData?,
        date: String?,
        isEdited: Bool?,
        memberId: String?,
        replyConversationId: String?,
        deletedBy: String?,
        createdEpoch: Int?,
        attachmentCount: Int?,
        attachmentUploaded: Bool?,
        uploadWorkerUUID: String?,
        temporaryId: String?,
        localCreatedEpoch: Int?,
        reactions: [ReactionViewData]?,
        replyChatroomId: String?,
        deviceId: String?,
        hasFiles: Bool?,
        hasReactions: Bool?,
        lastUpdated: Int?,
        deletedByMember: MemberViewData?,
        replyConversation: ConversationViewData?,
        conversationStatus: ConversationStatusViewData?,
        widgetId: String,
        widget: WidgetViewData?,
        pollInfoData: PollInfoData?,
        isIncoming: Bool?,
        messageType: Int?,
        isShowMore: Bool = false,
        messageStatus: LMMessageStatus?,
        memberTitle: String? = nil,
        message: String? = nil,
        createdBy: String? = nil,
        hideLeftProfileImage: Bool? = nil,
        createdTime: String? = nil,
        attachmentUploadedEpoch: Int?
    ) {
        self.id = id
        self.chatroomId = chatroomId
        self.communityId = communityId
        self.member = member
        self.answer = answer
        self.createdAt = createdAt
        self.state = state
        self.attachments = attachments
        self.lastSeen = lastSeen
        self.ogTags = ogTags
        self.date = date
        self.isEdited = isEdited
        self.memberId = memberId
        self.replyConversationId = replyConversationId
        self.deletedBy = deletedBy
        self.createdEpoch = createdEpoch
        self.attachmentCount = attachmentCount
        self.attachmentUploaded = attachmentUploaded
        self.uploadWorkerUUID = uploadWorkerUUID
        self.temporaryId = temporaryId
        self.localCreatedEpoch = localCreatedEpoch
        self.reactions = reactions
        self.replyChatroomId = replyChatroomId
        self.deviceId = deviceId
        self.hasFiles = hasFiles
        self.hasReactions = hasReactions
        self.lastUpdated = lastUpdated
        self.deletedByMember = deletedByMember
        self.replyConversation = replyConversation
        self.conversationStatus = conversationStatus
        self.widgetId = widgetId
        self.widget = widget
        self.pollInfoData = pollInfoData
        self.isIncoming = isIncoming
        self.messageType = messageType
        self.isShowMore = isShowMore
        self.messageStatus = messageStatus
        self.memberTitle = memberTitle
        self.message = message
        self.createdBy = createdBy
        self.hideLeftProfileImage = hideLeftProfileImage
        self.createdTime = createdTime
        self.attachmentUploadedEpoch = attachmentUploadedEpoch
    }
}
