//
//  LMChatSearchConversationListViewModel.swift
//  Pods
//
//  Created by Anurag Tyagi on 01/02/25.
//

import LikeMindsChatData
import LikeMindsChatUI

/// A protocol defining the interface for updating the conversation search list UI.
///
/// Implementers of this protocol are typically view controllers that display the search results.
public protocol LMChatSearchConversationListViewProtocol: AnyObject {
    /**
     Updates the search list displayed in the view.

     - Parameter data: An array of `LMChatSearchConversationListViewController.ContentModel` representing
       the sections of search results.
     */
    func updateSearchList(
        with data: [LMChatSearchConversationListViewController.ContentModel])

    /**
     Shows or hides a footer loader in the view.

     - Parameter isShow: A Boolean value indicating whether to show (`true`) or hide (`false`) the footer loader.
     */
    func showHideFooterLoader(isShow: Bool)
}

/// A view model responsible for managing and fetching the conversation search data.
///
/// This class handles the logic of performing a search, managing pagination,
/// and converting raw data into a format that the view can display.
final public class LMChatSearchConversationListViewModel: LMChatBaseViewModel {

    // MARK: - Module Creation

    /**
     Creates and configures a `LMChatSearchConversationListViewController` module for displaying conversation search results.

     - Parameter chatroomId: The identifier of the chatroom for which to search conversations.
     - Throws: `LMChatError.chatNotInitialized` if the LMChatCore is not properly initialized.
     - Returns: A fully configured instance of `LMChatSearchConversationListViewController`.
     */
    public static func createModule(chatroomId: String) throws
        -> LMChatSearchConversationListViewController
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

    // MARK: - Properties

    /// The delegate that conforms to `LMChatSearchConversationListViewProtocol` to receive UI updates.
    var delegate: LMChatSearchConversationListViewProtocol?

    /// The collection of conversation data models fetched from the server.
    var conversationData: [LMChatSearchConversationDataModel]

    /// The current search string used for filtering conversations.
    private var searchString: String

    /// The optional chatroom identifier used to filter search results.
    private var chatroomId: String?

    /// The current page number used for pagination.
    private var currentPage: Int

    /// The number of items to fetch per page.
    private let pageSize: Int

    /// A flag indicating whether an API call is currently in progress.
    private var isAPICallInProgress: Bool

    /// A flag indicating whether further API calls are allowed (used for pagination).
    private var shouldAllowAPICall: Bool

    /// A Boolean flag indicating whether the search should include only conversations.
    public var searchOnlyConversations: Bool = false

    // MARK: - Initialization

    /**
     Initializes a new instance of `LMChatSearchConversationListViewModel`.

     - Parameter delegate: An optional delegate conforming to `LMChatSearchConversationListViewProtocol` that will receive UI updates.
     */
    init(delegate: LMChatSearchConversationListViewProtocol? = nil) {
        self.delegate = delegate
        self.conversationData = []
        self.searchString = ""
        self.currentPage = 1
        self.pageSize = 10
        self.isAPICallInProgress = false
        self.shouldAllowAPICall = true
    }

    // MARK: - Search Functionality

    /**
     Initiates a new search with the provided search string.

     This method trims the input string and resets any existing conversation data. If the search string is empty,
     it hides the footer loader. Otherwise, it resets pagination and initiates a data fetch.

     - Parameter searchString: The text input used to perform the search.
     */
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

    /**
     Fetches search data for the given search string.

     This private method checks if an API call is already in progress or if further API calls are allowed.
     If conditions are met, it marks that an API call is in progress and proceeds to search for conversations.

     - Parameter searchString: The search string used to filter conversation data.
     */
    private func fetchData(searchString: String) {
        guard !isAPICallInProgress, shouldAllowAPICall else {
            delegate?.showHideFooterLoader(isShow: false)
            return
        }

        isAPICallInProgress = true
        searchConversationList(searchString: searchString)
    }

    /**
     Fetches additional search results (for pagination).

     This method reuses the current search string and attempts to fetch the next page of results.
     */
    public func fetchMoreData() {
        fetchData(searchString: searchString)
    }

