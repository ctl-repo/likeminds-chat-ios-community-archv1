//
//  LMChatAIBotInitiationViewController.swift
//  LikeMindsChatCore
//
//  Created by Arpit Verma on 13/04/25.
//

import UIKit
import Lottie
import LikeMindsChatUI

open class LMChatAIBotInitiationViewController: LMViewController {
    
    // MARK: - UI Constants
        private let animationContainerSize: CGFloat = 450
        private let previewLabelBottomPadding: CGFloat = 40
        private let previewLabelSidePadding: CGFloat = 20
        private let animationDuration: TimeInterval = 3.0
        private let animationName = "lottie" // Update this with your actual animation file name
    
    // MARK: - Data Properties
    var viewModel: LMAIChatBotChatViewModel?
    
    // MARK: - UI Components
    private lazy var containerView: LMView = {
        let view = LMView()
        view.backgroundColor = Appearance.shared.colors.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var animationContainerView: LMView = {
        let view = LMView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var previewLabel: LMLabel = {
        let label = LMLabel()
        label.text = Constants.shared.strings.aiSetupText
        label.textAlignment = .center
        label.textColor = Appearance.shared.colors.gray1
        label.font = Appearance.shared.fonts.textFont1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var animationView: LottieAnimationView?
    
    // MARK: - Initialization
    required public init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    open override func setupViews() {
        super.setupViews()
        
        view.addSubview(containerView)
        containerView.addSubview(animationContainerView)
        containerView.addSubview(previewLabel)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            animationContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            animationContainerView.widthAnchor.constraint(equalToConstant: animationContainerSize),
            animationContainerView.heightAnchor.constraint(equalToConstant: animationContainerSize),
            
            previewLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            previewLabel.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor,
                                             constant: -previewLabelBottomPadding),
            previewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                               constant: previewLabelSidePadding),
            previewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                constant: -previewLabelSidePadding)
        ])
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    // MARK: - Private Methods
    private func setupAnimation() {
        // First try loading from main bundle
        if let animation = LottieAnimation.named(animationName,subdirectory: "./Assets") {
            setupAnimationView(with: animation)
            return
        }
        
        // If not found, try loading from the framework bundle
        let frameworkBundle = Bundle(for: type(of: self))
        if let animation = LottieAnimation.named(animationName, bundle: frameworkBundle,subdirectory: "./Assets") {
            setupAnimationView(with: animation)
            return
        }
        
        // If still not found, try loading from file path
        if let path = frameworkBundle.path(forResource: animationName, ofType: "json",inDirectory: "./Assets") {
            let animation = LottieAnimation.filepath(path)
            guard let animation = animation else {
                return
            }
            setupAnimationView(with: animation)
            return
        }
        
        print("Error: Could not load animation named \(animationName)")
    }
    
    private func setupAnimationView(with animation: LottieAnimation) {
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
    
    private func startAnimation() {
        animationView?.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) { [weak self] in
            self?.dismiss(animated: true) {
                self?.presentChatInterface()
            }
        }
    }
    
    private func presentChatInterface() {
        // Make sure we're presenting from the topmost view controller
        guard let topVC = UIApplication.shared.topViewController() else { return }
        
        // Your chat interface presentation logic here
        // Example:
        // let chatVC = YourChatViewController()
        // topVC.present(chatVC, animated: true)
    }

}

// Helper extension to find top view controller
extension UIApplication {
    func topViewController() -> UIViewController? {
        let keyWindow = connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first
        
        var topVC = keyWindow?.rootViewController
        while let presentedVC = topVC?.presentedViewController {
            topVC = presentedVC
        }
        return topVC
    }
}

extension LMChatAIBotInitiationViewController: LMAIChatBotChatViewModelProtocol {
    // Protocol implementation
}
