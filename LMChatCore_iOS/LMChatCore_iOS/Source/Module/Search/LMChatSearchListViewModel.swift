//
//  LMChatSearchListViewModel.swift
//  LikeMindsChatCore
//
//  Created by Devansh Mohata on 16/04/24.
//

import Foundation
import LikeMindsChatData
import LikeMindsChatUI

/// A protocol that defines the methods to update the chat search list UI.
///
/// Implementers (typically view controllers) should use these methods to refresh the displayed search results and
/// to control the visibility of the footer loader during pagination.
public protocol LMChatSearchListViewProtocol: AnyObject {
    /**
     Updates the search list displayed on the screen.

     - Parameter data: An array of `LMChatSearchListViewController.ContentModel` instances that represent
       the sections and corresponding cells to be displayed.
     */
    func updateSearchList(
        with data: [LMChatSearchListViewController.ContentModel])

    /**
     Shows or hides the footer loader in the UI.

     - Parameter isShow: A Boolean indicating whether the loader should be shown (`true`) or hidden (`false`).
     */
    func showHideFooterLoader(isShow: Bool)
}

/// A view model responsible for managing and fetching data for the chat search list screen.
///
/// This class supports searching both chatrooms and conversations based on different API statuses,
/// handles pagination, and converts raw API responses into content models that the UI can display.
final public class LMChatSearchListViewModel: LMChatBaseViewModel {

    // MARK: - API Status Enum

    /**
     An enumeration of API statuses used to determine which API call to make during a search.

     The enum defines different statuses for fetching chatroom data (with header or title based search)
     and conversation data, with flags to indicate whether the data represents followed or not followed entities.
     */
    public enum APIStatus {
        case headerChatroomFollowTrue
        case headerChatroomFollowFalse
        case titleChatroomFollowTrue
        case conversationFollowTrue
        case titleChatroomFollowFalse
        case conversationFollowFalse

        /// A computed property indicating the follow status associated with the API status.
        var followStatus: Bool {
            switch self {
            case .headerChatroomFollowTrue,
                .titleChatroomFollowTrue,
                .conversationFollowTrue:
                return true
            case .headerChatroomFollowFalse,
                .titleChatroomFollowFalse,
                .conversationFollowFalse:
                return false
            }
        }

        /// A computed property indicating the search type used for chatroom searches.
        var searchType: String {
            switch self {
            case .headerChatroomFollowTrue,
                .headerChatroomFollowFalse:
                return "header"
            case .titleChatroomFollowTrue,
                .titleChatroomFollowFalse:
                return "title"
            case .conversationFollowTrue,
                .conversationFollowFalse:
                return ""
            }
        }
    }

    // MARK: - Module Creation

    /**
     Creates and configures a `LMChatSearchListViewController` module for displaying chat search results.

     This method ensures that LMChatCore is initialized and then configures both the view model and the view controller.

     - Throws: `LMChatError.chatNotInitialized` if the chat module has not been properly initialized.
     - Returns: A fully configured instance of `LMChatSearchListViewController`.
     */
    public static func createModule() throws -> LMChatSearchListViewController {
        guard LMChatCore.isInitialized else {
            throw LMChatError.chatNotInitialized
        }

        let viewcontroller = LMCoreComponents.shared.searchListScreen.init()
        let viewmodel = LMChatSearchListViewModel(delegate: viewcontroller)
        viewcontroller.viewmodel = viewmodel

        return viewcontroller
    }

    // MARK: - Properties

    /// The delegate that will receive UI updates for the search list.
    var delegate: LMChatSearchListViewProtocol?

    /// Data for chatrooms with header search results.
    var headerChatroomData: [LMChatSearchChatroomDataModel]
    /// Data for chatrooms with title search results where the chatroom is followed.
    var titleFollowedChatroomData: [LMChatSearchChatroomDataModel]
    /// Data for chatrooms with title search results where the chatroom is not followed.
    var titleNotFollowedChatroomData: [LMChatSearchChatroomDataModel]
    /// Data for conversation search results where the conversation is followed.
    var followedConversationData: [LMChatSearchConversationDataModel]
    /// Data for conversation search results where the conversation is not followed.
    var notFollowedConversationData: [LMChatSearchConversationDataModel]

    /// The current search string used to filter results.
    private var searchString: String
    /// The current API status, which determines which API call should be made.
    private var currentAPIStatus: APIStatus
    /// The current page number for pagination.
    private var currentPage: Int
    /// The number of items to fetch per API call.
    private let pageSize: Int
    /// A flag indicating whether an API call is currently in progress.
    private var isAPICallInProgress: Bool
    /// A flag indicating whether further API calls are allowed (used to stop pagination when no more data is available).
    private var shouldAllowAPICall: Bool

