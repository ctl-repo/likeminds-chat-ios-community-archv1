//
//  LMChatCore.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 17/02/24.
//

import FirebaseMessaging
import Foundation
import LikeMindsChatData
import LikeMindsChatUI

/// Protocol defining callback methods for handling token-related events in LMChat.
public protocol LMChatCoreCallback: AnyObject {
    /// Called when the access token has expired and been successfully refreshed.
    ///
    /// - Parameters:
    ///   - accessToken: The new access token.
    ///   - refreshToken: The new refresh token.
    func onAccessTokenExpiredAndRefreshed(
        accessToken: String, refreshToken: String)

    /// Called when the refresh token has expired.
    ///
    /// - Parameter completionHandler: A closure to be called with new tokens.
    ///   The closure takes a tuple containing the new access token and refresh token.
    func onRefreshTokenExpired(
        _ completionHandler: (
            ((accessToken: String, refreshToken: String)?) -> Void
        )?)

    /// Called when user click on user profile view
    ///
    /// - Parameter uuid: user id to uniquely identify the user
    func userProfileViewHandle(withRoute route: String)

    /// Called when an analytics event is triggered in LMChat.
    ///
    /// - Parameters:
    ///   - eventName: The name of the analytics event, used for categorizing and identifying the type of event.
    ///   - eventProperties: A dictionary of properties providing additional context or data about the event.
    func onEventTriggered(
        eventName: LMChatAnalyticsEventName,
        eventProperties: [String: AnyHashable]
    )
    // Custom Button Handling
    func onCustomButtonCLicked(eventName: LMChatAnalyticsEventName, eventData: [String: Any])
}
public enum LMChatTheme {
    case COMMUNITY_CHAT
    case NETWORKING_CHAT
    case COMMUNITY_HYBRID_CHAT
    case AI_CHATBOT
}

public class LMChatCore {
    private init() {}

    public static var shared: LMChatCore = .init()
    public static private(set) var isInitialized: Bool = false
    public static private(set) var isSecretChatroomInviteEnabled: Bool = false
    public static var openedChatroomId: String? = nil
    public static private(set) var currentTheme: LMChatTheme =
        .COMMUNITY_HYBRID_CHAT

    // Callbacks for accessToken and refreshToken strategy
    private(set) var coreCallback: LMChatCoreCallback?

    public static var analytics: LMChatAnalyticsProtocol? = LMChatAnalytics()

    var deviceId: String?

    /// Sets up the chat environment.
    ///
    /// This function initializes necessary components for the chat functionality,
    /// including the AWS manager and Giphy API configuration.
    ///
    /// - Parameters:
    ///   - deviceId: Optional device identifier for push notifications
    ///   - excludedConversationStates: Optional array of conversation states to exclude
    ///   - theme: The chat theme to be used. Defaults to .communityChat
    public func setupChat(
        deviceId: String? = nil,
        excludedConversationStates: [ConversationState]? = nil,
        theme: LMChatTheme = .COMMUNITY_CHAT
    ) {
        _ = LMChatClient.Builder()
            .excludedConversationStates(excludedConversationStates)
            .setTokenManager(self)
            .build()

        self.deviceId = deviceId
        LMChatCore.currentTheme = theme

        LMChatAWSManager.shared.initialize()
        GiphyAPIConfiguration.configure()
    }

    // Method to set a custom callback
    public func setCallback(_ callback: LMChatCoreCallback) {
        self.coreCallback = callback
    }

    /// Initializes and displays the chat interface.
    ///
    /// This function handles all necessary setup for the chat, including fetching or generating authentication tokens.
    ///
    /// - Parameters:
    ///   - apiKey: The API key for authentication.
    ///   - username: The username of the current user.
    ///   - uuid: The unique identifier for the current user.
    ///   - completionHandler: A closure to be executed upon completion. It takes a `Result<Void, LMChatError>` parameter.
    ///
    /// - Note: This function first attempts to retrieve existing tokens from local storage.
    ///         If tokens are found, it validates the user with those tokens.
    ///         If no tokens are found, it initiates a new user session.
    public func showChat(
        apiKey: String, username: String, uuid: String,
        completionHandler: ((Result<Void, LMChatError>) -> Void)?
    ) {
        // Fetch tokens from local storage
        let tokens = LMChatClient.shared.getTokens()

        // If the tokens are already present in local storage
        // Call validateUser method with the tokens fetched from local storage
        if tokens.success, let accessToken = tokens.data?.accessToken,
            let refreshToken = tokens.data?.refreshToken
        {
            validateUser(accessToken: accessToken, refreshToken: refreshToken) {
                result in
                completionHandler?(result)
            }
        } else {
            // Call initiateUser method with the given uuid and apiKey
            initiateUser(
                apiKey: apiKey, username: username, uuid: uuid,
                completion: completionHandler)
        }
    }

