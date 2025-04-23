//
//  LMAIChatBotChatViewModel.swift
//  LikeMindsChatCore
//
//  Created by Arpit Verma on 13/04/25.
//

import Foundation
import LikeMindsChatUI
import LikeMindsChatData

/// A protocol defining the methods that the view model uses to communicate
/// changes or updates back to its view controller.
public protocol LMAIChatBotChatViewModelProtocol: AnyObject {
    
    /// Called when the chatbot initialization process completes with chatroom ID
    func didCompleteInitialization(chatroomId: String)
    
    /// Called when an error occurs during initialization
    func didFailInitialization(with error: String)
}

/// `LMAIChatBotChatViewModel` serves as the data and business logic layer
/// for `LMAIChatBotViewController`. It handles chatbot initialization and
/// chatroom creation/access.
public class LMChatAIBotInitiationViewModel: LMChatBaseViewModel {
    
    // MARK: - Properties
    
    /// A weak reference to the delegate conforming to `LMAIChatBotChatViewModelProtocol`.
    weak var delegate: LMAIChatBotChatViewModelProtocol?
    
    /// The chatbot user object once retrieved
    private var chatbot: Member?
    
    /// The chatroom ID for the AI chatbot conversation
    private var chatroomId: String?
    
    // MARK: - Initializer
    
    /// Creates a new instance of the view model and sets the delegate.
    init(_ viewController: LMAIChatBotChatViewModelProtocol) {
        self.delegate = viewController
    }
    
    // MARK: - Module Creation
    
    /// Factory method to create an instance of `LMAIChatBotViewController`
    /// wired up with an `LMAIChatBotChatViewModel`.
    public static func createModule() throws -> LMViewController {
        guard LMChatCore.isInitialized else {
            throw LMChatError.chatNotInitialized
        }
        
        
        if let existingChatroomId = LMSharedPreferences.getString(forKey: Constants.shared.strings.aiChatBotRoomKey) {
            // If we have an existing chatroom ID, navigate directly to the chat screen
            return try LMChatMessageListViewModel.createModule(
                withChatroomId: existingChatroomId,
                conversationId: nil
            )
        } else {
            // If no existing chatroom, show the initiation screen
            let viewController = LMCoreComponents.shared.aiChatBotIntiationScreen.init()
            viewController.viewModel = LMChatAIBotInitiationViewModel(viewController)
            return viewController
        }
        
    }
    
    // MARK: - Initialization Logic
    
    /// Starts the chatbot initialization process
    func initializeChatbot() {
        
        do {
            let request = try GetAIChatbotsRequest.builder()
                .page(1)
                .pageSize(10)
                .build()
            
            LMChatClient.shared.getAIChatbots(request: request) { [weak self] response in
                guard let self = self else { return }
                
                // Check if we have chatbots available
                guard let chatbots = response.data?.users, !chatbots.isEmpty else {
                    self.delegate?.didFailInitialization(with: Constants.shared.strings.chatBotNotAvailable)
                    return
                }
                let firstChatbot = chatbots[0]
                self.chatbot = firstChatbot
                self.checkDMStatus(for: firstChatbot)
            }
        } catch {
            delegate?.didFailInitialization(with: error.localizedDescription)
        }
    }
    
    /// Checks DM status for the given chatbot
    private func checkDMStatus(for chatbot: Member) {
        guard let chatbotUUID = chatbot.sdkClientInfo?.uuid else {
            delegate?.didFailInitialization(with:Constants.shared.strings.invalidChatBotUUID)
            return
        }
        
        let request = CheckDMStatusRequest.builder()
            .requestFrom(.memberProfile)
            .uuid(chatbotUUID)
            .build()
        
        LMChatClient.shared.checkDMStatus(request: request) { [weak self] response in
            guard let self = self else { return }
           
            
            // Check if DM is enabled
            guard let showDM = response.data?.showDM, showDM else {
                self.delegate?.didFailInitialization(with:Constants.shared.strings.dmNotAllowed)
                return
            }
            
            // Check if we have a CTA URL with chatroom ID
            if let cta = response.data?.cta,
               let ctaURL = URL(string: cta),
               let components = URLComponents(url: ctaURL, resolvingAgainstBaseURL: false),
               let chatroomId = components.queryItems?.first(where: { $0.name == "chatroom_id" })?.value {
                
                self.saveAndNavigateToChatroom(chatroomId)
                return
                
            } else {
                // No existing chatroom, create new one
                self.createDMChatroom(with: chatbotUUID)
            }
        }
    }
    
    /// Creates a new DM chatroom with the chatbot
    private func createDMChatroom(with chatbotUUID: String) {
        let request = CreateDMChatroomRequest.builder()
            .uuid(chatbotUUID)
            .build()
        
        LMChatClient.shared.createDMChatroom(request: request) { [weak self] response in
            guard let self = self else { return }
            
            if let chatroomId = response.data?.chatroomData?.id {
                self.saveAndNavigateToChatroom(chatroomId)
            } else {
                self.delegate?.didFailInitialization(with: Constants.shared.strings.chatroomCreateFail)
            }
        }
    }
    
    /// Saves the chatroom ID and notifies completion
    private func saveAndNavigateToChatroom(_ chatroomId: String) {
        
        // Save chatroom ID to local prefs
        LMSharedPreferences.setString(chatroomId, forKey: Constants.shared.strings.aiChatBotRoomKey)
        
        // Notify completion with chatroom ID
        delegate?.didCompleteInitialization(chatroomId: chatroomId)
    }
}