    // MARK: - Initialization

    /**
     Initializes a new instance of `LMChatSearchListViewModel`.

     - Parameter delegate: An optional delegate conforming to `LMChatSearchListViewProtocol` to receive UI updates.
     */
    init(delegate: LMChatSearchListViewProtocol? = nil) {
        self.delegate = delegate

        headerChatroomData = []
        titleFollowedChatroomData = []
        titleNotFollowedChatroomData = []
        followedConversationData = []
        notFollowedConversationData = []

        searchString = ""
        currentAPIStatus = .headerChatroomFollowTrue
        currentPage = 1
        pageSize = 10

        isAPICallInProgress = false
        shouldAllowAPICall = true
    }

    // MARK: - Search Functionality

    /**
     Initiates a new search with the provided search string.

     This method trims the search string, clears any previously stored data, resets the API status and page number,
     and then starts fetching data. If the search string is empty, it immediately hides the footer loader.

     - Parameter searchString: The text used to perform the search.
     */
    func searchList(with searchString: String) {
        self.searchString = searchString.trimmingCharacters(
            in: .whitespacesAndNewlines)

        // Clear all previously stored search data.
        headerChatroomData.removeAll(keepingCapacity: true)
        titleFollowedChatroomData.removeAll(keepingCapacity: true)
        titleNotFollowedChatroomData.removeAll(keepingCapacity: true)
        followedConversationData.removeAll(keepingCapacity: true)
        notFollowedConversationData.removeAll(keepingCapacity: true)

        guard !self.searchString.isEmpty else {
            delegate?.showHideFooterLoader(isShow: false)
            return
        }

        shouldAllowAPICall = true
        isAPICallInProgress = false
        currentAPIStatus = .headerChatroomFollowTrue
        currentPage = 1
        fetchData(searchString: searchString)
    }

    /**
     Fetches more data for pagination using the current search string.

     This method is typically triggered when the user scrolls to the bottom of the list.
     */
    func fetchMoreData() {
        fetchData(searchString: searchString)
    }

    /**
     Updates the API status to progress through the different search phases.

     This method is called when the current API call returns fewer items than expected (i.e. no more data).
     It cycles through the API statuses to determine the next set of data to fetch. When all statuses have been exhausted,
     it disables further API calls and converts the accumulated data into content models.
     */
    private func setNewAPIStatus() {
        // If the final API status (conversationFollowFalse) has been reached, stop further calls.
        if currentAPIStatus == .conversationFollowFalse {
            shouldAllowAPICall = false
            convertToContentModel()
            return
        }

        // Reset page number for the new API status.
        currentPage = 1

        // Cycle through the API statuses.
        if currentAPIStatus == .headerChatroomFollowTrue {
            currentAPIStatus = .headerChatroomFollowFalse
        } else if currentAPIStatus == .headerChatroomFollowFalse {
            currentAPIStatus = .titleChatroomFollowTrue
        } else if currentAPIStatus == .titleChatroomFollowTrue {
            currentAPIStatus = .conversationFollowTrue
        } else if currentAPIStatus == .conversationFollowTrue {
            currentAPIStatus = .titleChatroomFollowFalse
        } else if currentAPIStatus == .titleChatroomFollowFalse {
            currentAPIStatus = .conversationFollowFalse
        }

        fetchMoreData()
    }

    /**
     Fetches data from the server based on the current API status and search string.

     This method checks if an API call is already in progress or if further calls are allowed.
     Depending on the current API status, it delegates the fetch operation to either the chatroom or conversation search method.

     - Parameter searchString: The search string used for filtering the results.
     */
    private func fetchData(searchString: String) {
        guard !isAPICallInProgress, shouldAllowAPICall else {
            delegate?.showHideFooterLoader(isShow: false)
            return
        }

        isAPICallInProgress = true

        switch currentAPIStatus {
        case .headerChatroomFollowTrue,
            .headerChatroomFollowFalse,
            .titleChatroomFollowTrue,
            .titleChatroomFollowFalse:
            searchChatroomList(
                searchString: searchString,
                isFollowed: currentAPIStatus.followStatus,
                searchType: currentAPIStatus.searchType)
        case .conversationFollowTrue,
            .conversationFollowFalse:
            searchConversationList(
                searchString: searchString,
                followStatus: currentAPIStatus.followStatus)
        }
    }

    // MARK: - API Calls