    /// Displays the chat interface using provided or stored authentication tokens.
    ///
    /// - Parameters:
    ///   - accessToken: The access token for authentication. If nil, the function attempts to retrieve it from storage.
    ///   - refreshToken: The refresh token for authentication. If nil, the function attempts to retrieve it from storage.
    ///   - completionHandler: A closure to be executed upon completion. It takes a `Result<Void, LMChatError>` parameter.
    ///
    /// - Note: This function first sets up the chat environment and then attempts to validate the user
    ///         using either the provided tokens or tokens retrieved from storage. If no valid tokens
    ///         are available, it fails with an error.
    public func showChat(
        accessToken: String?, refreshToken: String?,
        handler: LMChatCoreCallback? = nil,
        completionHandler: ((Result<Void, LMChatError>) -> Void)?
    ) {
        self.coreCallback = handler

        // Attempt to retrieve tokens from storage
        let tokenResponse: LMResponse = LMChatClient.shared.getTokens()

        if let accessToken, let refreshToken {
            // If both tokens are provided, validate the user
            validateUser(
                accessToken: accessToken, refreshToken: refreshToken,
                completionHandler: completionHandler)
        } else if tokenResponse.success,
            let accessToken = tokenResponse.data?.accessToken,
            let refreshToken = tokenResponse.data?.refreshToken
        {
            // If tokens are successfully retrieved from storage, validate the user
            validateUser(
                accessToken: accessToken, refreshToken: refreshToken,
                completionHandler: completionHandler)
        } else {
            // If no valid tokens are available, fail with an error
            completionHandler?(
                .failure(.apiInitializationFailed(error: "Invalid Tokens")))
        }
    }

    /// Called after the user session is initialized.
    /// This function updates various settings based on the community configuration,
    /// registers the device if available, and marks the session as fully initialized.
    private func onPostUserSessionInit(community: Community?) {
        // Retrieve community-specific settings if available; otherwise, use an empty array.
        let communitySettings = community?.communitySettings ?? []

        // Check for the setting that allows direct messaging without requiring a connection request.
        // If the setting is found and it is enabled, store the corresponding value in shared preferences.
        if let setting = communitySettings.first(where: {
            $0.type
                == CommunitySetting.SettingType.enableDMWithoutConnectionRequest
                .rawValue
        }) {
            LMDMChatUtil.updateDMRequestSettings(
                isEnabled: setting.enabled ?? false)
        }

        // Check if there is a setting for secret chatroom invites.
        // If the setting exists, update the LMChatCore's flag accordingly.
        if let setting = communitySettings.first(where: {
            $0.type == CommunitySetting.SettingType.secretGroupInvite.rawValue
        }) {
            // If the 'enabled' property is nil, default to false.
            LMChatCore.isSecretChatroomInviteEnabled = setting.enabled ?? false
        }

        // If a valid device ID exists (i.e., it is non-nil and not empty),
        // register the device for receiving push notifications or similar services.
        if let deviceId = self.deviceId, !deviceId.isEmpty {
            self.registerDevice(deviceId: deviceId)
        }

        // Fetch community configurations in background
        LMChatClient.shared.getCommunityConfigurations { response in
            guard response.success, let configurations = response.data else {
                print(
                    "Failed to fetch community configurations: \(response.errorMessage ?? "")"
                )
                return
            }

            // Save configurations
            LMConfigurationManager.saveConfigurations(
                configurations.configurations)
        }

        // Mark the initialization process as complete.
        Self.isInitialized = true
    }

    /// Validates the user using the provided access and refresh tokens.
    ///
    /// - Parameters:
    ///   - accessToken: The access token for authentication.
    ///   - refreshToken: The refresh token for authentication.
    ///   - completionHandler: A closure to be executed upon completion. It takes a `Result<Void, LMChatError>` parameter.
    ///
    /// - Note: This function builds a ValidateUserRequest and sends it to the LMChatClient.
    ///         It handles various response scenarios including successful validation,
    ///         API initialization failure, and app access denial.
    private func validateUser(
        accessToken: String, refreshToken: String,
        completionHandler: ((Result<Void, LMChatError>) -> Void)?
    ) {
        // Build the validate user request
        let request: ValidateUserRequest = ValidateUserRequest.builder()
            .accessToken(accessToken)
            .refreshToken(refreshToken)
            .build()

        // Send the validate user request
        LMChatClient.shared.validateUser(request: request) {
            [weak self] response in
            // Check if the response was successful
            guard response.success else {
                completionHandler?(
                    .failure(
                        .apiInitializationFailed(error: response.errorMessage)))
                return
            }

            // Check if the app has access
            if response.data?.appAccess == false {
                self?.logoutUser(
                    deviceId: UIDevice.current.identifierForVendor?.uuidString
                        ?? "")
                completionHandler?(.failure(.appAccessFalse))
                return
            }

            self?.onPostUserSessionInit(community: response.data?.community)

            completionHandler?(.success(()))
        }
    }

