//
//  AttachmentViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/// A view-data class that mirrors the properties of `Attachment`.
///
/// This class is mutable and designed for UI layers or intermediate layers
/// where flexibility in modifying properties is required.
public class AttachmentViewData {
    
    /// Represents the type of an attachment.
    public enum AttachmentType: String, Codable {
        case image
        case video
        case audio
        case gif
        case link
        case pdf
        case doc
        case document
        case voiceNote = "voice_note"
        case unknown  // Fallback case for unexpected types

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            self = AttachmentType(rawValue: value) ?? .unknown
        }
    }
    
    
    // MARK: - Properties
    public var id: String?
    public var name: String?
    public var url: String?
    public var type: AttachmentType?
    public var index: Int?
    public var width: Int?
    public var height: Int?
    public var awsFolderPath: String?
    public var localFilePath: String?
    public var thumbnailUrl: String?
    public var thumbnailAWSFolderPath: String?
    public var thumbnailLocalFilePath: String?
    public var meta: AttachmentMetaViewData?
    public var createdAt: Int?
    public var updatedAt: Int?
    public var isUploaded: Bool = false

    // MARK: - Initializer
    public init(
        id: String?,
        name: String?,
        url: String?,
        type: AttachmentType?,
        index: Int?,
        width: Int?,
        height: Int?,
        awsFolderPath: String?,
        localFilePath: String?,
        thumbnailUrl: String?,
        thumbnailAWSFolderPath: String?,
        thumbnailLocalFilePath: String?,
        meta: AttachmentMetaViewData?,
        createdAt: Int?,
        updatedAt: Int?,
        isUploaded: Bool = false
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.type = type
        self.index = index
        self.width = width
        self.height = height
        self.awsFolderPath = awsFolderPath
        self.localFilePath = localFilePath
        self.thumbnailUrl = thumbnailUrl
        self.thumbnailAWSFolderPath = thumbnailAWSFolderPath
        self.thumbnailLocalFilePath = thumbnailLocalFilePath
        self.meta = meta
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isUploaded = isUploaded
    }
}
