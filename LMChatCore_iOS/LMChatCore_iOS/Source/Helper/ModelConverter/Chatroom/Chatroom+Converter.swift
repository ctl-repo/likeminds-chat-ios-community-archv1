//
//  Chatroom+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import LikeMindsChatData
import LikeMindsChatUI

extension Chatroom {
    /**
     Converts a `Chatroom` instance into a `ChatroomViewData`.

     - Returns: A `ChatroomViewData` populated with the data from this `Chatroom`.
     */
    public func toViewData() -> ChatroomViewData {
        let viewData = ChatroomViewData()
        viewData.member = self.member?.toViewData()  // Assuming `Member` has `toViewData`
        viewData.id = self.id
        viewData.title = self.title
        viewData.createdAt = self.createdAt
        viewData.answerText = self.answerText
        viewData.state = self.state
        viewData.unseenCount = self.unseenCount
        viewData.shareUrl = self.shareUrl
        viewData.communityId = self.communityId
        viewData.communityName = self.communityName
        viewData.type = self.type?.toViewData()  // Assuming `ChatroomType` has `toViewData`
        viewData.about = self.about
        viewData.header = self.header
        viewData.showFollowTelescope = self.showFollowTelescope
        viewData.showFollowAutoTag = self.showFollowAutoTag
        viewData.cardCreationTime = self.cardCreationTime
        viewData.participantsCount = self.participantsCount
        viewData.totalResponseCount = self.totalResponseCount
        viewData.muteStatus = self.muteStatus
        viewData.followStatus = self.followStatus
        viewData.hasBeenNamed = self.hasBeenNamed
        viewData.hasReactions = self.hasReactions
        viewData.date = self.date
        viewData.isTagged = self.isTagged
        viewData.isPending = self.isPending
        viewData.isPinned = self.isPinned
        viewData.isDeleted = self.isDeleted
        viewData.userId = self.userId
        viewData.deletedBy = self.deletedBy
        viewData.deletedByMember = self.deletedByMember?.toViewData()  // Assuming `Member` has `toViewData`
        viewData.updatedAt = self.updatedAt
        viewData.lastSeenConversationId = self.lastSeenConversationId
        viewData.lastConversationId = self.lastConversationId
        viewData.dateEpoch = self.dateEpoch
        viewData.isSecret = self.isSecret
        viewData.secretChatroomParticipants = self.secretChatroomParticipants
        viewData.secretChatroomLeft = self.secretChatroomLeft
        viewData.reactions = self.reactions?.compactMap { $0.toViewData() }  // Assuming `Reaction` has `toViewData`
        viewData.topicId = self.topicId
        viewData.topic = self.topic?.toViewData()  // Assuming `Conversation` has `toViewData`
        viewData.autoFollowDone = self.autoFollowDone
        viewData.isEdited = self.isEdited
        viewData.access = self.access
        viewData.memberCanMessage = self.memberCanMessage
        viewData.cohorts = self.cohorts?.compactMap { $0.toViewData() }  // Assuming `Cohort` has `toViewData`
        viewData.externalSeen = self.externalSeen
        viewData.unreadConversationCount = self.unreadConversationCount
        viewData.chatroomImageUrl = self.chatroomImageUrl
        viewData.accessWithoutSubscription = self.accessWithoutSubscription
        viewData.lastConversation = self.lastConversation?.toViewData()  // Assuming `Conversation` has `toViewData`
        viewData.lastSeenConversation = self.lastSeenConversation?.toViewData()  // Assuming `Conversation` has `toViewData`
        viewData.draftConversation = self.draftConversation
        viewData.isConversationStored = self.isConversationStored
        viewData.isDraft = self.isDraft
        viewData.totalAllResponseCount = self.totalAllResponseCount
        viewData.chatRequestCreatedAt = self.chatRequestCreatedAt
        viewData.chatRequestState = self.chatRequestState?.toViewData()  // Assuming `ChatRequestState` has `toViewData`
        viewData.chatRequestedById = self.chatRequestedById
        viewData.chatRequestedByUser = self.chatRequestedByUser?.toViewData()  // Assuming `Member` has `toViewData`
        viewData.chatWithUserId = self.chatWithUserId
        viewData.isPrivate = self.isPrivate
        viewData.isPrivateMember = self.isPrivateMember
        viewData.chatWithUser = self.chatWithUser?.toViewData()  // Assuming `Member` has `toViewData`
        return viewData
    }
}

