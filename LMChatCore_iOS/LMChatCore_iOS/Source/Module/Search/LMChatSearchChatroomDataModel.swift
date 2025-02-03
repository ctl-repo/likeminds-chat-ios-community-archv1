//
//  LMChatSearchChatroomDataModel.swift
//  LikeMindsChatCore
//
//  Created by Devansh Mohata on 02/05/24.
//

/// A data model representing the search result details of a chatroom.
///
/// This model encapsulates all the relevant data needed to display a chatroom's details in search results. It includes the chatroom's unique identifier, title, optional image, follow status, creation timestamp, and the associated user details.
///
/// - Properties:
///    - id: The unique identifier of the chatroom.
///    - chatroomTitle: The title of the chatroom.
///    - chatroomImage: An optional URL string pointing to the chatroom's image.
///    - isFollowed: A Boolean value indicating whether the chatroom is followed by the user.
///    - title: An optional secondary title for the chatroom.
///    - createdAt: A timestamp representing when the chatroom was created.
///    - user: The user associated with the chatroom, represented by `LMChatSearchListUserDataModel`.
public struct LMChatSearchChatroomDataModel {
    /// The unique identifier of the chatroom.
    let id: String
    /// The title of the chatroom.
    let chatroomTitle: String
    /// An optional URL string pointing to the chatroom's image.
    let chatroomImage: String?
    /// A Boolean indicating whether the chatroom is followed by the user.
    let isFollowed: Bool
    /// An optional secondary title for the chatroom.
    let title: String?
    /// The timestamp representing when the chatroom was created.
    let createdAt: Double
    /// The user associated with the chatroom.
    let user: LMChatSearchListUserDataModel

    /**
     Initializes a new instance of `LMChatSearchChatroomDataModel`.

     - Parameters:
        - id: The unique identifier for the chatroom.
        - chatroomTitle: The title of the chatroom.
        - chatroomImage: An optional URL string for the chatroom's image.
        - isFollowed: A Boolean indicating whether the chatroom is followed by the user.
        - title: An optional secondary title for the chatroom.
        - createdAt: A timestamp indicating when the chatroom was created.
        - user: An instance of `LMChatSearchListUserDataModel` representing the associated user.
     */
    public init(
        id: String,
        chatroomTitle: String,
        chatroomImage: String?,
        isFollowed: Bool,
        title: String?,
        createdAt: Double,
        user: LMChatSearchListUserDataModel
    ) {
        self.id = id
        self.chatroomTitle = chatroomTitle
        self.chatroomImage = chatroomImage
        self.isFollowed = isFollowed
        self.title = title
        self.createdAt = createdAt
        self.user = user
    }
}

/// A data model representing the search result details of a conversation.
///
/// This model encapsulates conversation-specific information returned in a search result. It includes the conversation's unique identifier, the associated chatroom details, the message content, timestamps for creation and updates, and optionally, details about the user who posted the conversation.
///
/// - Properties:
///    - id: The unique identifier of the conversation.
///    - chatroomDetails: The chatroom details associated with the conversation, represented by `LMChatSearchChatroomDataModel`.
///    - message: The content of the conversation message.
///    - createdAt: A timestamp representing when the conversation was created.
///    - updatedAt: A timestamp representing when the conversation was last updated.
///    - user: An optional `LMChatSearchListUserDataModel` representing the user who initiated the conversation.
public struct LMChatSearchConversationDataModel {
    /// The unique identifier of the conversation.
    public let id: String
    /// The associated chatroom details.
    public let chatroomDetails: LMChatSearchChatroomDataModel
    /// The content of the conversation message.
    public let message: String
    /// The timestamp when the conversation was created.
    public let createdAt: Double
    /// The timestamp when the conversation was last updated.
    public let updatedAt: Double
    /// An optional user associated with the conversation.
    public let user: LMChatSearchListUserDataModel?

    /**
     Initializes a new instance of `LMChatSearchConversationDataModel`.

     - Parameters:
        - id: The unique identifier for the conversation.
        - chatroomDetails: An instance of `LMChatSearchChatroomDataModel` containing details of the associated chatroom.
        - message: The content of the conversation message.
        - createdAt: A timestamp indicating when the conversation was created.
        - updatedAt: A timestamp indicating when the conversation was last updated.
        - user: An optional instance of `LMChatSearchListUserDataModel` representing the user associated with the conversation.
     */
    public init(
        id: String,
        chatroomDetails: LMChatSearchChatroomDataModel,
        message: String,
        createdAt: Double,
        updatedAt: Double,
        user: LMChatSearchListUserDataModel?
    ) {
        self.id = id
        self.chatroomDetails = chatroomDetails
        self.message = message
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.user = user
    }
}

/// A data model representing a user in the chat search context.
///
/// This model provides basic information about a user, including their unique identifier, username, profile image URL, and whether they are a guest. The data is used for displaying user-related search results.
///
/// - Properties:
///    - uuid: A unique identifier for the user.
///    - username: The username of the user.
///    - imageURL: An optional URL string pointing to the user's profile image.
///    - isGuest: A Boolean indicating whether the user is a guest.
///    - firstName: A computed property that extracts and returns the first name from the username.
public struct LMChatSearchListUserDataModel {
    /// A unique identifier for the user.
    public let uuid: String
    /// The username of the user.
    public let username: String
    /// An optional URL string for the user's profile image.
    public let imageURL: String?
    /// A Boolean indicating whether the user is a guest.
    public let isGuest: Bool

    /**
     Initializes a new instance of `LMChatSearchListUserDataModel`.

     - Parameters:
        - uuid: The unique identifier for the user.
        - username: The full username of the user.
        - imageURL: An optional URL string for the user's profile image.
        - isGuest: A Boolean indicating whether the user is a guest.
     */
    public init(
        uuid: String,
        username: String,
        imageURL: String?,
        isGuest: Bool
    ) {
        self.uuid = uuid
        self.username = username
        self.imageURL = imageURL
        self.isGuest = isGuest
    }

    /**
     Returns the first name of the user.

     This computed property trims any leading or trailing whitespace from the `username` and then returns the first component (i.e., the first word). If the username is empty after trimming or does not contain any spaces, it defaults to returning `"User"`.

     - Returns: A `String` representing the first name extracted from the username.
     */
    public var firstName: String {
        String(
            username.trimmingCharacters(in: .whitespacesAndNewlines)
                .split(separator: " ")
                .first ?? "User")
    }
}
