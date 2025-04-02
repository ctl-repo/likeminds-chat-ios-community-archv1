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

    // MARK: - Builder Pattern
    public class Builder {
        private var numberOfPage: Int?
        private var size: Int?
        private var duration: Int?

        public init() {}

        public func numberOfPage(_ numberOfPage: Int?) -> Builder {
            self.numberOfPage = numberOfPage
            return self
        }

        public func size(_ size: Int?) -> Builder {
            self.size = size
            return self
        }

        public func duration(_ duration: Int?) -> Builder {
            self.duration = duration
            return self
        }

        public func build() -> AttachmentMetaViewData {
            return AttachmentMetaViewData(
                numberOfPage: numberOfPage, size: size, duration: duration)
        }
    }
}
