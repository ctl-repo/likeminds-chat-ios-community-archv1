//
//  LinkOGTagsViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/// A view-data class that mirrors the properties of `LinkOGTags`.
///
/// This class is mutable and can be used in UI layers or intermediate layers
/// where flexibility in modifying properties is required.
public class LinkOGTagsViewData {
    // MARK: - Properties
    public var title: String?
    public var image: String?
    public var description: String?
    public var url: String?

    // MARK: - Initializer
    /**
     Initializes a new `LinkOGTagsViewData`.

     - Parameters:
       - title: The title of the Open Graph link.
       - image: The URL of the image for the Open Graph link.
       - description: The description of the Open Graph link.
       - url: The URL of the Open Graph link.
     */
    public init(
        title: String?, image: String?, description: String?, url: String?
    ) {
        self.title = title
        self.image = image
        self.description = description
        self.url = url
    }
}