extension ChatroomViewData {
    /**
     Converts a `ChatroomViewData` instance back into a `Chatroom`.

     - Returns: A `Chatroom` created using the data from this `ChatroomViewData`.
     */
    public func toChatroom() -> Chatroom {
        // Explicitly unwrap or transform nested optional types
        let member: Member? = self.member?.toMember()
        let type: ChatroomType? = self.type?.toChatroomType()
        let deletedByMember: Member? = self.deletedByMember?.toMember()
        let reactions: [Reaction] =
            self.reactions?.compactMap { $0.toReaction() } ?? []
        let cohorts: [Cohort] = self.cohorts?.compactMap { $0.toCohort() } ?? []
        let lastConversation = self.lastConversation?.toConversation()
        let lastSeenConversation = self.lastSeenConversation?.toConversation()
        let topic = self.topic?.toConversation()
        let chatRequestState = self.chatRequestState?.toChatRequestState()

        // Initialize the builder with explicit types
        var chatroomBuilder = Chatroom.Builder()
        chatroomBuilder = chatroomBuilder.member(member)
            .id(self.id)
            .title(self.title)
            .createdAt(self.createdAt)
            .answerText(self.answerText)
            .state(self.state)
            .unseenCount(self.unseenCount)
            .shareUrl(self.shareUrl)
            .communityId(self.communityId)
            .communityName(self.communityName)
            .type(type?.rawValue)
            .about(self.about)
            .header(self.header)
            .showFollowTelescope(self.showFollowTelescope)
            .showFollowAutoTag(self.showFollowAutoTag)
            .cardCreationTime(self.cardCreationTime)
            .participantsCount(self.participantsCount)
            .totalResponseCount(self.totalResponseCount)
            .muteStatus(self.muteStatus)
            .followStatus(self.followStatus)
            .hasBeenNamed(self.hasBeenNamed)
            .hasReactions(self.hasReactions)
            .date(self.date)
            .isTagged(self.isTagged)
            .isPending(self.isPending)
            .isPinned(self.isPinned)
            .isDeleted(self.isDeleted)
            .userId(self.userId)
            .deletedBy(self.deletedBy)
            .deletedByMember(deletedByMember)
            .updatedAt(self.updatedAt)
            .lastSeenConversationId(self.lastSeenConversationId)
            .lastConversationId(self.lastConversationId)
            .dateEpoch(self.dateEpoch)
            .isSecret(self.isSecret)
            .secretChatroomParticipants(self.secretChatroomParticipants)
            .secretChatroomLeft(self.secretChatroomLeft)
            .reactions(reactions)
            .topicId(self.topicId)
            .topic(topic)
            .autoFollowDone(self.autoFollowDone)
            .isEdited(self.isEdited)
            .access(self.access)
            .memberCanMessage(self.memberCanMessage)
            .cohorts(cohorts)
            .externalSeen(self.externalSeen)
            .unreadConversationCount(self.unreadConversationCount)
            .chatroomImageUrl(self.chatroomImageUrl)
            .accessWithoutSubscription(self.accessWithoutSubscription)
            .lastConversation(lastConversation)
            .lastSeenConversation(lastSeenConversation)
            .draftConversation(self.draftConversation)
            .isConversationStored(self.isConversationStored)
            .isDraft(self.isDraft)
            .totalAllResponseCount(self.totalAllResponseCount)
            .chatRequestCreatedAt(self.chatRequestCreatedAt)
            .chatRequestState(chatRequestState?.rawValue)
            .chatRequestedById(self.chatRequestedById)
            .chatRequestedByUser(self.chatRequestedByUser?.toMember())
            .chatWithUserId(self.chatWithUserId)
            .isPrivate(self.isPrivate)
            .isPrivateMember(self.isPrivateMember)
            .chatWithUser(self.chatWithUser?.toMember())

        // Build and return the Chatroom
        return chatroomBuilder.build()
    }
}
