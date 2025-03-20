//
//  Conversation+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import LikeMindsChatData
import LikeMindsChatUI

extension Conversation {
    /**
     Converts a `Conversation` instance into a `ConversationViewData`.

     - Returns: A `ConversationViewData` populated with the data from this `Conversation`.
     */
    public func toViewData(memberTitle: String? = nil, message: String? = nil, createdBy: String? = nil, isIncoming: Bool? = nil, messageType: Int? = nil, messageStatus: LMMessageStatus? = nil, hideLeftProfileImage: Bool? = nil, createdTime: String? = nil, replyConversation: ConversationViewData? = nil) -> ConversationViewData {
        let viewData = ConversationViewData(
            answer: self.answer,
            state: self.state.toViewData(),  // Assuming `ConversationState` has `toViewData`
            widgetId: self.widgetId
        )
        viewData.id = self.id
        viewData.chatroomId = self.chatroomId
        viewData.communityId = self.communityId
        viewData.member = self.member?.toViewData()  // Assuming `Member` has `toViewData`
        viewData.createdAt = self.createdAt
        viewData.attachments = self.attachments?.compactMap { $0.toViewData() }  // Assuming `Attachment` has `toViewData`
        viewData.lastSeen = self.lastSeen
        viewData.ogTags = self.ogTags?.toViewData()  // Assuming `LinkOGTags` has `toViewData`
        viewData.date = self.date
        viewData.isEdited = self.isEdited
        viewData.memberId = self.memberId
        viewData.replyConversationId = self.replyConversationId
        viewData.deletedBy = self.deletedBy
        viewData.createdEpoch = self.createdEpoch
        viewData.attachmentCount = self.attachmentCount
        viewData.attachmentUploaded = self.attachmentUploaded
        viewData.uploadWorkerUUID = self.uploadWorkerUUID
        viewData.temporaryId = self.temporaryId
        viewData.localCreatedEpoch = self.localCreatedEpoch
        viewData.reactions = self.reactions?.compactMap { $0.toViewData() }  // Assuming `Reaction` has `toViewData`
        viewData.isAnonymous = self.isAnonymous
        viewData.allowAddOption = self.allowAddOption
        viewData.pollType = self.pollType
        viewData.pollTypeText = self.pollTypeText
        viewData.submitTypeText = self.submitTypeText
        viewData.expiryTime = self.expiryTime
        viewData.multipleSelectNum = self.multipleSelectNum
        viewData.multipleSelectState = self.multipleSelectState
        viewData.polls = self.polls?.compactMap { $0.toViewData() }  // Assuming `Poll` has `toViewData`
        viewData.toShowResults = self.toShowResults
        viewData.pollAnswerText = self.pollAnswerText
        viewData.replyChatroomId = self.replyChatroomId
        viewData.deviceId = self.deviceId
        viewData.hasFiles = self.hasFiles
        viewData.hasReactions = self.hasReactions
        viewData.lastUpdated = self.lastUpdated
        viewData.deletedByMember = self.deletedByMember?.toViewData()  // Assuming `Member` has `toViewData`
        viewData.replyConversation = replyConversation ?? self.replyConversation?.toViewData()  // Assuming `Conversation` has `toViewData`
        viewData.conversationStatus = self.conversationStatus?.toViewData()  // Assuming `ConversationStatus` has `toViewData`
        viewData.widget = self.widget?.toViewData()  // Assuming `Widget` has `toViewData`
        viewData.memberTitle = memberTitle
        viewData.message = message
        viewData.createdBy = createdBy
        viewData.isIncoming = isIncoming
        viewData.messageType = messageType
        viewData.messageStatus = messageStatus
        viewData.hideLeftProfileImage = hideLeftProfileImage
        viewData.createdTime = createdTime
        return viewData
    }
}

extension ConversationViewData {
    /**
     Converts a `ConversationViewData` instance back into a `Conversation`.

     - Returns: A `Conversation` created using the data from this `ConversationViewData`.
     */
    public func toConversation() -> Conversation {
        return Conversation.Builder()
            .id(self.id)
            .chatroomId(self.chatroomId)
            .communityId(self.communityId)
            .member(self.member?.toMember())  // Assuming `MemberViewData` has `toMember`
            .answer(self.answer)
            .createdAt(self.createdAt)
            .state(self.state.toConversationState().rawValue)  // Assuming `ConversationStateViewData` has `toConversationState`
            .attachments(self.attachments?.compactMap { $0.toAttachment() })  // Assuming `AttachmentViewData` has `toAttachment`
            .lastSeen(self.lastSeen)
            .ogTags(self.ogTags?.toLinkOGTags())  // Assuming `LinkOGTagsViewData` has `toLinkOGTags`
            .date(self.date)
            .isEdited(self.isEdited)
            .memberId(self.memberId)
            .replyConversationId(self.replyConversationId)
            .deletedBy(self.deletedBy)
            .createdEpoch(self.createdEpoch)
            .attachmentCount(self.attachmentCount)
            .attachmentUploaded(self.attachmentUploaded)
            .uploadWorkerUUID(self.uploadWorkerUUID)
            .temporaryId(self.temporaryId)
            .localCreatedEpoch(self.localCreatedEpoch)
            .reactions(self.reactions?.compactMap { $0.toReaction() } ?? [] )  // Assuming `ReactionViewData` has `toReaction`
            .isAnonymous(self.isAnonymous)
            .allowAddOption(self.allowAddOption)
            .pollType(self.pollType)
            .pollTypeText(self.pollTypeText)
            .submitTypeText(self.submitTypeText)
            .expiryTime(self.expiryTime)
            .multipleSelectNum(self.multipleSelectNum)
            .multipleSelectState(self.multipleSelectState)
            .polls(self.polls?.compactMap { $0.toPoll() })  // Assuming `PollViewData` has `toPoll`
            .toShowResults(self.toShowResults)
            .pollAnswerText(self.pollAnswerText)
            .replyChatroomId(self.replyChatroomId)
            .deviceId(self.deviceId)
            .hasFiles(self.hasFiles)
            .hasReactions(self.hasReactions)
            .lastUpdated(self.lastUpdated)
            .deletedByMember(self.deletedByMember?.toMember())  // Assuming `MemberViewData` has `toMember`
            .replyConversation(self.replyConversation?.toConversation())  // Assuming `ConversationViewData` has `toConversation`
            .conversationStatus(
                self.conversationStatus?.toConversationStatus()
            )  // Assuming `ConversationStatusViewData` has `toConversationStatus`
            .widgetId(self.widgetId)
            .widget(self.widget?.toWidget())  // Assuming `WidgetViewData` has `toWidget`
            .build()
    }
}
