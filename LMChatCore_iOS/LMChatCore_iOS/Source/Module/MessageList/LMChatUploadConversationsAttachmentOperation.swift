//
//  LMChatUploadConversationsAttachmentOperation.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 21/04/24.
//

import Foundation
import LikeMindsChat

class LMChatConversationAttachmentUpload {
    
    private let queue = OperationQueue()
    static let shared: LMChatConversationAttachmentUpload = .init()
    private init() {}
    
    func uploadConversationAttchment(withAttachments attachments: [LMChatAttachmentUploadModel], conversationId: String, convTempId: String) {
        let uploadConversationsAttachmentOperation = LMChatUploadConversationsAttachmentOperation(attachmentRequests: attachments, conversationId: conversationId, convTempId: convTempId)
        queue.addOperation(uploadConversationsAttachmentOperation)
    }
    
    func cancelUploadingFor(conversationId: String) {
        LMChatAWSManager.shared.cancelAllTaskFor(groupId: conversationId)
    }
    
    func resumeUploadingFor(conversationId: String) {
        LMChatAWSManager.shared.resumeAllTaskFor(groupId: conversationId)
    }
    
    struct UploadError: Error {
        let message: String
    }
    
    func uploadAttachments(withAttachments attachments: [LMChatAttachmentUploadModel]) async throws -> [LMChatAttachmentUploadModel] {
        var updatedAttachments: [LMChatAttachmentUploadModel] = []
        try await withThrowingTaskGroup(of: LMChatAttachmentUploadModel?.self) { group in
            for attachment in attachments {
                group.addTask {
                    // Upload the main file
                    guard let fileUrl = attachment.fileUrl else {
                        throw UploadError(message: "Invalid file URL for attachment: \(attachment.name ?? "Unknown")")
                    }
                    
                    do {
                        let awsFilePath = try await LMChatAWSManager.shared.uploadFileAsync(fileUrl: fileUrl,
                                                                                           awsPath: attachment.awsFolderPath,
                                                                                           fileName: attachment.name ?? "\(fileUrl.pathExtension)",
                                                                                           contentType: attachment.fileType,
                                                                                            withTaskGroupId: attachment.name)

                        var awsThumbnailFilePath: String? = nil
                        if let thumbFileUrl = URL(string: attachment.thumbnailLocalFilePath ?? ""),
                           let thumbnailAWSFolderPath = attachment.thumbnailAWSFolderPath {
                            // Upload the thumbnail file if it exists
                            awsThumbnailFilePath = try await LMChatAWSManager.shared.uploadFileAsync(fileUrl: thumbFileUrl,
                                                                                                     awsPath: thumbnailAWSFolderPath,
                                                                                                     fileName: "\(thumbFileUrl.pathExtension)",
                                                                                                     contentType: "image", withTaskGroupId:  "\(thumbFileUrl.pathExtension)")
                        }
                        
                        var attachmentBuilder = attachment.toBuilder()
                        attachmentBuilder = attachmentBuilder.awsUrl(awsFilePath)
                        attachmentBuilder = attachmentBuilder.thumbnailUri(URL(string:awsThumbnailFilePath ?? ""))
                        
                        updatedAttachments.append(attachmentBuilder.build())
                        return attachment
                        
                    } catch {
                        // Throw an error if the upload fails
                        throw UploadError(message: "Failed to upload file for attachment: \(attachment.name ?? "Unknown") - \(error.localizedDescription)")
                    }
                }
            }
        }
        return updatedAttachments
    }
}

class LMChatUploadConversationsAttachmentOperation: Operation {
    
    private var attachmentRequests: [LMChatAttachmentUploadModel]
    private var conversationId: String
    private var conversationTempId: String
    private var groupQueue: DispatchGroup = DispatchGroup()
    typealias completionBlock = (_ response: [String]?, _ error: Error?) -> Void

    
    static let attachmentPostCompleted = Notification.Name("ConversationAttachmentUploaded")
    static let postedId = "conversation_id"
    
    init(attachmentRequests: [LMChatAttachmentUploadModel], conversationId: String, convTempId: String) {
        self.attachmentRequests = attachmentRequests
        self.conversationId = conversationId
        self.conversationTempId = convTempId
    }
    
