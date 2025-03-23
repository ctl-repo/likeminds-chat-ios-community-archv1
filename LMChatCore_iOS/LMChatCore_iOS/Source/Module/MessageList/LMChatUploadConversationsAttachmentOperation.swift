//
//  LMChatUploadConversationsAttachmentOperation.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 21/04/24.
//

import Foundation
import LikeMindsChatData
import LikeMindsChatUI

class LMChatConversationAttachmentUpload {
    static let shared: LMChatConversationAttachmentUpload = .init()
    private init() {}

    func cancelUploadingFor(conversationId: String) {
        LMChatAWSManager.shared.cancelAllTaskFor(groupId: conversationId)
    }

    func resumeUploadingFor(conversationId: String) {
        LMChatAWSManager.shared.resumeAllTaskFor(groupId: conversationId)
    }

    struct UploadError: Error {
        let message: String
    }

    func uploadAttachments(
        withAttachments attachments: [AttachmentViewData]
    ) async throws -> [AttachmentViewData] {
        var updatedAttachments: [AttachmentViewData] = []
        try await withThrowingTaskGroup(of: AttachmentViewData?.self) {
            group in
            for attachment in attachments {
                group.addTask {
                    return try await Task.detached(priority: .background) {
                        // Upload the main file
                        guard let fileUrl = attachment.localPickedURL else {
                            throw UploadError(
                                message:
                                    "Invalid file URL for attachment: \(attachment.name ?? "Unknown")"
                            )
                        }

                        do {
                            let awsFilePath = try await LMChatAWSManager.shared
                                .uploadFileAsync(
                                    fileUrl: fileUrl,
                                    awsPath: attachment.awsFolderPath ?? "",
                                    fileName: attachment.name
                                        ?? "\(fileUrl.pathExtension)",
                                    contentType: attachment.type?.rawValue ?? "",
                                    withTaskGroupId: attachment.name
                                )

                            var awsThumbnailFilePath: String? = nil
                            if let thumbFileUrl = attachment.localPickedThumbnailURL
                            {
                                // Upload the thumbnail file if it exists
                                awsThumbnailFilePath =
                                    try await LMChatAWSManager.shared
                                    .uploadFileAsync(
                                        fileUrl: thumbFileUrl,
                                        awsPath: attachment.thumbnailAWSFolderPath ?? "",
                                        fileName:
                                            "\(thumbFileUrl.pathExtension)",
                                        contentType: "image",
                                        withTaskGroupId:
                                            "\(thumbFileUrl.pathExtension)"
                                    )
                            }

                            attachment.url = awsFilePath
                            attachment.thumbnailUrl = awsThumbnailFilePath

                            return attachment
                        } catch {
                            // Throw an error if the upload fails
                            throw UploadError(
                                message:
                                    "Failed to upload file for attachment: \(attachment.name ?? "Unknown") - \(error.localizedDescription)"
                            )
                        }
                    }.value
                }
            }

            // Collect all results from the task group
            for try await attachment in group {
                if let attachment = attachment {
                    updatedAttachments.append(attachment)
                }
            }
        }
        return updatedAttachments
    }
}
