//
//  Attachmet+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//
import LikeMindsChatData
import LikeMindsChatUI

extension Attachment {
    /**
     Converts an `Attachment` instance into an `AttachmentViewData`.

     - Returns: A `AttachmentViewData` populated with the data from this `Attachment`.
     */
    public func toViewData() -> AttachmentViewData {
        return AttachmentViewData(
            id: self.id,
            name: self.name,
            url: self.url,
            type: AttachmentViewData.AttachmentType(rawValue: self.type?.rawValue ?? "") ?? AttachmentViewData.AttachmentType.unknown,
            index: self.index,
            width: self.width,
            height: self.height,
            awsFolderPath: self.awsFolderPath,
            localFilePath: self.localFilePath,
            thumbnailUrl: self.thumbnailUrl,
            thumbnailAWSFolderPath: self.thumbnailAWSFolderPath,
            thumbnailLocalFilePath: self.thumbnailLocalFilePath,
            meta: self.meta?.toViewData(),
            createdAt: self.createdAt,
            updatedAt: self.updatedAt,
            isUploaded: self.isUploaded
        )
    }
}

extension AttachmentViewData {
    /**
     Converts an `AttachmentViewData` instance back into an `Attachment`.

     - Returns: An `Attachment` created using the data from this `AttachmentViewData`.
     */
    public func toAttachment() -> Attachment {
        return Attachment.Builder()
            .id(self.id)
            .name(self.name)
            .url(self.url ?? "")
            .type(Attachment.AttachmentType(rawValue: self.type?.rawValue ?? "") ?? Attachment.AttachmentType.unknown)
            .index(self.index)
            .width(self.width)
            .height(self.height)
            .awsFolderPath(self.awsFolderPath)
            .localFilePath(self.localFilePath)
            .thumbnailUrl(self.thumbnailUrl)
            .thumbnailAWSFolderPath(self.thumbnailAWSFolderPath)
            .thumbnailLocalFilePath(self.thumbnailLocalFilePath)
            .meta(self.meta?.toAttachmentMeta())
            .createdAt(self.createdAt)
            .updatedAt(self.updatedAt)
            .isUploaded(self.isUploaded)
            .build()
    }
}
