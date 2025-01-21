//
//  LikOGTags+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import LikeMindsChatData
import LikeMindsChatUI

extension LinkOGTags {
    /**
     Converts a `LinkOGTags` instance into a `LinkOGTagsViewData`.

     - Returns: A `LinkOGTagsViewData` populated with the data from this `LinkOGTags`.
     */
    public func toViewData() -> LinkOGTagsViewData {
        return LinkOGTagsViewData(
            title: self.title,
            image: self.image,
            description: self.description,
            url: self.url
        )
    }
}

extension LinkOGTagsViewData {
    /**
     Converts a `LinkOGTagsViewData` instance back into a `LinkOGTags`.

     - Returns: A `LinkOGTags` created using the data from this `LinkOGTagsViewData`.
     */
    public func toLinkOGTags() -> LinkOGTags {
        return LinkOGTags.Builder()
            .title(self.title)
            .image(self.image)
            .description(self.description)
            .url(self.url)
            .build()
    }
}
