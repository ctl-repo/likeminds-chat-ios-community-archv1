//
//  utils.swift
//  Pods
//
//  Created by Anurag Tyagi on 22/10/24.
//

import LikeMindsChatData
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

/// Returns the conversation type based on the attachments and ogTags of a conversation.
/// - Parameter conversation: The conversation from which to determine the type.
/// - Returns: A string representing the conversation type (e.g., "image", "video", "doc", etc.).
func getConversationType(_ attachments: [Attachment]) -> String {
    
    // Count how many attachments exist for each media type
//    let imageCount = getMediaCount(mediaType: "image", attachments: attachments)
//    let gifCount = getMediaCount(mediaType: "gif", attachments: attachments)
//    let videoCount = getMediaCount(mediaType: "video", attachments: attachments)
//    let pdfCount = getMediaCount(mediaType: "pdf", attachments: attachments)
//    let audioCount = getMediaCount(mediaType: "audio", attachments: attachments)
//    let voiceNoteCount = getMediaCount(mediaType: "voice_note", attachments: attachments)
    
    // Determine the conversation type using the counts and any link in ogTags
//    switch true {
//    case imageCount > 0 && videoCount > 0:
//        return "image, video"
//    case imageCount > 0:
//        return "image"
//    case gifCount > 0:
//        return "gif"
//    case videoCount > 0:
//        return "video"
//    case pdfCount > 0:
//        return "doc"
//    case audioCount > 0:
//        return "audio"
//    case voiceNoteCount > 0:
//        return "voice note"
//    default:
//        return "text"
//    }
    return "text"
}

/// Returns the number of attachments that match the specified media type.
/// - Parameters:
///   - mediaType: The media type to look for (e.g., IMAGE, VIDEO, etc.).
///   - attachments: An optional array of `AttachmentViewData`.
/// - Returns: The number of attachments matching `mediaType`.
func getMediaCount(mediaType: String, attachments: [Attachment]?) -> Int {
    guard let attachments = attachments else {
        return 0
    }
    return attachments.filter { $0.type == mediaType }.count
}

/// Returns either the `collabcard_id` or the `chatroom_id` from the given URL string.
/// If neither parameter is found, it returns `nil`.
///
/// Examples:
///  - "route://collabcard?collabcard_id=99122"    -> "99122"
///  - "route://chatroom?chatroom_id=12345"        -> "12345"
///  - "route://others?some_param=abc"            -> nil
///  - nil                                         -> nil
///
/// - Parameter route: The URL string containing query parameters.
/// - Returns: The collabcard_id or chatroom_id, if found. Otherwise, `nil`.
public func getChatroomIdFromRoute(from route: String?) -> String? {
    guard let route = route,
          let url = URL(string: route),
          let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
          let queryItems = components.queryItems else {
        return nil
    }
    
    // Attempt to fetch "collabcard_id" first
    let collabcardId = queryItems.first(where: { $0.name == "collabcard_id" })?.value
    
    // If collabcardId is nil, try "chatroom_id"
    let chatroomId = queryItems.first(where: { $0.name == "chatroom_id" })?.value
    
    // Return whichever ID is non-nil (in your scenario, never both)
    return collabcardId ?? chatroomId
}

