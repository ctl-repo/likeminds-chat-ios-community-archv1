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
     Converts an `Attachment` instance into an `AttachmentViewData` object for UI representation.
     
     This method transforms the data model `Attachment` into a view-specific data model `AttachmentViewData`.
     All properties from the source attachment are mapped to their corresponding properties in the view data model.
     
     The conversion includes:
     - Basic properties like id, name, and URL
     - Attachment type conversion
     - Dimension information (width and height)
     - File paths for both local and AWS storage
     - Thumbnail information
     - Metadata conversion
     - Timestamps and upload status
     
     - Returns: An `AttachmentViewData` instance containing all the transformed data from this `Attachment`.
     The returned object will have the same content but in a format suitable for UI rendering.
     
     - Note: If the attachment type is not recognized, it will default to `.unknown`
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
     Converts an `AttachmentViewData` instance back into an `Attachment` data model.
     
     This method performs the reverse transformation from the UI representation back to the data model.
     It uses the Builder pattern to construct the `Attachment` instance, ensuring all properties are properly set.
     
     The conversion includes:
     - Basic properties like id, name, and URL
     - Attachment type conversion (defaults to .unknown if type is not recognized)
     - Dimension information (width and height)
     - File paths for both local and AWS storage
     - Thumbnail information
     - Metadata conversion
     - Timestamps and upload status
     
     - Returns: An `Attachment` instance created using the Builder pattern, containing all the data
     from this `AttachmentViewData` transformed into the data model format.
     
     - Note: 
        - URL will be converted to an empty string if nil
        - Attachment type will default to .unknown if the type is not recognized
        - Meta information will only be converted if present
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
