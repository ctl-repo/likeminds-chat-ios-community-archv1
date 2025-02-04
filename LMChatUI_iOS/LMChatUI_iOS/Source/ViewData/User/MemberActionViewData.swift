//
//  MemberActionViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/// A view-data class that mirrors the properties of `MemberAction`.
///
/// Use this class in UI layers or other contexts where a mutable,
/// class-based model is preferred over the immutable `MemberAction` struct.
public class MemberActionViewData {

    // MARK: - Properties

    /// The title of the action.
    public var title: String?

    /// The route associated with the action.
    public var route: String?

    // MARK: - Initializer

    /// Default initializer; properties can be set as needed after creation.
    public init() {}
}
