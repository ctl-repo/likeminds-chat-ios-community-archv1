//
//  PollConverter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import LikeMindsChatData
import LikeMindsChatUI

extension Poll {
    /**
     Converts a `Poll` instance into a `PollViewData`.

     - Returns: A `PollViewData` populated with the data from this `Poll`.
     */
    public func toViewData() -> PollViewData {
        return PollViewData(
            id: self.id,
            text: self.text,
            isSelected: self.isSelected,
            percentage: self.percentage,
            subText: self.subText,
            noVotes: self.noVotes,
            member: self.member?.toViewData(),  // Assuming `User` has a `toViewData` method
            userId: self.userId,
            conversationId: self.conversationId
        )
    }
}
extension PollViewData {
    /**
     Converts a `PollViewData` instance back into a `Poll`.

     - Returns: A `Poll` created using the data from this `PollViewData`.
     */
    public func toPoll() -> Poll {
        return Poll.Builder()
            .id(self.id)
            .text(self.text)
            .isSelected(self.isSelected)
            .percentage(self.percentage)
            .subText(self.subText)
            .noVotes(self.noVotes)
            .member(self.member?.toUser())  // Assuming `UserViewData` has a `toUser` method
            .userId(self.userId)
            .conversationId(self.conversationId)
            .build()
    }
}
