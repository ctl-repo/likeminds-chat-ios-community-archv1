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
        
        // Create PollInfoData if any poll-related data exists
        if self.isAnonymous != nil || self.allowAddOption != nil || self.pollType != nil ||
           self.pollTypeText != nil || self.submitTypeText != nil || self.expiryTime != nil || 
           self.multipleSelectNum != nil || self.multipleSelectState != nil || self.polls != nil || 
           self.toShowResults != nil || self.pollAnswerText != nil {
            
            let pollInfoData = PollInfoData.Builder()
                .isAnonymous(self.isAnonymous)
                .allowAddOption(self.allowAddOption)
                .pollType(self.pollType)
                .pollTypeText(self.pollTypeText)
                .submitTypeText(self.submitTypeText)
                .expiryTime(self.expiryTime)
                .multipleSelectNum(self.multipleSelectNum)
                .multipleSelectState(self.multipleSelectState)
                .pollViewDataList(self.polls?.compactMap { $0.toViewData() })
                .pollAnswerText(self.pollAnswerText)
                .isPollSubmitted(false)
                .toShowResult(self.toShowResults)
                .build()
            
            viewData.pollInfoData = pollInfoData
            
            // The below function updated pollInfoData with
            // the neccessary data for Core implementation
            var pollInfoDataUpdated = convertPollData(viewData)
            
            viewData.pollInfoData = pollInfoDataUpdated
        }
        
        return viewData
    }
    
    public func convertPollData(_ conversation: ConversationViewData) -> PollInfoData? {
        guard conversation.state == .microPoll else { return nil }
        var pollInfoDataBuilder : PollInfoData.Builder? = conversation.pollInfoData?
            .toBuilder()

        // Update the builder with values from the conversation by calling the builder methods.
        pollInfoDataBuilder =
            pollInfoDataBuilder?
            .chatroomId(conversation.chatroomId ?? "")
            .messageId(conversation.id ?? "")
            .question(conversation.answer)
            .pollAnswerText(conversation.pollInfoData?.pollAnswerText ?? "")
            .options(
                getPollOptions(conversation.pollInfoData?.pollViewDataList, conversation: conversation)
            )
            .expiryDate(
                Date(milliseconds: Double(conversation.pollInfoData?.expiryTime ?? 0))
            )
            .optionState(
                LMChatPollSelectState(
                    rawValue: (conversation.pollInfoData?.multipleSelectState ?? 0))?
                    .description ?? ""
            )
            .optionCount(conversation.pollInfoData?.multipleSelectNum ?? 0)
            .isAnonymous(conversation.pollInfoData?.isAnonymous)
            .isInstantPoll(conversation.pollInfoData?.pollType == 0)
            .isShowSubmitButton(isShowSubmitButton(conversation))
            .isShowEditVote(isShowEditToVoteAgain(conversation))
            .submitTypeText(conversation.pollInfoData?.submitTypeText)
            .pollTypeText(conversation.pollInfoData?.pollTypeText)
            .allowAddOption(isAllowAddOption(conversation))

        return pollInfoDataBuilder?.build()
    }

    public func isAllowAddOption(_ conversation: ConversationViewData) -> Bool {
        let isExpired =
        (conversation.pollInfoData?.expiryTime ?? 0) < Int(Date().millisecondsSince1970)
        let isAlreadyVoted =
        conversation.pollInfoData?.pollViewDataList?.contains(where: { $0.isSelected == true })
            ?? false
        return !isExpired && !isAlreadyVoted
        && (conversation.pollInfoData?.allowAddOption ?? false)
    }

    public func isShowEditToVoteAgain(_ conversation: ConversationViewData) -> Bool {
        let isDeffered = conversation.pollInfoData?.pollType == 1
        let isAlreadyVoted =
        conversation.pollInfoData?.pollViewDataList?.contains(where: { $0.isSelected == true })
            ?? false
        let isExpired =
        (conversation.pollInfoData?.expiryTime ?? 0) < Int(Date().millisecondsSince1970)
        let isMultipleState = (conversation.pollInfoData?.multipleSelectState != nil)
        return !isExpired && isAlreadyVoted && isDeffered && isMultipleState
    }

    public func isShowSubmitButton(_ conversation: ConversationViewData) -> Bool {
        let isAlreadyVoted =
        conversation.pollInfoData?.pollViewDataList?.contains(where: { $0.isSelected == true })
            ?? false
        let isExpired =
        (conversation.pollInfoData?.expiryTime ?? 0) < Int(Date().millisecondsSince1970)
        return !isExpired && !isAlreadyVoted
        && (conversation.pollInfoData?.multipleSelectState != nil)
    }

    public func getPollOptions(_ polls: [PollViewData]?, conversation: ConversationViewData)
        -> [PollViewData]
    {
        guard var polls else { return [] }
        let isAllowAddOption = conversation.pollInfoData?.allowAddOption ?? false
        polls = polls.reduce([]) { result, element in
            result.contains(where: { $0.id == element.id })
                ? result : result + [element]
        }
        let pollOptions = polls.sorted(by: { ($0.id ?? "0") < ($1.id ?? "0") })
        let options = pollOptions.map { poll in

            var pollViewData = PollViewData.init(
                id: poll.id ?? "", text: poll.text,
                isSelected: poll.isSelected ?? false,
                percentage: Double(poll.percentage ?? 0),
                subText: poll.subText, noVotes: poll.noVotes,
                member: poll.member, userId: poll.userId,
                conversationId: poll.conversationId,
                showVoteCount: conversation.pollInfoData?.toShowResult ?? false,
                showProgressBar: conversation.pollInfoData?.toShowResult ?? false,
                showTickButton: poll.isSelected ?? false,
                addedBy: (isAllowAddOption ? (poll.member?.name ?? "") : ""))

            return pollViewData
        }
        return options
    }
}

