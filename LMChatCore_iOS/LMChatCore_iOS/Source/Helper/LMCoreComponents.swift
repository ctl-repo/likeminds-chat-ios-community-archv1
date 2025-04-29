//
//  LMCoreComponents.swift
//  LikeMindsChatUI
//
//  Created by Pushpendra Singh on 07/03/24.
//

import Foundation
import UIKit

let LMChatCoreBundle = Bundle(for: LMChatMessageListViewController.self)

public struct LMCoreComponents {
    public static var shared = Self()
    
    // MARK: HomeFeed Screen
    public var communityChatScreen: LMCommunityChatViewController.Type = LMCommunityChatViewController.self
    public var communityHybridChatScreen: LMCommunityHybridChatViewController.Type = LMCommunityHybridChatViewController.self
    
    public var exploreChatroomListScreen: LMExploreChatroomListView.Type = LMExploreChatroomListView.self
    public var exploreChatroomScreen: LMExploreChatroomViewController.Type = LMExploreChatroomViewController.self
    
    // MARK: Report Screen
    public var reportScreen: LMChatReportViewController.Type = LMChatReportViewController.self
    
    // MARK: Participant list Screen
    public var participantListScreen: LMChatParticipantListViewController.Type = LMChatParticipantListViewController.self
    
    // MARK: Attachment message screen
    public var attachmentMessageScreen: LMChatAttachmentViewController.Type = LMChatAttachmentViewController.self
    
    // MARK: Message List Screen
    public var messageListScreen: LMChatMessageListViewController.Type = LMChatMessageListViewController.self
    
    // MARK: Reaction List Screen
    public var reactionListScreen: LMChatReactionViewController.Type = LMChatReactionViewController.self
    
    // MARK: Search List Screen
    public var searchListScreen: LMChatSearchListViewController.Type = LMChatSearchListViewController.self
    public var searchConversationListScreen: LMChatSearchConversationListViewController.Type = LMChatSearchConversationListViewController.self
    
    //MARK: DM Screen
    public var networkingChatScreen: LMNetworkingChatViewController.Type = LMNetworkingChatViewController.self
    public var dmMemberListScreen: LMChatMemberListViewController.Type = LMChatMemberListViewController.self
    
    //MARK: Poll
    // MARK: Create Poll
    public var createPollScreen: LMChatCreatePollViewController.Type = LMChatCreatePollViewController.self
    
    // MARK: Poll Result
    public var pollResultScreen: LMChatPollResultScreen.Type = LMChatPollResultScreen.self
    public var pollResultList: LMChatPollResultListScreen.Type = LMChatPollResultListScreen.self
    
    //MARK : AI CHAT BOT

    public var aiChatBotIntiationScreen : LMChatAIBotInitiaitionViewController.Type = LMChatAIBotInitiaitionViewController.self
}
