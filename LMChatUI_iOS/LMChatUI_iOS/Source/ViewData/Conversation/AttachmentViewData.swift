//
//  AttachmentViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation
import PhotosUI

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
    
    // Local Picked Media handled in LMChatCore
    public var localPickedURL: URL?
    public var localPickedThumbnailURL: URL?
    public var image: UIImage?
    public var livePhoto: PHLivePhoto?

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
        isUploaded: Bool = false,
        localPickedURL: URL? = nil,
        localPickedThumbnailURL: URL? = nil,
        image: UIImage? = nil,
        livePhoto: PHLivePhoto? = nil
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
        self.localPickedURL = localPickedURL
        self.localPickedThumbnailURL = localPickedThumbnailURL
        self.image = image
        self.livePhoto = livePhoto
    }
    
    // MARK: - Builder Pattern
    public class Builder {
        private var id: String?
        private var name: String?
        private var url: String?
        private var type: AttachmentType?
        private var index: Int?
        private var width: Int?
        private var height: Int?
        private var awsFolderPath: String?
        private var localFilePath: String?
        private var thumbnailUrl: String?
        private var thumbnailAWSFolderPath: String?
        private var thumbnailLocalFilePath: String?
        private var meta: AttachmentMetaViewData?
        private var createdAt: Int?
        private var updatedAt: Int?
        private var isUploaded: Bool = false
        private var localPickedURL: URL?
        private var localPickedThumbnailURL: URL?
        private var image: UIImage?
        private var livePhoto: PHLivePhoto?
        
        public init() {}
        
        public func id(_ id: String?) -> Builder {
            self.id = id
            return self
        }
        
        public func name(_ name: String?) -> Builder {
            self.name = name
            return self
        }
        
        public func url(_ url: String?) -> Builder {
            self.url = url
            return self
        }
        
        public func type(_ type: AttachmentType?) -> Builder {
            self.type = type
            return self
        }
        
        public func index(_ index: Int?) -> Builder {
            self.index = index
            return self
        }
        
        public func width(_ width: Int?) -> Builder {
            self.width = width
            return self
        }
        
        public func height(_ height: Int?) -> Builder {
            self.height = height
            return self
        }
        
        public func awsFolderPath(_ awsFolderPath: String?) -> Builder {
            self.awsFolderPath = awsFolderPath
            return self
        }
        
        public func localFilePath(_ localFilePath: String?) -> Builder {
            self.localFilePath = localFilePath
            return self
        }
        
        public func thumbnailUrl(_ thumbnailUrl: String?) -> Builder {
            self.thumbnailUrl = thumbnailUrl
            return self
        }
        
        public func thumbnailAWSFolderPath(_ thumbnailAWSFolderPath: String?) -> Builder {
            self.thumbnailAWSFolderPath = thumbnailAWSFolderPath
            return self
        }
        
        public func thumbnailLocalFilePath(_ thumbnailLocalFilePath: String?) -> Builder {
            self.thumbnailLocalFilePath = thumbnailLocalFilePath
            return self
        }
        
        public func meta(_ meta: AttachmentMetaViewData?) -> Builder {
            self.meta = meta
            return self
        }
        
        public func createdAt(_ createdAt: Int?) -> Builder {
            self.createdAt = createdAt
            return self
        }
        
        public func updatedAt(_ updatedAt: Int?) -> Builder {
            self.updatedAt = updatedAt
            return self
        }
        
        public func isUploaded(_ isUploaded: Bool) -> Builder {
            self.isUploaded = isUploaded
            return self
        }
        
        public func localPickedURL(_ localPickedURL: URL?) -> Builder {
            self.localPickedURL = localPickedURL
            return self
        }
        
        @discardableResult
        public func image(_ image: UIImage?) -> Builder {
            self.image = image
            return self
        }
        
        @discardableResult
        public func localPickedThumbnailURL(_ localPickedThumbnailURL: URL?) -> Builder {
            self.localPickedThumbnailURL = localPickedThumbnailURL
            return self
        }
        
        @discardableResult
        public func livePhoto(_ livePhoto: PHLivePhoto?) -> Builder {
            self.livePhoto = livePhoto
            return self
        }
        
        public func build() -> AttachmentViewData {
            return AttachmentViewData(
                id: self.id,
                name: self.name,
                url: self.url,
                type: self.type,
                index: self.index,
                width: self.width,
                height: self.height,
                awsFolderPath: self.awsFolderPath,
                localFilePath: self.localFilePath,
                thumbnailUrl: self.thumbnailUrl,
                thumbnailAWSFolderPath: self.thumbnailAWSFolderPath,
                thumbnailLocalFilePath: self.thumbnailLocalFilePath,
                meta: self.meta,
                createdAt: self.createdAt,
                updatedAt: self.updatedAt,
                isUploaded: self.isUploaded,
                localPickedURL: self.localPickedURL,
                localPickedThumbnailURL:  self.localPickedThumbnailURL,
                image:  self.image
            )
        }
    }
}
