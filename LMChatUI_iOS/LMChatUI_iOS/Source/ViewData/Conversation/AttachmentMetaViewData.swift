//
//  AttachmentMetaViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

/// A view-data class that mirrors the properties of `AttachmentMeta`.
///
/// This class is mutable and designed for UI layers or intermediate layers
/// where flexibility in modifying properties is required.
public class AttachmentMetaViewData {
    // MARK: - Properties
    public var numberOfPage: Int?
    public var size: Int?
    public var duration: Int?

    // MARK: - Initializer
    public init(numberOfPage: Int?, size: Int?, duration: Int?) {
        self.numberOfPage = numberOfPage
        self.size = size
        self.duration = duration
    }
}
