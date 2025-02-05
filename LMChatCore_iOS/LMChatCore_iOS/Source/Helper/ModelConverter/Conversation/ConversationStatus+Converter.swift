//
//  ConversationStatus+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//
import LikeMindsChatData
import LikeMindsChatUI

extension ConversationStatus {
    /**
     Converts a `ConversationStatus` into a `ConversationStatusViewData`.

     - Returns: A `ConversationStatusViewData` representing this status.
     */
    public func toViewData() -> ConversationStatusViewData {
        switch self {
        case .sending: return .sending
        case .sent: return .sent
        case .failed: return .failed
        default: return .sent
        }
    }
}

extension ConversationStatusViewData {
    /**
     Converts a `ConversationStatusViewData` into a `ConversationStatus`.

     - Returns: A `ConversationStatus` matching this view data.
     */
    public func toConversationStatus() -> ConversationStatus {
        switch self {
        case .sending: return .sending
        case .sent: return .sent
        case .failed: return .failed
        default: return .sent
        }
    }
}
