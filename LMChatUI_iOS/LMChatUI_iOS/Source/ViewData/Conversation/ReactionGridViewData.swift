//
//  ReactionGridViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/**
 A view-data class that represents a grid of reactions.
 
 This class can be used in UI layers or intermediate logic where a mutable class is more convenient
 than the immutable model. It follows the builder pattern for flexible object creation.
 */
public class ReactionGridViewData {
    
    // MARK: - Properties
    
    /// The most recent reaction string
    public var mostRecentReaction: String?
    
    /// The second most recent reaction string
    public var secondMostRecentReaction: String?
    
    /// Count of the most recent reaction
    public var mostRecentReactionCount: Int?
    
    /// Count of the second most recent reaction
    public var secondMostRecentReactionCount: Int?
    
    /// Flag indicating if there are more than two reactions
    public var moreThanTwoReactionsPresent: Bool?
    
    // MARK: - Initializer
    
    /**
     Private initializer to enforce builder pattern usage.
     
     - Parameters:
        - mostRecentReaction: The most recent reaction string
        - secondMostRecentReaction: The second most recent reaction string
        - mostRecentReactionCount: Count of the most recent reaction
        - secondMostRecentReactionCount: Count of the second most recent reaction
        - moreThanTwoReactionsPresent: Flag indicating if there are more than two reactions
     */
    private init(
        mostRecentReaction: String? = nil,
        secondMostRecentReaction: String? = nil,
        mostRecentReactionCount: Int? = nil,
        secondMostRecentReactionCount: Int? = nil,
        moreThanTwoReactionsPresent: Bool? = nil
    ) {
        self.mostRecentReaction = mostRecentReaction
        self.secondMostRecentReaction = secondMostRecentReaction
        self.mostRecentReactionCount = mostRecentReactionCount
        self.secondMostRecentReactionCount = secondMostRecentReactionCount
        self.moreThanTwoReactionsPresent = moreThanTwoReactionsPresent
    }
    
    // MARK: - Builder
    
    /**
     Builder class for creating ReactionGridViewData instances
     */
    public class Builder {
        private var mostRecentReaction: String?
        private var secondMostRecentReaction: String?
        private var mostRecentReactionCount: Int?
        private var secondMostRecentReactionCount: Int?
        private var moreThanTwoReactionsPresent: Bool?
        
        public init() {}
        
        /**
         Sets the most recent reaction
         */
        public func mostRecentReaction(_ reaction: String?) -> Builder {
            self.mostRecentReaction = reaction
            return self
        }
        
        /**
         Sets the second most recent reaction
         */
        public func secondMostRecentReaction(_ reaction: String?) -> Builder {
            self.secondMostRecentReaction = reaction
            return self
        }
        
        /**
         Sets the count of most recent reaction
         */
        public func mostRecentReactionCount(_ count: Int?) -> Builder {
            self.mostRecentReactionCount = count
            return self
        }
        
        /**
         Sets the count of second most recent reaction
         */
        public func secondMostRecentReactionCount(_ count: Int?) -> Builder {
            self.secondMostRecentReactionCount = count
            return self
        }
        
        /**
         Sets the flag for more than two reactions
         */
        public func moreThanTwoReactionsPresent(_ present: Bool?) -> Builder {
            self.moreThanTwoReactionsPresent = present
            return self
        }
        
        /**
         Builds and returns a new ReactionGridViewData instance
         */
        public func build() -> ReactionGridViewData {
            return ReactionGridViewData(
                mostRecentReaction: mostRecentReaction,
                secondMostRecentReaction: secondMostRecentReaction,
                mostRecentReactionCount: mostRecentReactionCount,
                secondMostRecentReactionCount: secondMostRecentReactionCount,
                moreThanTwoReactionsPresent: moreThanTwoReactionsPresent
            )
        }
    }
    
    /**
     Creates a new builder with current values
     */
    public func toBuilder() -> Builder {
        return Builder()
            .mostRecentReaction(mostRecentReaction)
            .secondMostRecentReaction(secondMostRecentReaction)
            .mostRecentReactionCount(mostRecentReactionCount)
            .secondMostRecentReactionCount(secondMostRecentReactionCount)
            .moreThanTwoReactionsPresent(moreThanTwoReactionsPresent)
    }
} 