    /// Initiates a new user session with the provided username and user ID.
    ///
    /// - Parameters:
    ///   - username: The username of the user to initiate.
    ///   - userId: The unique identifier of the user.
    ///   - completion: A closure to be executed upon completion. It takes a `Result<Void, LMChatError>` parameter.
    ///
    /// - Note: This function creates an InitiateUserRequest and sends it to the LMChatClient.
    ///         It handles the response, including successful initiation, API initialization failure,
    ///         and app access denial. If successful, it also registers the device.
    private func initiateUser(
        apiKey: String, username: String, uuid: String,
        completion: ((Result<Void, LMChatError>) -> Void)?
    ) {

        // Build the initiate user request
        let request = InitiateUserRequest.builder()
            .userName(username)
            .uuid(uuid)
            .isGuest(false)
            .apiKey(apiKey)
            .build()

        // Send the initiate user request
        LMChatClient.shared.initiateUser(request: request) {
            [weak self] response in
            // Check if the response was successful and app access is granted
            guard response.success, response.data?.appAccess == true else {
                print("error in initiate user: \(response.errorMessage ?? "")")
                self?.logoutUser(
                    deviceId: UIDevice.current.identifierForVendor?.uuidString
                        ?? "")
                completion?(
                    .failure(
                        .apiInitializationFailed(error: response.errorMessage)))
                return
            }

            self?.onPostUserSessionInit(community: response.data?.community)

            completion?(.success(()))
        }
    }

    // This function extracts FCM Token and calls registerDevice api
    private func registerDevice(
        deviceId: String,
        completion: ((Result<Void, LMChatError>) -> Void)? = nil
    ) {
        Messaging.messaging().token { token, error in
            if let error {
                debugPrint(error)
            } else if let token {
                self.registerDevice(with: token, deviceId: deviceId)
            }
        }
    }

    /// Registers the current device for push notifications with the LikeMinds system.
    ///
    /// This function performs two main tasks:
    /// 1. Registers the device with the chat system using the obtained FCM token and provided device ID.
    ///
    /// - Parameter deviceId: A unique identifier for the current device.
    /// - Parameter fcmToken: FCM Token
    ///
    /// - Note: This function relies on Firebase Messaging to obtain the FCM token. Ensure that Firebase is properly configured in your project before calling this function.
    ///
    /// - Important: This function does not handle Firebase initialization. Make sure Firebase is initialized before calling this function.
    ///
    /// The function follows these steps:
    /// 1. If the token is successfully retrieved, it creates a `RegisterDeviceRequest` with the device ID and FCM token.
    /// 2. Sends the registration request to LikeMinds system using `LMChatClient.shared.registerDevice`.
    /// 3. Prints an error message if the registration fails.I
    ///
    public func registerDevice(
        with token: String, deviceId: String,
        completion: ((Result<Void, LMChatError>) -> Void)? = nil
    ) {
        let request = RegisterDeviceRequest.builder()
            .token(token)
            .deviceId(deviceId)
            .build()

        LMChatClient.shared.registerDevice(request: request) { response in
            if response.success {
                completion?(.success(()))
            } else {
                completion?(
                    .failure(
                        .notificationRegisterationFailed(
                            error: response.errorMessage)))
            }
        }
    }

    /// Logs out the current user from the chat system.
    ///
    /// This function initiates the logout process for the current user. It sends a logout request
    /// to the server with the provided refresh token and device ID. Upon successful logout,
    /// the user's session is terminated on the server side.
    ///
    /// - Parameters:
    ///   - refreshToken: The refresh token associated with the current user's session.
    ///   - deviceId: The unique identifier of the device from which the user is logging out.
    ///   - completion: An optional closure that is called when the logout process completes.
    ///     It receives a `Result` type, which will be either:
    ///     - `.success(())` if the logout was successful.
    ///     - `.failure(LMChatError)` if the logout failed, with the associated error.
    ///
    /// - Note: If the completion handler is not provided, the function will still perform
    ///   the logout operation, but the caller won't be notified of the result.
    ///
    /// - Important: After a successful logout, any stored session data or tokens should be cleared
    ///   from the client-side storage to prevent unauthorized access.
    public func logoutUser(
        deviceId: String,
        completion: ((Result<Void, LMChatError>) -> Void)? = nil
    ) {
        let request = LogoutUserRequest.builder()
            .deviceId(deviceId)
            .build()

        LMChatClient.shared.logoutUser(request: request) { response in
            if response.success {
                completion?(.success(()))
            } else {
                completion?(
                    .failure(.logoutFailed(error: response.errorMessage)))
            }
        }
        LMSharedPreferences.removeValue(forKey: LMSharedPreferencesKeys.aiChatBotRoomKey)
        
        
    }

