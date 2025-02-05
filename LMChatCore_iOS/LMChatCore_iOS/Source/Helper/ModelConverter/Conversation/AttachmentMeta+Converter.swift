//
//  AttachmentMeta+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import LikeMindsChatData
import LikeMindsChatUI

extension AttachmentMeta {
    /**
     Converts an `AttachmentMeta` instance into an `AttachmentMetaViewData`.

     - Returns: An `AttachmentMetaViewData` populated with the data from this `AttachmentMeta`.
     */
    public func toViewData() -> AttachmentMetaViewData {
        return AttachmentMetaViewData(
            numberOfPage: self.numberOfPage,
            size: self.size,
            duration: self.duration
        )
    }
}

extension AttachmentMetaViewData {
    /**
     Converts an `AttachmentMetaViewData` instance back into an `AttachmentMeta`.

     - Returns: An `AttachmentMeta` created using the data from this `AttachmentMetaViewData`.
     */
    public func toAttachmentMeta() -> AttachmentMeta {
        return AttachmentMeta.builder()
            .numberOfPage(self.numberOfPage)
            .size(self.size)
            .duration(self.duration)
            .build()
    }
}
