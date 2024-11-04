//
//  utils.swift
//  Pods
//
//  Created by Anurag Tyagi on 22/10/24.
//

import LikeMindsChat
import UIKit

func convertToAttachmentList(from mediaDataList: [LMChatAttachmentUploadModel])
    -> [Attachment]
{
    return mediaDataList.map { mediaData in
        Attachment.builder()
            .id(nil)  // Assuming id is not available in LMChatAttachmentUploadModel
            .name(mediaData.name)
            .url(mediaData.awsUrl ?? "")  // Assuming awsUrl is equivalent to file_url
            .type(mediaData.fileType)
            .index(mediaData.index)
            .width(mediaData.width)
            .height(mediaData.height)
            .awsFolderPath(mediaData.awsFolderPath)
            .localFilePath(mediaData.localFilePath)
            .thumbnailUrl(mediaData.thumbnailUri?.absoluteString)  // Converting URL to String
            .thumbnailAWSFolderPath(mediaData.thumbnailAWSFolderPath)
            .thumbnailLocalFilePath(mediaData.thumbnailLocalFilePath)
            .meta(nil)  // Assuming the meta field needs further conversion if necessary
            .createdAt(nil)  // Assuming createdAt is not available
            .updatedAt(nil)  // Assuming updatedAt is not available
            .build()
    }
}

func isOtherUserAIChatbot(chatroom: Chatroom) -> Bool {
    // Fetch the logged-in user's UUID

    guard
        let loggedInUserUUID = LMChatClient.shared.getCurrentMember()?.data?
            .member?.uuid
    else {
        return false
    }

    // Define the other member based on the comparison
    let otherMember: Member?
    if loggedInUserUUID == chatroom.member?.sdkClientInfo?.uuid {
        if chatroom.chatWithUser != nil {
            otherMember = chatroom.chatWithUser!
        } else {
            return false
        }
    } else {
        if chatroom.member != nil {
            otherMember = chatroom.member!
        } else {
            return false
        }
    }

    // Check if the other member's roles contain "chatbot"
    if otherMember != nil && otherMember?.roles != nil
        && otherMember!.roles!.contains(where: { $0 == .chatbot })
    {
        return true
    }

    return false
}
