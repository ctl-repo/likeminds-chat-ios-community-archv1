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
}
