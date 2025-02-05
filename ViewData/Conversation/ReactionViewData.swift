//
//  ReactionViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/**
 A view-data class that mirrors the properties of `Reaction`.
 
 This class can be used in UI layers or intermediate logic where a mutable class is more convenient
 than the immutable `Reaction` model. 
 */
public class ReactionViewData {
    
    // MARK: - Properties
    
    /// The member who performed the reaction.
    public var member: MemberViewData?
    
    /// The string value of the reaction (e.g., an emoji or reaction identifier).
    public var reaction: String
    
    // MARK: - Initializer
    
    /**
     Default initializer. 
     
     - Parameter member: The `Member` who reacted (optional).
     - Parameter reaction: The string representing the reaction.
     */
    public init(member: MemberViewData? = nil, reaction: String = "") {
        self.member = member
        self.reaction = reaction
    }
}