    /**
     Searches for chatrooms based on the search string, follow status, and search type.

     This method constructs a `SearchChatroomRequest` and calls the chatroom search API.
     On a successful response, it converts the received data into chatroom data models and appends them
     to the corresponding data array based on the current API status.

     - Parameters:
        - searchString: The text to search for.
        - isFollowed: A Boolean indicating if only followed chatrooms should be returned.
        - searchType: A string representing the type of search (e.g., "header" or "title").
     */
    private func searchChatroomList(
        searchString: String, isFollowed: Bool, searchType: String
    ) {
        let request = SearchChatroomRequest.builder()
            .followStatus(isFollowed)
            .page(currentPage)
            .pageSize(pageSize)
            .search(searchString)
            .searchType(searchType)
            .build()

        LMChatClient.shared.searchChatroom(request: request) {
            [weak self] response in
            guard let self = self else { return }
            self.isAPICallInProgress = false
            self.delegate?.showHideFooterLoader(isShow: false)

            guard let chatrooms = response.data?.conversations else {
                self.convertToContentModel()
                return
            }

            self.currentPage += 1

            // Convert raw chatroom responses into data models.
            let chatroomData: [LMChatSearchChatroomDataModel] =
                chatrooms.compactMap { chatroom in
                    self.convertToChatroomData(
                        from: chatroom.chatroom, member: chatroom.member)
                }

            // Append the data based on the current API status.
            switch self.currentAPIStatus {
            case .headerChatroomFollowTrue, .headerChatroomFollowFalse:
                self.headerChatroomData.append(contentsOf: chatroomData)
            case .titleChatroomFollowTrue:
                self.titleFollowedChatroomData.append(contentsOf: chatroomData)
            case .titleChatroomFollowFalse:
                self.titleNotFollowedChatroomData.append(
                    contentsOf: chatroomData)
            default:
                break
            }

            // If fewer items were returned than requested, update the API status.
            if chatrooms.count < self.pageSize {
                self.setNewAPIStatus()
            } else {
                self.convertToContentModel()
            }
        }
    }

    /**
     Converts raw chatroom data and associated member information into a `LMChatSearchChatroomDataModel`.

     - Parameters:
        - chatroom: The raw chatroom data from the API.
        - member: The member information associated with the chatroom.
     - Returns: An instance of `LMChatSearchChatroomDataModel` if conversion is successful; otherwise, `nil`.
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

    /**
     Searches for conversations based on the search string and follow status.

     This method constructs a `SearchConversationRequest` and calls the conversation search API.
     On receiving a response, it converts the conversation data into data models and appends them
     to either the followed or not followed conversation data array based on the current API status.

     - Parameters:
        - searchString: The text to search for.
        - followStatus: A Boolean indicating if only followed conversations should be returned.
     */
    private func searchConversationList(
        searchString: String, followStatus: Bool
    ) {
        let request = SearchConversationRequest.builder()
            .search(searchString)
            .page(currentPage)
            .pageSize(pageSize)
            .followStatus(followStatus)
            .build()

        LMChatClient.shared.searchConversation(request: request) {
            [weak self] response in
            guard let self = self else { return }
            self.isAPICallInProgress = false
            self.delegate?.showHideFooterLoader(isShow: false)

            guard let conversations = response.data?.conversations else {
                self.convertToContentModel()
                return
            }

            self.currentPage += 1

            // Convert raw conversation responses into data models.
            let conversationData: [LMChatSearchConversationDataModel] =
                conversations.compactMap { conversation in
                    guard
                        let chatroomData = self.convertToChatroomData(
                            from: conversation.chatroom,
                            member: conversation.member)
                    else { return nil }
                    return LMChatSearchConversationDataModel(
                        id: "\(conversation.id)",
                        chatroomDetails: chatroomData,
                        message: conversation.answer,
                        createdAt: conversation.createdAt,
                        updatedAt: conversation.lastUpdated,
                        user: nil
                    )
                }

            // Append the conversation data based on the current API status.
            switch self.currentAPIStatus {
            case .conversationFollowTrue:
                self.followedConversationData.append(
                    contentsOf: conversationData)
            case .conversationFollowFalse:
                self.notFollowedConversationData.append(
                    contentsOf: conversationData)
            default:
                break
            }

            // If fewer items were returned than requested, update the API status.
            if conversations.count < self.pageSize {
                self.setNewAPIStatus()
            } else {
                self.convertToContentModel()
            }
        }
    }

    // MARK: - Helper Methods

