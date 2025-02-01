//
//  LMChatSearchConversationListViewModel.swift
//  Pods
//
//  Created by Anurag Tyagi on 01/02/25.
//
import LikeMindsChatData
import LikeMindsChatUI

public protocol LMChatSearchConversationListViewProtocol: AnyObject {
    func updateSearchList(
        with data: [LMChatSearchConversationListViewController.ContentModel])
    func showHideFooterLoader(isShow: Bool)
}

final public class LMChatSearchConversationListViewModel: LMChatBaseViewModel {
    public static func createModule(chatroomId: String)
        throws -> LMChatSearchConversationListViewController
    {
        guard LMChatCore.isInitialized else {
            throw LMChatError.chatNotInitialized
        }

        let viewcontroller = LMCoreComponents.shared
            .searchConversationListScreen.init()
        let viewmodel = LMChatSearchConversationListViewModel(
            delegate: viewcontroller)
        viewcontroller.viewmodel = viewmodel

        viewmodel.chatroomId = chatroomId

        return viewcontroller
    }

    var delegate: LMChatSearchConversationListViewProtocol?

    var conversationData: [LMChatSearchConversationDataModel]

    private var searchString: String
    private var chatroomId: String?
    private var currentPage: Int
    private let pageSize: Int
    private var isAPICallInProgress: Bool
    private var shouldAllowAPICall: Bool
    public var searchOnlyConversations: Bool = false

    init(delegate: LMChatSearchConversationListViewProtocol? = nil) {
        self.delegate = delegate

        conversationData = []

        searchString = ""
        currentPage = 1
        pageSize = 10

        isAPICallInProgress = false
        shouldAllowAPICall = true
    }

    func searchList(with searchString: String) {
        self.searchString = searchString.trimmingCharacters(
            in: .whitespacesAndNewlines)

        conversationData.removeAll(keepingCapacity: true)

        guard !self.searchString.isEmpty else {
            delegate?.showHideFooterLoader(isShow: false)
            return
        }

        shouldAllowAPICall = true
        isAPICallInProgress = false
        currentPage = 1
        fetchData(searchString: searchString)
    }

    private func fetchData(searchString: String) {
        guard !isAPICallInProgress,
            shouldAllowAPICall
        else {
            delegate?.showHideFooterLoader(isShow: false)
            return
        }

        isAPICallInProgress = true

        searchConversationList(
            searchString: searchString)
    }

    public func fetchMoreData() {
        fetchData(searchString: searchString)
    }

    private func searchConversationList(
        searchString: String
    ) {
        let request = SearchConversationRequest.builder()
            .search(searchString)
            .chatroomId(chatroomId)
            .page(currentPage)
            .pageSize(pageSize)
            .build()

        LMChatClient.shared.searchConversation(request: request) {
            [weak self] response in
            self?.isAPICallInProgress = false
            self?.delegate?.showHideFooterLoader(isShow: false)

            guard let self,
                let conversations = response.data?.conversations
            else {
                self?.convertToContentModel()
                return
            }

            currentPage += 1

            let currentConversationData: [LMChatSearchConversationDataModel] =
                conversations.compactMap { conversation in
                    guard
                        let chatroomData = self.convertToChatroomData(
                            from: conversation.chatroom,
                            member: conversation.member)
                    else { return .none }

                    return .init(
                        id: "\(conversation.id)",
                        chatroomDetails: chatroomData,
                        message: conversation.answer,
                        createdAt: conversation.createdAt,
                        updatedAt: conversation.lastUpdated,
                        user: self.generateUserDetails(
                            from: conversation.member)!
                    )
                }
            
            conversationData.append(contentsOf: currentConversationData)
            
            if conversationData.count < pageSize{
                shouldAllowAPICall = false
            }

            convertToContentModel()
        }
    }

    private func generateUserDetails(from data: Member?)
        -> LMChatSearchListUserDataModel?
    {
        guard let data,
            let uuid = data.sdkClientInfo?.uuid
        else { return .none }

        return .init(
            uuid: uuid, username: data.name ?? "User", imageURL: data.imageUrl,
            isGuest: data.isGuest)
    }

    func trackEventBasicParams(chatroomId: String) -> [String: AnyHashable] {
        [
            LMChatAnalyticsKeys.chatroomId.rawValue: chatroomId,
            LMChatAnalyticsKeys.communityId.rawValue: getCommunityId(),
            LMChatAnalyticsKeys.communityName.rawValue: getCommunityName(),
        ]
    }
}

// MARK: Convert To Content Model
extension LMChatSearchConversationListViewModel {
    func convertToContentModel() {
        var dataModel:
            [LMChatSearchConversationListViewController.ContentModel] = []

        if !conversationData.isEmpty {
            let conversationDataCell = convertMessageCell(
                from: conversationData)

            var sectionData: [LMChatSearchCellDataProtocol] = []

            sectionData.append(contentsOf: conversationDataCell)

            dataModel.append(
                .init(
                    title: searchOnlyConversations ? nil : "Messages",
                    data: sectionData))
        }

        delegate?.updateSearchList(with: dataModel)
    }

    private func convertMessageCell(
        from data: [LMChatSearchConversationDataModel]
    ) -> [LMChatSearchConversationMessageCell.ContentModel] {
        data.map {
            .init(
                chatroomID: $0.chatroomDetails.id,
                messageID: $0.id,
                chatroomName: $0.chatroomDetails.chatroomTitle,
                message: $0.message,
                senderName: $0.chatroomDetails.user.firstName,
                date: $0.updatedAt,
                isJoined: $0.chatroomDetails.isFollowed,
                highlightedText: searchString,
                userImageUrl: $0.user?.imageURL
            )
        }
    }

    private func convertToChatroomData(
        from chatroom: _Chatroom_?, member: Member?
    ) -> LMChatSearchChatroomDataModel? {
        guard let chatroom,
            let id = chatroom.id,
            let user = generateUserDetails(from: member)
        else { return .none }

        return .init(
            id: id,
            chatroomTitle: chatroom.header ?? "",
            chatroomImage: chatroom.chatroomImageUrl,
            isFollowed: chatroom.followStatus ?? false,
            title: chatroom.title,
            createdAt: Double(chatroom.createdAt ?? "") ?? 0,
            user: user
        )
    }
}
