//
//  DataModelConverter.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 12/04/24.
//

import Foundation
import LikeMindsChatData
import LikeMindsChatUI

class DataModelConverter {
    
    static let shared = DataModelConverter()
    
    func convertPollOptionsIntoResultPollOptions(_ polls: [Poll]) -> [LMChatPollDataModel.Option] {
        let pollsOpt = polls.reduce([]) { result, element in
            result.contains(where: {$0.id == element.id}) ? result : result + [element]
        }
        let pollOptions = pollsOpt.sorted(by: {($0.id ?? "0") < ($1.id ?? "0")})
        return  pollOptions.map { poll in
            return LMChatPollDataModel.Option(id: poll.id ?? "",
                                              option: poll.text ?? "",
                                              isSelected: poll.isSelected ?? false,
                                              voteCount: poll.noVotes ?? 0,
                                              percentage: poll.percentage ?? 0,
                                              addedBy: .init(userName: poll.member?.name ?? "",
                                                             userUUID: poll.member?.sdkClientInfo?.uuid ?? ""))
        }
    }
    
    func convertPostConversation(uuid: String, communityId: String, request: PostConversationRequest, fileUrls: [AttachmentViewData]?) -> Conversation {
        let miliseconds = Int(Date().millisecondsSince1970)
        let member = LMChatClient.shared.getCurrentMember()?.data?.member
        var widget: Widget? = nil
        
        if let metadata = request.metadata {
            
            var widgetBuilder: Widget.Builder = Widget.Builder()
            widgetBuilder = widgetBuilder.metadata(metadata)
            widgetBuilder = widgetBuilder.id(UUID().uuidString)
            widget = widgetBuilder.build()
        }
        
        return Conversation.Builder()
            .id(request.temporaryId)
            .chatroomId(request.chatroomId)
            .communityId(communityId)
            .answer(request.text)
            .state(ConversationState.normal.rawValue)
            .createdEpoch(miliseconds)
            .memberId(uuid)
            .member(member)
            .createdAt(LMCoreTimeUtils.generateCreateAtDate(miliseconds: Double(miliseconds), format: "HH:mm"))
            .attachments(convertAttachments(fileUrls, tempConvId: request.temporaryId))
            .lastSeen(true)
            .ogTags(request.ogTags)
            .date(LMCoreTimeUtils.generateCreateAtDate(miliseconds: Double(miliseconds)))
            .replyConversationId(request.repliedConversationId)
            .localCreatedEpoch(miliseconds)
            .temporaryId(request.temporaryId)
            .isEdited(false)
            .replyChatroomId(request.repliedChatroomId)
            .attachmentUploaded(false)
            .conversationStatus(.sending)
            .widget(widget)
            .build()
    }
    
    func convertPostPollConversation(uuid: String, communityId: String, request: PostPollConversationRequest) -> Conversation {
        let miliseconds = Int(Date().millisecondsSince1970)
        let member = LMChatClient.shared.getCurrentMember()?.data?.member
        return Conversation.Builder()
            .id(request.temporaryId)
            .chatroomId(request.chatroomId)
            .communityId(communityId)
            .answer(request.text)
            .state(request.state)
            .createdEpoch(miliseconds)
            .memberId(uuid)
            .member(member)
            .createdAt(LMCoreTimeUtils.generateCreateAtDate(miliseconds: Double(miliseconds), format: "HH:mm"))
            .lastSeen(true)
            .date(LMCoreTimeUtils.generateCreateAtDate(miliseconds: Double(miliseconds)))
            .replyConversationId(request.repliedConversationId)
            .localCreatedEpoch(miliseconds)
            .temporaryId(request.temporaryId)
            .isEdited(false)
            .expiryTime(request.expiryTime)
            .conversationStatus(.sending)
            .polls(request.polls)
            .pollType(request.pollType)
            .multipleSelectNum(request.multipleSelectNo)
            .multipleSelectState(request.multipleSelectState)
            .build()
    }
    
    func convertAttachments(_ fileUrls: [AttachmentViewData]?, tempConvId: String?) -> [Attachment]? {
        var i = 0
        return fileUrls?.map({ media in
            i += 1
            return convertAttachment(mediaData: media, index: i, tempConvId: tempConvId)
        })
    }
    
    func convertAttachment(mediaData: AttachmentViewData, index: Int, tempConvId: String?) -> Attachment {
        let tempId = "\(tempConvId ?? "")-\(index)"
        mediaData.id = tempId
        return mediaData.toAttachment()
    }
}
