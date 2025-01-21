//
//  SDKClientInfoViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/**
 A view-model (or “view data”) class that mirrors `SDKClientInfo` for use in UI layers or
 other contexts where a class-based, mutable structure is preferred.
 */
public class SDKClientInfoViewData {
    
    // MARK: - Properties
    
    /// An optional integer representing the community ID.
    public var community: Int?
    
    /// An optional integer representing the user’s ID within the community.
    public var user: Int?
    
    /// An optional string representing the user’s unique ID (distinct from user ID).
    public var userUniqueID: String?
    
    /// An optional string representing a unique identifier (UUID) for the user.
    public var uuid: String?
    
    // MARK: - Initializer
    
    /// Default initializer. Properties can be set after initialization as needed.
    public init() {}
}
