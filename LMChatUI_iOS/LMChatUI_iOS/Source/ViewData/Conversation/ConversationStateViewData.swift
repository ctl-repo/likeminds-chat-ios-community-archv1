//
//  ConversationStateViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/**
 A view-data enum that mirrors `ConversationState` and provides human-readable descriptions.

 This enum can be used in UI layers to represent conversation states with descriptions.
 */
public enum ConversationStateViewData: Int, CaseIterable {
    case unknown = -1
    case normal = 0
    case chatRoomHeader = 1
    case chatRoomFollowed = 2
    case chatRoomUnFollowed = 3
    case chatRoomCreater = 4
    case chatRoomEdited = 5
    case chatRoomJoined = 6
    case chatRoomAddParticipants = 7
    case chatRoomLeaveSeperator = 8
    case chatRoomRemoveSeperator = 9
    case microPoll = 10
    case addAllMembers = 11
    case chatRoomCurrentTopic = 12
    case directMessageMemberRemovedOrLeft = 13
    case directMessageCMRemoved = 14
    case directMessageMemberBecomesCMDisableChat = 15
    case directMessageCMBecomesMemberEnableChat = 16
    case directMessageMemberBecomesCMEnableChat = 17
    case directMessageMemberRequestRejected = 19
    case directMessageMemberRequestApproved = 20
    case chatroomDataHeader = 111
    case bubbleShimmer = -99

    // MARK: - Description
    /**
     Provides a human-readable description for each conversation state.
     */
    public var description: String {
        switch self {
        case .unknown: return "Unknown State"
        case .normal: return "Normal Conversation"
        case .chatRoomHeader: return "Chat Room Header"
        case .chatRoomFollowed: return "Followed Chat Room"
        case .chatRoomUnFollowed: return "Unfollowed Chat Room"
        case .chatRoomCreater: return "Chat Room Creator"
        case .chatRoomEdited: return "Chat Room Edited"
        case .chatRoomJoined: return "Chat Room Joined"
        case .chatRoomAddParticipants: return "Added Participants"
        case .chatRoomLeaveSeperator: return "Left Chat Room"
        case .chatRoomRemoveSeperator: return "Removed from Chat Room"
        case .microPoll: return "Micro Poll Conversation"
        case .addAllMembers: return "Added All Members"
        case .chatRoomCurrentTopic: return "Current Chat Room Topic"
        case .directMessageMemberRemovedOrLeft: return "Member Removed or Left"
        case .directMessageCMRemoved: return "Community Manager Removed"
        case .directMessageMemberBecomesCMDisableChat: return "Member Became CM - Chat Disabled"
        case .directMessageCMBecomesMemberEnableChat: return "CM Became Member - Chat Enabled"
        case .directMessageMemberBecomesCMEnableChat: return "Member Became CM - Chat Enabled"
        case .directMessageMemberRequestRejected: return "Member Request Rejected"
        case .directMessageMemberRequestApproved: return "Member Request Approved"
        case .chatroomDataHeader: return "Chat Room Data Header"
        case .bubbleShimmer: return "Bubble Shimmer"
        }
    }
}
