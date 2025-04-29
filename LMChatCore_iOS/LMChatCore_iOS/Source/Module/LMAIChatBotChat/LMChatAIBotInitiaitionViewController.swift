//
//  LMChatAIBotInitiationViewController.swift
//  LikeMindsChatCore
//
//  Created by Arpit Verma on 13/04/25.
//


import UIKit
import Lottie
import LikeMindsChatUI

open class LMChatAIBotInitiaitionViewController: LMViewController, LMAIChatBotChatViewModelProtocol {
    
    
    // MARK: - Data Properties
    var viewModel: LMChatAIBotInitiaitionViewModel?
    
    // MARK: - UI Components
    open lazy var containerView: LMView = {
        let view = LMView()
        view.backgroundColor = Appearance.shared.colors.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    open lazy var animationContainerView: LMView = {
        let view = LMView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    open lazy var previewLabel: LMLabel = {
        let label = LMLabel()
        label.text = Constants.shared.strings.aiSetupText
        label.textAlignment = .center
        label.textColor = Appearance.shared.colors.gray1
        label.font = Appearance.shared.fonts.textFont1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    open var animationView: LottieAnimationView?
    
    // MARK: - Initialization
    required public init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - View Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
        viewModel?.initializeChatbot()
    }
    
    // MARK: - LMAIChatBotChatViewModelProtocol
    
    public func didCompleteInitialization(chatroomId: String) {
        stopAnimation()
        
        if let presentingVC = presentingViewController {
            dismiss(animated: true) { [weak presentingVC] in
                guard let presentingVC = presentingVC else { return }
                
                // Handle the case where presentingVC IS the navigation controller
                if let navController = presentingVC as? UINavigationController {
                  
                    if let chatMessageVC = try? LMChatMessageListViewModel.createModule(
                        withChatroomId: chatroomId,
                        conversationId: nil
                    ) {
                        navController.pushViewController(chatMessageVC, animated: true)
                    }
                    return
                }
                
            }
        }
    }
    
    public func didFailInitialization(with error: String) {
        stopAnimation()
        showErrorAlert(message: error)
    }
    
    // MARK: - Private Methods
    
    open func stopAnimation() {
        animationView?.stop()
    }
    
    // MARK: - Setup Methods
    open override func setupViews() {
        super.setupViews()
        view.addSubview(containerView)
        containerView.addSubview(animationContainerView)
        containerView.addSubview(previewLabel)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            // Container View
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Animation Container
            animationContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            animationContainerView.widthAnchor.constraint(equalToConstant: 450),
            animationContainerView.heightAnchor.constraint(equalToConstant: 450),
            
            // Preview Label
            previewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            previewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            previewLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40)
        ])
    }
    
    open func setupAnimation() {
        
        if let hostAppAnimation = LottieAnimation.named(Constants.shared.strings.aiSetupAnimationName, bundle: Bundle.main) {
                setupAnimationView(with: hostAppAnimation)
                return
            }
        // Get the framework bundle
        let frameworkBundle = Bundle(for: type(of: self))
        guard let resourceBundlePath = frameworkBundle.path(forResource: "LikeMindsChatCore", ofType: "bundle"),
              let resourceBundle = Bundle(path: resourceBundlePath) else {
            return
        }
        if let animation = LottieAnimation.named(Constants.shared.strings.aiSetupAnimationName, bundle: resourceBundle) {
            setupAnimationView(with: animation)
            return
        }
        print("Animation not found in bundle")
    }
    
    open func setupAnimationView(with animation: LottieAnimation) {
        animationView = LottieAnimationView(animation: animation)
        
        guard let animationView = animationView else { return }
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        animationContainerView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: animationContainerView.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: animationContainerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: animationContainerView.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: animationContainerView.bottomAnchor)
        ])
    }
    
    open func startAnimation() {
        animationView?.play()
    }
}
