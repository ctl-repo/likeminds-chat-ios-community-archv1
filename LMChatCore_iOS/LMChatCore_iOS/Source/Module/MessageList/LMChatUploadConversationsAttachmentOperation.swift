//
//  LMChatUploadConversationsAttachmentOperation.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 21/04/24.
//

import Foundation
import LikeMindsChatData
import LikeMindsChatUI

/// A singleton class responsible for managing the upload of attachments in chat conversations.
/// This class handles the asynchronous upload of files and their thumbnails to AWS storage.
///
/// Example usage:
/// ```swift
/// // Upload multiple attachments
/// let attachments = [attachment1, attachment2, attachment3]
/// let uploadedAttachments = await LMChatConversationAttachmentUpload.shared.uploadAttachments(withAttachments: attachments)
///
/// // Cancel uploads for a specific conversation
/// LMChatConversationAttachmentUpload.shared.cancelUploadingFor(conversationId: "conversation123")
///
/// // Resume uploads for a specific conversation
/// LMChatConversationAttachmentUpload.shared.resumeUploadingFor(conversationId: "conversation123")
/// ```
class LMChatConversationAttachmentUpload {
    /// Shared instance of the upload manager
    static let shared: LMChatConversationAttachmentUpload = .init()
    
    /// Private initializer to enforce singleton pattern
    private init() {}

    /// Cancels all ongoing upload tasks for a specific conversation
    /// - Parameter conversationId: The unique identifier of the conversation
    ///
    /// Example:
    /// ```swift
    /// LMChatConversationAttachmentUpload.shared.cancelUploadingFor(conversationId: "conversation123")
    /// ```
    func cancelUploadingFor(conversationId: String) {
        LMChatAWSManager.shared.cancelAllTaskFor(groupId: conversationId)
    }

    /// Resumes all paused upload tasks for a specific conversation
    /// - Parameter conversationId: The unique identifier of the conversation
    ///
    /// Example:
    /// ```swift
    /// LMChatConversationAttachmentUpload.shared.resumeUploadingFor(conversationId: "conversation123")
    /// ```
    func resumeUploadingFor(conversationId: String) {
        LMChatAWSManager.shared.resumeAllTaskFor(groupId: conversationId)
    }

    /// Custom error type for upload-related errors
    struct UploadError: Error {
        /// Descriptive message explaining the error
        let message: String
    }

    /// Uploads multiple attachments asynchronously to AWS storage
    /// - Parameter attachments: Array of attachments to upload
    /// - Returns: Array of updated attachments with their AWS URLs
    ///
    /// This method performs the following steps:
    /// 1. Creates a task group for concurrent uploads
    /// 2. For each attachment:
    ///    - Validates the file URL
    ///    - Uploads the main file to AWS
    ///    - Uploads the thumbnail if available
    ///    - Updates the attachment with AWS URLs
    /// 3. Collects and returns all updated attachments
    ///
    /// Example:
    /// ```swift
    /// let attachments = [
    ///     AttachmentViewData(name: "image.jpg", localPickedURL: imageURL),
    ///     AttachmentViewData(name: "document.pdf", localPickedURL: documentURL)
    /// ]
    /// let uploadedAttachments = await uploadAttachments(withAttachments: attachments)
    /// ```
    func uploadAttachments(
        withAttachments attachments: [AttachmentViewData]
    ) async -> [AttachmentViewData] {
        var updatedAttachments: [AttachmentViewData] = []

        // Create a task group for concurrent uploads
        await withTaskGroup(of: AttachmentViewData?.self) { group in
            for attachment in attachments {
                // Skip already uploaded attachments
                if attachment.isUploaded {
                    updatedAttachments.append(attachment)
                    continue
                }
                
                // Add a new task for each attachment
                group.addTask {
                    // Run the upload logic in a detached background task
                    return await Task.detached(priority: .background) {
                        // Validate the main file URL
                        guard let fileUrl = attachment.localPickedURL else {
                            attachment.isUploaded = false
                            return attachment
                        }

                        do {
                            // Upload the main file to AWS
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
                            // Upload thumbnail if available
                            if let thumbFileUrl = attachment
                                .localPickedThumbnailURL
                            {
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

                            // Update attachment with AWS URLs and mark as uploaded
                            attachment.url = awsFilePath
                            attachment.thumbnailUrl = awsThumbnailFilePath
                            attachment.isUploaded = true
                            
                            return attachment
                        } catch {
                            // Mark attachment as failed on error
                            attachment.isUploaded = false
                            return attachment
                        }
                    }.value
                }
            }

            // Collect results from all tasks
            for await result in group {
                if let attachment = result {
                    updatedAttachments.append(attachment)
                }
            }
        }

        return updatedAttachments
    }
}
