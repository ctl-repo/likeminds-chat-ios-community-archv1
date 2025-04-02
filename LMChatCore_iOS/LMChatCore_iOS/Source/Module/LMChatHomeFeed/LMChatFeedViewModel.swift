//
//  LMChatFeedViewModel.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 14/06/24.
//

import Foundation
import LikeMindsChatData
import LikeMindsChatUI

public protocol LMChatFeedViewModelProtocol: AnyObject {
    func showDMTab()
    func onLogout()
}

public class LMChatFeedViewModel {
    
    weak var delegate: LMChatFeedViewModelProtocol?
    var dmTab: CheckDMTabResponse?
    
    init(_ viewController: LMChatFeedViewModelProtocol) {
        self.delegate = viewController
    }
    
    public static func createModule() -> LMChatFeedViewController {
        let viewController = LMChatFeedViewController()
        viewController.viewModel = LMChatFeedViewModel(viewController)
        return viewController
    }
    
    func checkDMTab() {
        LMChatClient.shared.checkDMTab {[weak self] response in
            guard let data = response.data else { return }
            self?.dmTab = data
            self?.delegate?.showDMTab()
        }
    }
    
    func logout() {
        let request = LogoutUserRequest.builder().deviceId(UIDevice.current.identifierForVendor?.uuidString ?? "").build()
        LMChatClient.shared.logoutUser(request: request) {[weak self] response in
            guard let vc = self?.delegate as? LMChatFeedViewController else { return }
            let userDefalut = UserDefaults.standard
            userDefalut.removeObject(forKey: "apiKey")
            userDefalut.removeObject(forKey: "userId")
            userDefalut.removeObject(forKey: "username")
            self?.delegate?.onLogout()
        }
    }
    
}
