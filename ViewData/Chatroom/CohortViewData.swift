//
//  CohortViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/// A view-data class that mirrors the properties of `Cohort`.
///
/// Use this class in UI layers or other contexts where a mutable class is preferred,
/// rather than the immutable `Cohort` struct from your domain or networking layer.
public class CohortViewData {

    // MARK: - Properties

    /// A unique identifier for the cohort.
    public var id: Int?

    /// The total number of members in the cohort.
    public var totalMembers: Int?

    /// The name of the cohort.
    public var name: String?

    /// The list of `Member` objects belonging to this cohort.
    public var members: [MemberViewData]?

    // MARK: - Initializer

    /**
     Default initializer. Properties can be set after initialization as needed.
     */
    public init() {}
}
