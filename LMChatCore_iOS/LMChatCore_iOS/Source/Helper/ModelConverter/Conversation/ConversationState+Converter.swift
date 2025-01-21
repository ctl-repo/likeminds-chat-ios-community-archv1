//
//  ConversationState+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import LikeMindsChatData
import LikeMindsChatUI

extension ConversationState {
    /**
     Converts a `ConversationState` into a `ConversationStateViewData`.

     - Returns: A `ConversationStateViewData` representing this state.
     */
    public func toViewData() -> ConversationStateViewData {
        return ConversationStateViewData(rawValue: self.rawValue) ?? .unknown
    }
}

extension ConversationStateViewData {
    /**
     Converts a `ConversationStateViewData` into a `ConversationState`.

     - Returns: A `ConversationState` representing this view data.
     */
    public func toConversationState() -> ConversationState {
        return ConversationState(rawValue: self.rawValue) ?? .unknown
    }
}
