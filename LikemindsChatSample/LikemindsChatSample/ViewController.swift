//
//  ViewController.swift
//  LikemindsChatSample
//
//  Created by Pushpendra Singh on 13/12/23.
//

import FirebaseMessaging
import LikeMindsChatCore
import LikeMindsChatUI
import UIKit

extension UIViewController {
    var window: UIWindow? {
        if #available(iOS 13, *) {
            guard
                let windowScene = UIApplication.shared.connectedScenes.first
                    as? UIWindowScene,
                let delegate = windowScene.delegate as? SceneDelegate,
                let window = delegate.window
            else { return nil }
            return window
        }
        return nil
    }
}

class ViewController: LMViewController {

    @IBOutlet weak var apiKeyField: UITextField?
    @IBOutlet weak var userIdField: UITextField?
    @IBOutlet weak var userNameField: UITextField?
    @IBOutlet weak var loginButton: UIButton?

    static func createViewController() -> ViewController {
        let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return main.instantiateViewController(
            withIdentifier: "LoginViewController") as! ViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        isSavedData()
    }

    func moveToNextScreen() {
        self.showHideLoaderView(isShow: false, backgroundColor: .clear)
        let homeVC = HomeViewController()
        let navigation = UINavigationController(rootViewController: homeVC)
        navigation.modalPresentationStyle = .overFullScreen
        self.window?.rootViewController = navigation
    }

    @IBAction func loginAsCMButtonClicked(_ sender: UIButton) {
    }

    @IBAction func loginAsMemberButtonClicked(_ sender: UIButton) {
    }

    @IBAction func loginButtonClicked(_ sender: UIButton) {
        guard
            let apiKey = apiKeyField?.text?.trimmingCharacters(
                in: .whitespacesAndNewlines), !apiKey.isEmpty,
            let userId = userIdField?.text?.trimmingCharacters(
                in: .whitespacesAndNewlines), !userId.isEmpty,
            let username = userNameField?.text?.trimmingCharacters(
                in: .whitespacesAndNewlines), !username.isEmpty
        else {
            showAlert(message: "All fields are mandatory!")
            return
        }

        let userDefalut = UserDefaults.standard
        userDefalut.setValue(apiKey, forKey: "apiKey")
        userDefalut.setValue(userId, forKey: "userId")
        userDefalut.setValue(username, forKey: "username")
        userDefalut.synchronize()
        callInitiateApi(userId: userId, username: username, apiKey: apiKey)
    }

    @discardableResult
    func isSavedData() -> Bool {
        let userDefalut = UserDefaults.standard
        guard let apiKey = userDefalut.value(forKey: "apiKey") as? String,
            let userId = userDefalut.value(forKey: "userId") as? String,
            let username = userDefalut.value(forKey: "username") as? String
        else {
            return false
        }
        callInitiateApi(userId: userId, username: username, apiKey: apiKey)
        return true
    }

    func callInitiateApi(userId: String, username: String, apiKey: String) {
        self.showHideLoaderView(isShow: true, backgroundColor: .clear)

        LMChatCore.shared.showChat(
            apiKey: apiKey, username: username, uuid: userId
        ) { [weak self] result in
            switch result {
            case .success:
                self?.moveToNextScreen()
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }

    }

    func showAlert(message: String) {
        let alert = UIAlertController(
            title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
}

class HomeViewController: UIViewController {

    private let chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open Chat", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Home"

        view.addSubview(chatButton)

        NSLayoutConstraint.activate([
            chatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chatButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            chatButton.widthAnchor.constraint(equalToConstant: 200),
            chatButton.heightAnchor.constraint(equalToConstant: 44),
        ])

        chatButton.addTarget(
            self, action: #selector(chatButtonTapped), for: .touchUpInside)
    }

    @objc private func chatButtonTapped() {
        do {
            let chatFeedVC = try LMChatFeedViewModel.createModule()
            LMChatCore.shared.setCallback(self)
            navigationController?.pushViewController(chatFeedVC, animated: true)
        } catch {
            let alert = UIAlertController(
                title: "Error",
                message: "Failed to open chat: \(error.localizedDescription)",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

extension HomeViewController: LMChatCoreCallback {
    func onCustomButtonCLicked(eventName: LikeMindsChatCore.LMChatAnalyticsEventName, eventData: [String : Any]) {
        debugPrint(eventName.rawValue)
        debugPrint(eventData)
    }
    
    func onAccessTokenExpiredAndRefreshed(accessToken: String, refreshToken: String) {
        
    }
    
    func onRefreshTokenExpired(_ completionHandler: (((accessToken: String, refreshToken: String)?) -> Void)?) {
        
    }
    
    func userProfileViewHandle(withRoute route: String) {
        
    }
    
    func onEventTriggered(eventName: LikeMindsChatCore.LMChatAnalyticsEventName, eventProperties: [String : AnyHashable]) {
        debugPrint(eventName)
        debugPrint(eventProperties)
    }
    
    
}