    /// Returns the reply privately configuration if available
    /// - Returns: Configuration object for reply privately feature or nil if not found
    public func getReplyPrivatelyConfiguration() -> Configuration? {
        return LMConfigurationManager.getReplyPrivatelyConfiguration()
    }

    public func parseDeepLink(routeUrl: String) {
        DeepLinkManager.sharedInstance.deeplinkRoute(
            routeUrl: routeUrl, fromNotification: false, fromDeeplink: true)
    }

    @discardableResult
    public func didReceieveNotification(userInfo: [AnyHashable: Any]) -> Bool {
        guard let route = userInfo["route"] as? String,
            UIApplication.shared.applicationState == .inactive
        else { return false }
        DeepLinkManager.sharedInstance.didReceivedRemoteNotification(route)
        return true
    }

    public func willPresentNotification(
        userInfo: [AnyHashable: Any],
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {

        // Extract your chat room ID from userInfo if it's available
        // (Adjust the key "chatRoomID" to whatever your payload structure uses)
        if let incomingChatRoomID = getChatroomIdFromRoute(
            from:
                userInfo["route"] as? String ?? ""),
            let activeChatRoomID = LMChatCore.openedChatroomId,
            incomingChatRoomID == activeChatRoomID
        {

            // The user is currently in the chat room for which the notification arrived
            // => Do not show any notification banner or sound
            completionHandler([])
        } else {
            // The notification is for a different chat room OR no chat room is active
            // => Show the default notification behavior (alert, badge, sound, etc.)
            completionHandler([.alert, .badge, .sound])
        }
    }

    public func disableIQKeyboardForViewControllers() -> [UIViewController.Type]
    {
        return [
            LMChatCreatePollViewController.self,
            LMChatMessageListViewController.self,
            LMChatReportViewController.self,
            LMChatAttachmentViewController.self,
        ]
    }
}

extension LMChatCore: LMChatSDKCallback {
    /// Callback function invoked when the access token has expired and been successfully refreshed.
    ///
    /// This method is called automatically by the SDK when it detects that the access token has expired
    /// and has successfully obtained a new one. It then forwards this information to the `coreCallback`
    /// if one is set.
    ///
    /// - Parameters:
    ///   - accessToken: The new access token obtained after refreshing.
    ///   - refreshToken: The new refresh token obtained along with the access token.
    public func onAccessTokenExpiredAndRefreshed(
        accessToken: String, refreshToken: String
    ) {
        coreCallback?.onAccessTokenExpiredAndRefreshed(
            accessToken: accessToken, refreshToken: refreshToken)
    }

    /// Callback function invoked when the refresh token has expired.
    ///
    /// This method is called when the SDK detects that the refresh token has expired. It attempts to
    /// re-initiate the user session using the stored API key and UUID. If successful, it obtains new
    /// tokens and passes them to the completion handler. If it fails or required information is missing,
    /// it calls the completion handler with nil or delegates to the `coreCallback`.
    ///
    /// - Parameter completionHandler: A closure that takes an optional tuple of (accessToken: String, refreshToken: String)
    ///   and returns Void. This closure is called with the new tokens if re-initiation is successful, or with nil if it fails.
    public func onRefreshTokenExpired(
        _ completionHandler: (
            ((accessToken: String, refreshToken: String)?) -> Void
        )?
    ) {
        let apiData = LMChatClient.shared.getAPIKey()

        if let apiKey = apiData.data,
            let uuid = UserPreferences.shared.getClientUUID()
        {
            LMChatCore.shared.initiateUser(
                apiKey: apiKey, username: "", uuid: uuid
            ) { response in
                switch response {
                case .success():
                    let tokens = LMChatClient.shared.getTokens()
                    if tokens.success,
                        let accessToken = tokens.data?.accessToken,
                        let refreshToken = tokens.data?.refreshToken
                    {
                        completionHandler?((accessToken, refreshToken))
                        return
                    }
                case .failure(_):
                    completionHandler?(nil)
                    break
                }
                completionHandler?(nil)
            }
        } else {
            coreCallback?.onRefreshTokenExpired(completionHandler)
        }
    }
}