    /**
     Performs the API call to search for conversations using the provided search string.

     This method builds a `SearchConversationRequest` and makes an API call using `LMChatClient`.
     Upon receiving the response, it updates the conversation data, manages pagination, and converts
     the raw data into content models for display.

     - Parameter searchString: The search text used to query conversations.
     */
    private func searchConversationList(searchString: String) {
        let request = SearchConversationRequest.builder()
            .search(searchString)
            .chatroomId(chatroomId)
            .page(currentPage)
            .pageSize(pageSize)
            .build()

        LMChatClient.shared.searchConversation(request: request) {
            [weak self] response in
            guard let self = self else { return }
            self.isAPICallInProgress = false
            self.delegate?.showHideFooterLoader(isShow: false)

            // Check if conversations exist in the response; if not, update the UI with the current content.
            guard let conversations = response.data?.conversations else {
                self.convertToContentModel()
                return
            }

            self.currentPage += 1

            // Convert raw conversation data into our internal data model.
            let currentConversationData: [LMChatSearchConversationDataModel] =
                conversations.compactMap { conversation in
                    guard
                        let chatroomData = self.convertToChatroomData(
                            from: conversation.chatroom,
                            member: conversation.member)
                    else { return nil }

                    // Force unwrap for user details since we expect valid data when chatroom data is available.
                    return LMChatSearchConversationDataModel(
                        id: "\(conversation.id)",
                        chatroomDetails: chatroomData,
                        message: conversation.answer,
                        createdAt: conversation.createdAt,
                        updatedAt: conversation.lastUpdated,
                        user: self.generateUserDetails(
                            from: conversation.member)!
                    )
                }

            self.conversationData.append(contentsOf: currentConversationData)

            // If fewer items than pageSize were fetched, disallow further API calls.
            if self.conversationData.count < self.pageSize {
                self.shouldAllowAPICall = false
            }

            self.convertToContentModel()
        }
    }

    // MARK: - Data Conversion and Utilities

    /**
     Generates user details in the form of `LMChatSearchListUserDataModel` from a `Member` object.

     - Parameter data: The `Member` object containing user information.
     - Returns: An instance of `LMChatSearchListUserDataModel` if the necessary information is available; otherwise, `nil`.
     */
    private func generateUserDetails(from data: Member?)
        -> LMChatSearchListUserDataModel?
    {
        guard let data = data, let uuid = data.sdkClientInfo?.uuid else {
            return nil
        }

        return LMChatSearchListUserDataModel(
            uuid: uuid,
            username: data.name ?? "User",
            imageURL: data.imageUrl,
            isGuest: data.isGuest
        )
    }

    /**
     Generates a dictionary of basic analytics parameters for event tracking.

     - Parameter chatroomId: The identifier of the chatroom related to the event.
     - Returns: A dictionary containing basic parameters such as chatroom ID, community ID, and community name.
     */
    func trackEventBasicParams(chatroomId: String) -> [String: AnyHashable] {
        return [
            LMChatAnalyticsKeys.chatroomId.rawValue: chatroomId,
            LMChatAnalyticsKeys.communityId.rawValue: getCommunityId(),
            LMChatAnalyticsKeys.communityName.rawValue: getCommunityName(),
        ]
    }
}

// MARK: - Data Conversion Extension

extension LMChatSearchConversationListViewModel {
    /**
     Converts the internal conversation data into content models suitable for display in the search results UI.

     The method groups the conversation messages into sections. If `searchOnlyConversations` is false,
     the section title is set to "Messages".
     */
    func convertToContentModel() {
        var dataModel:
            [LMChatSearchConversationListViewController.ContentModel] = []

        if !conversationData.isEmpty {
            let conversationDataCell = convertMessageCell(
                from: conversationData)
            var sectionData: [LMChatSearchCellDataProtocol] = []
            sectionData.append(contentsOf: conversationDataCell)

            dataModel.append(
                LMChatSearchConversationListViewController.ContentModel(
                    title: searchOnlyConversations ? nil : "Messages",
                    data: sectionData
                )
            )
        }

        delegate?.updateSearchList(with: dataModel)
    }

    /**
     Converts an array of `LMChatSearchConversationDataModel` into an array of cell content models.

     These cell models are used to configure the UI elements in the search results table view.

     - Parameter data: An array of `LMChatSearchConversationDataModel` representing the raw conversation data.
     - Returns: An array of `LMChatSearchConversationMessageCell.ContentModel` for configuring conversation cells.
     */
    private func convertMessageCell(
        from data: [LMChatSearchConversationDataModel]
    ) -> [LMChatSearchConversationMessageCell.ContentModel] {
        return data.map {
            LMChatSearchConversationMessageCell.ContentModel(
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

    /**
     Converts raw chatroom data and associated member information into a `LMChatSearchChatroomDataModel`.

     - Parameters:
        - chatroom: The raw chatroom data, potentially containing various metadata.
        - member: The member data associated with the chatroom.
     - Returns: An instance of `LMChatSearchChatroomDataModel` if all required information is present; otherwise, `nil`.
     */
    private func convertToChatroomData(
        from chatroom: _Chatroom_?, member: Member?
    ) -> LMChatSearchChatroomDataModel? {
        guard let chatroom = chatroom,
            let id = chatroom.id,
            let user = generateUserDetails(from: member)
        else { return nil }

        return LMChatSearchChatroomDataModel(
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