    /**
     Generates user details from a `Member` object.

     - Parameter data: A `Member` object containing user information.
     - Returns: An instance of `LMChatSearchListUserDataModel` if the required data is available; otherwise, `nil`.
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
     Generates basic parameters for analytics event tracking.

     - Parameter chatroomId: The identifier of the chatroom associated with the event.
     - Returns: A dictionary containing analytics parameters such as chatroom ID, community ID, and community name.
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

extension LMChatSearchListViewModel {
    /**
     Converts the raw data accumulated by the view model into content models suitable for display.

     This method creates an array of `LMChatSearchListViewController.ContentModel` by converting chatroom and conversation data.
     The first section contains header chatrooms, while the second section contains messages from title and conversation data.
     It then notifies the delegate with the updated content models.
     */
    func convertToContentModel() {
        var dataModel: [LMChatSearchListViewController.ContentModel] = []

        // Convert header chatroom data (if available) into cell models.
        if !headerChatroomData.isEmpty {
            let followedChatroomConverted = convertChatroomCell(
                from: headerChatroomData)
            dataModel.append(.init(title: nil, data: followedChatroomConverted))
        }

        // Convert title and conversation data into cell models if any are available.
        if !titleFollowedChatroomData.isEmpty
            || !titleNotFollowedChatroomData.isEmpty
            || !followedConversationData.isEmpty
            || !notFollowedConversationData.isEmpty
        {

            let titleFollowedData = convertTitleMessageCell(
                from: titleFollowedChatroomData, isJoined: true)
            let followedConversationData = convertMessageCell(
                from: followedConversationData, isJoined: true)
            let titleNotFollowedData = convertTitleMessageCell(
                from: titleNotFollowedChatroomData, isJoined: false)
            let notFollowedConversationData = convertMessageCell(
                from: notFollowedConversationData, isJoined: false)

            var sectionData: [LMChatSearchCellDataProtocol] = []
            sectionData.append(contentsOf: titleFollowedData)
            sectionData.append(contentsOf: followedConversationData)
            sectionData.append(contentsOf: titleNotFollowedData)
            sectionData.append(contentsOf: notFollowedConversationData)

            dataModel.append(.init(title: "Messages", data: sectionData))
        }

        delegate?.updateSearchList(with: dataModel)
    }

    /**
     Converts an array of `LMChatSearchChatroomDataModel` objects into an array of chatroom cell content models.

     - Parameter data: An array of chatroom data models.
     - Returns: An array of `LMChatSearchChatroomCell.ContentModel` instances for display.
     */
    private func convertChatroomCell(from data: [LMChatSearchChatroomDataModel])
        -> [LMChatSearchChatroomCell.ContentModel]
    {
        return data.map {
            LMChatSearchChatroomCell.ContentModel(
                chatroomID: $0.id,
                image: $0.chatroomImage,
                chatroomName: $0.chatroomTitle
            )
        }
    }

    /**
     Converts an array of `LMChatSearchChatroomDataModel` objects into an array of title message cell content models.

     These cells are used to display chatroom information with a title (message) and indicate whether the user is joined.

     - Parameters:
        - data: An array of chatroom data models.
        - isJoined: A Boolean indicating whether the chatroom is joined.
     - Returns: An array of `LMChatSearchMessageCell.ContentModel` instances.
     */
    private func convertTitleMessageCell(
        from data: [LMChatSearchChatroomDataModel], isJoined: Bool
    ) -> [LMChatSearchMessageCell.ContentModel] {
        return data.map {
            LMChatSearchMessageCell.ContentModel(
                chatroomID: $0.id,
                messageID: nil,
                chatroomName: $0.chatroomTitle,
                message: $0.title ?? "",
                senderName: $0.user.firstName,
                date: $0.createdAt,
                isJoined: isJoined,
                highlightedText: searchString
            )
        }
    }

    /**
     Converts an array of `LMChatSearchConversationDataModel` objects into an array of message cell content models.

     These cells are used to display conversation messages and related chatroom information.

     - Parameters:
        - data: An array of conversation data models.
        - isJoined: A Boolean indicating whether the chatroom is joined.
     - Returns: An array of `LMChatSearchMessageCell.ContentModel` instances.
     */
    private func convertMessageCell(
        from data: [LMChatSearchConversationDataModel], isJoined: Bool
    ) -> [LMChatSearchMessageCell.ContentModel] {
        return data.map {
            LMChatSearchMessageCell.ContentModel(
                chatroomID: $0.chatroomDetails.id,
                messageID: $0.id,
                chatroomName: $0.chatroomDetails.chatroomTitle,
                message: $0.message,
                senderName: $0.chatroomDetails.user.firstName,
                date: $0.updatedAt,
                isJoined: isJoined,
                highlightedText: searchString
            )
        }
    }
}
