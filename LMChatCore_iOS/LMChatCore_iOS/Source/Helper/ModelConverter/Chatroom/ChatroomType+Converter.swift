//
//  ChatroomType+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//
import LikeMindsChatUI
import LikeMindsChatData

extension ChatRequestState {
    /**
     Converts this core `ChatRequestState` to a `ChatRequestStateViewData` value.

     - Returns: A matching `ChatRequestStateViewData`, or `.unknown` if the raw value
                doesn't map to a known case.
     */
    public func toViewData() -> ChatRequestStateViewData {
        // Attempt a direct match on the rawValue
        return ChatRequestStateViewData(rawValue: self.rawValue) ?? .unknown
    }
}

extension ChatRequestStateViewData {
    /**
     Converts this view data enum back to a core `ChatRequestState` value.

     - Returns: A matching `ChatRequestState` if possible; otherwise `.unknown`.
     */
    public func toChatRequestState() -> ChatRequestState {
        return ChatRequestState(rawValue: self.rawValue) ?? .unknown
    }
}

extension ChatroomType {
    /**
     Converts this core `ChatroomType` to a `ChatroomTypeViewData` value.

     - Returns: A matching `ChatroomTypeViewData`, or `.unknown` if the raw value
                doesn't map to a known case.
     */
    public func toViewData() -> ChatroomTypeViewData {
        return ChatroomTypeViewData(rawValue: self.rawValue) ?? .unknown
    }
}

extension ChatroomTypeViewData {
    /**
     Converts this view data enum back to the core `ChatroomType` value.

     - Returns: The matching `ChatroomType` if possible; otherwise `.unknown`.
     */
    public func toChatroomType() -> ChatroomType {
        return ChatroomType(rawValue: self.rawValue) ?? .unknown
    }
}
