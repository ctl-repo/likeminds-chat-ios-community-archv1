//
//  QuestionViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/// A view-data class that mirrors the properties of `Question`.
///
/// This class is mutable and can be used in UI layers or intermediate layers
/// where a mutable model is preferred over the immutable `Question` struct.
public class QuestionViewData {

    // MARK: - Properties

    public var id: Int?
    public var questionTitle: String?
    public var state: Int?
    public var value: String?
    public var optional: Bool?
    public var helpText: String?
    public var field: Bool?
    public var isCompulsory: Bool?
    public var isHidden: Bool?
    public var communityId: String?
    public var memberId: String?
    public var directoryFields: Bool?
    public var imageUrl: String?
    public var canAddOtherOptions: Bool?
    public var questionChangeState: Int?
    public var isAnswerEditable: Bool?

    // MARK: - Initializer

    /// Default initializer; properties can be set after creation as needed.
    public init() {}
}
