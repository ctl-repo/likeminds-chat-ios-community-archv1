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
    // MARK: - Properties
    public var id: String?
    public var name: String?
    public var url: String?
    public var type: String?
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

    // MARK: - Initializer
    public init(
        id: String?,
        name: String?,
        url: String?,
        type: String?,
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
        updatedAt: Int?
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
    }
}
