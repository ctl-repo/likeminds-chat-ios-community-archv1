//
//  Reaction+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

extension Reaction {
    /**
     Converts this `Reaction` instance into a `ReactionViewData`.

     - Returns: A new `ReactionViewData` with properties copied from this `Reaction`.
     */
    public func toViewData() -> ReactionViewData {
        // Simply copy over the properties
        return ReactionViewData(
            member: self.member,
            reaction: self.reaction
        )
    }
}

extension ReactionViewData {
    /**
     Converts this `ReactionViewData` instance back into a `Reaction`
     by leveraging the builder in `Reaction`.

     - Returns: A new `Reaction` created from this view data.
     */
    public func toReaction() -> Reaction {
        // Use the existing builder pattern from `Reaction`.
        return Reaction.builder()
            .member(member)
            .reaction(reaction)
            .build()
    }
}
