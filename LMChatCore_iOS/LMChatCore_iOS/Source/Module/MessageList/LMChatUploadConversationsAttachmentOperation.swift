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
    ) async -> [AttachmentViewData] {
        var updatedAttachments: [AttachmentViewData] = []

        await withTaskGroup(of: AttachmentViewData?.self) { group in
            for attachment in attachments {
                group.addTask {
                    // Run the upload logic in a detached background task.
                    return await Task.detached(priority: .background) {
                        // Validate the main file URL.
                        guard let fileUrl = attachment.localPickedURL else {
                            attachment.isUploaded = false
                            return attachment
                        }

                        do {
                            // Attempt to upload the main file.
                            let awsFilePath = try await LMChatAWSManager.shared
                                .uploadFileAsync(
                                    fileUrl: fileUrl,
                                    awsPath: attachment.awsFolderPath ?? "",
                                    fileName: attachment.name
                                        ?? "\(fileUrl.pathExtension)",
                                    contentType: attachment.type?.rawValue
                                        ?? "",
                                    withTaskGroupId: attachment.name
                                )

                            var awsThumbnailFilePath: String? = nil
                            if let thumbFileUrl = attachment
                                .localPickedThumbnailURL
                            {
                                // Attempt to upload the thumbnail.
                                awsThumbnailFilePath =
                                    try await LMChatAWSManager.shared
                                    .uploadFileAsync(
                                        fileUrl: thumbFileUrl,
                                        awsPath: attachment
                                            .thumbnailAWSFolderPath ?? "",
                                        fileName:
                                            "\(thumbFileUrl.pathExtension)",
                                        contentType: "image",
                                        withTaskGroupId:
                                            "\(thumbFileUrl.pathExtension)"
                                    )
                            }

                            // Update attachment properties on success.
                            attachment.url = awsFilePath
                            attachment.thumbnailUrl = awsThumbnailFilePath
                            attachment.isUploaded = true
                            Task{
                                var _ = await LMChatClient.shared.updateAttachment(attachment: attachment.toAttachment())
                            }
                            return attachment
                        } catch {
                            // On any failure, mark the attachment as not uploaded.
                            attachment.isUploaded = false
                            return attachment
                        }
                    }.value
                }
            }

            // Collect all results from the task group.
            for await result in group {
                if let attachment = result {
                    updatedAttachments.append(attachment)
                }
            }
        }

        return updatedAttachments
    }

}
