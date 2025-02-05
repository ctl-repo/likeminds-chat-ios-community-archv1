//
//  ChatroomTypeViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/// A "view data" enum that mirrors `ChatRequestState`.
/// This can be used in UI or intermediate layers to avoid directly exposing the core enum
/// (which might be tightly coupled to decoding, domain logic, etc.).
public enum ChatRequestStateViewData: Int {
    case unknown = -1
    case initiated = 0
    case approved = 1
    case rejected = 2

    /// Returns a string describing the request state (mimicking the core `stringValue`).
    public var stringValue: String {
        switch self {
        case .approved:
            return "Approved"
        case .initiated:
            return "Initiated"
        case .rejected:
            return "Rejected"
        case .unknown:
            return ""
        }
    }
}

/// A "view data" enum that mirrors `ChatroomType`.
/// This can be used in UI or intermediate layers to keep the core enum encapsulated.
public enum ChatroomTypeViewData: Int {
    case unknown = -1
    case normal = 0
    case introduction = 1
    case event = 2
    case poll = 3
    case unverified = 5
    case publicEvent = 6
    case purpose = 7
    case introductions = 9
    case directMessage = 10
    case chatRoomDateSectionHeader = 101
    case newUnseenChatRoomTitle = 11

    /**
     A string value that corresponds to each case, mirroring `ChatroomType.value`.
     */
    public var value: String {
        switch self {
        case .unknown:
            return "unknown"
        case .normal:
            return "normal"
        case .introduction:
            return "intro"
        case .event:
            return "event"
        case .poll:
            return "poll"
        case .unverified:
            return "unverified"
        case .publicEvent:
            return "publicEvent"
        case .purpose:
            return "purpose"
        case .introductions:
            return "introduction_rooms"
        case .directMessage:
            return "direct message"
        case .chatRoomDateSectionHeader:
            return "chatRoomDateSectionHeader"
        case .newUnseenChatRoomTitle:
            return "newUnseenChatRoomTitle"
        }
    }

    /**
     A special room value, mirroring the logic in `ChatroomType.specialRoomValue`.
     */
    public var specialRoomValue: String? {
        switch self {
        case .introduction:
            return "Intro room"
        case .purpose:
            return "Announcement room"
        case .event,
            .publicEvent:
            return "Event room"
        case .poll:
            return "Poll room"
        default:
            return nil
        }
    }
}
