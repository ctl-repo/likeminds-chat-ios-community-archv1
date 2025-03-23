//
//  ConversationViewData+Reactions.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

extension ConversationViewData {
    /**
     Gets the reactions grid data for this conversation.
     
     - Returns: A `ReactionGridViewData` instance containing the most recent reactions and their counts,
                or nil if there are no reactions.
     */
    public func getReactionsGrid() -> ReactionGridViewData? {
        guard let reactions = reactions, !reactions.isEmpty else {
            return nil
        }
        
        // Group reactions by reaction string and count them
        let reactionsArray = Dictionary(grouping: reactions) { $0.reaction }
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .prefix(3)
            .map { $0 } // Convert sequence to array
        
        let size = reactionsArray.count
        var builder = ReactionGridViewData.Builder()
        
        if size >= 2 {
            let firstReaction = reactionsArray[0]
            let secondReaction = reactionsArray[1]
            
            builder = builder.mostRecentReaction(firstReaction.key)
            builder = builder.mostRecentReactionCount(firstReaction.value)
            builder = builder.secondMostRecentReaction(secondReaction.key)
            builder = builder.secondMostRecentReactionCount(secondReaction.value)
            builder = builder.moreThanTwoReactionsPresent(size > 2)
        } else if size == 1 {
            let firstReaction = reactionsArray[0]
            builder = builder.mostRecentReaction(firstReaction.key)
            builder = builder.mostRecentReactionCount(firstReaction.value)
            builder = builder.moreThanTwoReactionsPresent(false)
            builder = builder.secondMostRecentReaction(nil)
        }
        
        return builder.build()
    }
} 
