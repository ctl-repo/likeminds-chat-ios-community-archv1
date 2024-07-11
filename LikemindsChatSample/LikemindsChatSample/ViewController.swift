//
//  ViewController.swift
//  LikemindsChatSample
//
//  Created by Pushpendra Singh on 13/12/23.
//

import UIKit
import LikeMindsChatData
import LikeMindsChatUI
import LikeMindsChatCore

extension UIViewController {
    var window: UIWindow? {
        if #available(iOS 13, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }
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
        let main : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return main.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        isSavedData()
    }
    
    func moveToNextScreen() {
        self.showHideLoaderView(isShow: false, backgroundColor: .clear)
        let homefeedvc = ChatFeedViewModel.createModule()
        let navigation = UINavigationController(rootViewController: homefeedvc)
        navigation.modalPresentationStyle = .overFullScreen
        self.window?.rootViewController = navigation
    }
    
    @IBAction func loginAsCMButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func loginAsMemberButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        guard let apiKey = apiKeyField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !apiKey.isEmpty,
              let userId = userIdField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !userId.isEmpty,
              let username = userNameField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty else {
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
              let username = userDefalut.value(forKey: "username") as? String else {
            return false
        }
        callInitiateApi(userId: userId, username: username, apiKey: apiKey)
        return true
    }
    
    func callInitiateApi(userId: String, username: String, apiKey: String) {
        self.showHideLoaderView(isShow: true, backgroundColor: .clear)
                initiateSDK(apiKey: apiKey, userName: username, userUniqueId: userId){ result in
                    switch result {
                    case .success(let data):
                        do {
                            // Parse the JSON data into a dictionary
                            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                if let data = jsonResult["data"] as? [String: Any] {
                                    guard let accessToken = data["access_token"] as? String else {
                                        return
                                    }
                                    
                                    guard let refreshToken = data["refresh_token"] as? String else {
                                        return
                                    }
                                    
                                    let userDefalut = UserDefaults.standard
                                    userDefalut.setValue(accessToken, forKey: "accessToken")
                                    userDefalut.setValue(refreshToken, forKey: "refreshToken")
                                    
                                    LMChatCore.shared.showChat(accessToken: accessToken, refreshToken: refreshToken, handler: ClientSDKCallBack()){ [weak self] result in
                                        switch result {
                                        case .success:
                                            self?.moveToNextScreen()
                                        case .failure(let error):
                                            self?.showAlert(message: error.localizedDescription)
                                        }
                                    }
                                }
                            }
                        } catch {
                            print("Error parsing JSON: \(error.localizedDescription)")
                        }
                    case .failure(let error):
                        // Handle any errors
                        print("Error: \(error.localizedDescription)")
                    }
                }
          
//            LMChatCore.shared.showChat(apiKey:apiKey ,  username: username, uuid: userId){[weak self] result in
//                switch result {
//                case .success:
//                    self?.moveToNextScreen()
//                case .failure(let error):
//                    self?.showAlert(message: error.localizedDescription)
//                }
//            }
        
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
    
    
}

class ClientSDKCallBack: LMChatCoreCallback {
    func onAccessTokenExpiredAndRefreshed(accessToken: String, refreshToken: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(accessToken, forKey: "accessToken")
        userDefaults.setValue(refreshToken, forKey: "refreshToken")
    }
    
    func onRefreshTokenExpired(_ completionHandler: (((accessToken: String, refreshToken: String)?) -> Void)?) {
        let userDefaults = UserDefaults.standard
        guard let apiKey = userDefaults.value(forKey: "apiKey") as? String,
              let userId = userDefaults.value(forKey: "userId") as? String,
              let username = userDefaults.value(forKey: "username") as? String else {
            return
        }
        initiateSDK(apiKey: apiKey, userName: username, userUniqueId: userId){ result in
            
            switch result {
            case .success(let data):
                do {
                    // Parse the JSON data into a dictionary
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let data = jsonResult["data"] as? [String: Any] {
                            guard let accessToken = data["access_token"] as? String else {
                                return
                            }
                            
                            guard let refreshToken = data["refresh_token"] as? String else {
                                return
                            }
                            
                            let userDefalut = UserDefaults.standard
                            userDefalut.setValue(accessToken, forKey: "accessToken")
                            userDefalut.setValue(refreshToken, forKey: "refreshToken")
                            
                            completionHandler?((accessToken, refreshToken))
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            case .failure(let error):
                // Handle any errors
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

func initiateSDK(apiKey: String, userName: String, userUniqueId: String, completion: @escaping (Result<Data, Error>) -> Void) {
    // URL
    guard let url = URL(string: "https://betaauth.likeminds.community/sdk/initiate") else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }
    
    // Create the request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    // Set headers
    request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
    request.setValue("fl", forHTTPHeaderField: "x-platform-code")
    request.setValue("25", forHTTPHeaderField: "x-version-code")
    request.setValue("feed", forHTTPHeaderField: "x-sdk-source")
    request.setValue("1", forHTTPHeaderField: "x-api-version")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Create JSON body
    let body: [String: Any] = [
        "user_name": userName,
        "user_unique_id": userUniqueId,
        "token_expiry_beta": 1,
        "rtm_token_expiry_beta": 2
    ]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
    } catch {
        completion(.failure(error))
        return
    }
    
    // Create URLSession task
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
            return
        }
        
        completion(.success(data))
    }
    
    // Start the task
    task.resume()
}