    func uploadConversation(withAttachments attachments: [LMChatAttachmentUploadModel], response: completionBlock){
        
        attachmentRequests.forEach { attachment in
            if let fileUrl = attachment.fileUrl {
                groupQueue.enter()
                let awsFolderPath = attachment.awsFolderPath
                LMChatAWSManager.shared.uploadfile(fileUrl: fileUrl,
                                               awsPath: awsFolderPath,
                                               fileName: attachment.name ?? "\(fileUrl.pathExtension)",
                                               contenType: attachment.fileType, withTaskGroupId: conversationTempId)
                { progress in
                    print("======> \(attachment.name ?? "") progress \(progress) <=======")
                } completion: {[weak self] awsFilePath, error in
                    guard let awsFilePath else {
                        print("AWS Upload Error: \(String(describing: error))")
                        self?.groupQueue.leave()
                        return
                    }
                    if let thumbfileUrl = URL(string: attachment.thumbnailLocalFilePath ?? ""), let thumbnailAWSFolderPath = attachment.thumbnailAWSFolderPath {
                        LMChatAWSManager.shared.uploadfile(fileUrl: thumbfileUrl,
                                                       awsPath: thumbnailAWSFolderPath,
                                                       fileName: "\(thumbfileUrl.pathExtension)",
                                                       contenType: "image", withTaskGroupId: nil)
                        { progress in }
                        completion: { awsThumbnailFilePath, error in
                            guard let awsThumbnailFilePath else {
                                print("AWS thumbnail Upload Error: \(String(describing: error))")
                                // TODO: Remove call for put conversation multi media
                                
                                //self?.putConversationMultiMedia(attachment: attachment, awsFilePath: awsFilePath, awsThumbnailFilePath: nil)
                                return
                            }
                            // TODO: Remove call for put conversation multi media
                            // self?.putConversationMultiMedia(attachment: attachment, awsFilePath: awsFilePath, awsThumbnailFilePath: awsThumbnailFilePath)
                        }
                    } else {
                        // TODO: Remove call for put conversation multi media
                        // self?.putConversationMultiMedia(attachment: attachment, awsFilePath: awsFilePath, awsThumbnailFilePath: nil)
                    }
                }
            }
        }
        groupQueue.notify(queue: .global(qos: .background)) { [weak self] in
            guard let self else { return }
            NotificationCenter.default.post(name: Self.attachmentPostCompleted, object: nil, userInfo: [Self.postedId: conversationId])
        }
        groupQueue.wait()
    }
    
    func uploadConversationAttachments() {
        attachmentRequests.forEach { attachment in
            if let fileUrl = attachment.fileUrl {
                groupQueue.enter()
                let awsFolderPath = attachment.awsFolderPath
                LMChatAWSManager.shared.uploadfile(fileUrl: fileUrl,
                                               awsPath: awsFolderPath,
                                               fileName: attachment.name ?? "\(fileUrl.pathExtension)",
                                               contenType: attachment.fileType, withTaskGroupId: conversationTempId)
                { progress in
                    print("======> \(attachment.name ?? "") progress \(progress) <=======")
                } completion: {[weak self] awsFilePath, error in
                    guard let awsFilePath else {
                        print("AWS Upload Error: \(String(describing: error))")
                        self?.groupQueue.leave()
                        return
                    }
                    if let thumbfileUrl = URL(string: attachment.thumbnailLocalFilePath ?? ""), let thumbnailAWSFolderPath = attachment.thumbnailAWSFolderPath {
                        LMChatAWSManager.shared.uploadfile(fileUrl: thumbfileUrl,
                                                       awsPath: thumbnailAWSFolderPath,
                                                       fileName: "\(thumbfileUrl.pathExtension)",
                                                       contenType: "image", withTaskGroupId: nil)
                        { progress in }
                        completion: { awsThumbnailFilePath, error in
                            guard let awsThumbnailFilePath else {
                                print("AWS thumbnail Upload Error: \(String(describing: error))")
                                // TODO: Remove call for put conversation multi media
                                // self?.putConversationMultiMedia(attachment: attachment, awsFilePath: awsFilePath, awsThumbnailFilePath: nil)
                                return
                            }
                            // TODO: Remove call for put conversation multi media
                            // self?.putConversationMultiMedia(attachment: attachment, awsFilePath: awsFilePath, awsThumbnailFilePath: awsThumbnailFilePath)
                        }
                    } else {
                        // TODO: Remove call for put conversation multi media
                        // self?.putConversationMultiMedia(attachment: attachment, awsFilePath: awsFilePath, awsThumbnailFilePath: nil)
                    }
                }
            }
        }
        groupQueue.notify(queue: .global(qos: .background)) { [weak self] in
            guard let self else { return }
            NotificationCenter.default.post(name: Self.attachmentPostCompleted, object: nil, userInfo: [Self.postedId: conversationId])
        }
        groupQueue.wait()
    }
    
    override func main() {
        uploadConversationAttachments()
    }
    
}