extension ConversationViewData {
    /**
     Converts a `ConversationViewData` instance back into a `Conversation`.

     - Returns: A `Conversation` created using the data from this `ConversationViewData`.
     */
    public func toConversation() -> Conversation {
        var builder = Conversation.Builder()
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
            .reactions(self.reactions?.compactMap { $0.toReaction() } ?? [])  // Assuming `ReactionViewData` has `toReaction`
            .replyChatroomId(self.replyChatroomId)
            .deviceId(self.deviceId)
            .hasFiles(self.hasFiles)
            .hasReactions(self.hasReactions)
            .lastUpdated(self.lastUpdated)
            .deletedByMember(self.deletedByMember?.toMember())  // Assuming `MemberViewData` has `toMember`
            .replyConversation(self.replyConversation?.toConversation())  // Assuming `ConversationViewData` has `toConversation`
            .conversationStatus(self.conversationStatus?.toConversationStatus())  // Assuming `ConversationStatusViewData` has `toConversationStatus`
            .widgetId(self.widgetId)
            .widget(self.widget?.toWidget())  // Assuming `WidgetViewData` has `toWidget`
        
        // Add poll-related data from PollInfoData if it exists
        if let pollInfoData = self.pollInfoData {
            builder = builder
                .isAnonymous(pollInfoData.isAnonymous)
                .allowAddOption(pollInfoData.allowAddOption)
                .pollType(pollInfoData.pollType)
                .pollTypeText(pollInfoData.pollTypeText)
                .submitTypeText(pollInfoData.submitTypeText)
                .expiryTime(pollInfoData.expiryTime)
                .multipleSelectNum(pollInfoData.multipleSelectNum)
                .multipleSelectState(pollInfoData.multipleSelectState)
                .polls(pollInfoData.pollViewDataList?.compactMap { $0.toPoll() })
                .toShowResults(pollInfoData.toShowResult)
                .pollAnswerText(pollInfoData.pollAnswerTextUpdated())
        }
        
        return builder.build()
    }
}
