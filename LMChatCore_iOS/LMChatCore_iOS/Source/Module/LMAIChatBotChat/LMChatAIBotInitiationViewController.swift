//
//  LMChatAIBotInitiationViewController.swift
//  LikeMindsChatCore
//
//  Created by Arpit Verma on 13/04/25.
//

import UIKit
import Lottie
import LikeMindsChatUI

public class LMChatAIBotInitiationViewController: LMViewController {
    
    // MARK: - Properties
    private var animationView: LottieAnimationView?
    private var previewText: String
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var animationContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var previewLabel: UILabel = {
        let label = UILabel()
        label.text = previewText
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    public init(previewText: String = "Setting up AI chatbot...") {
        self.previewText = previewText
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAnimation()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    // MARK: - Setup
        private func setupUI() {
            view.backgroundColor = .white
            
            // Add subviews
            view.addSubview(containerView)
            containerView.addSubview(animationContainerView)
            containerView.addSubview(previewLabel)
            
            // Setup constraints
            NSLayoutConstraint.activate([
                // Container view
                containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
                containerView.heightAnchor.constraint(equalTo: view.heightAnchor),
                
                // Animation container - Centered in view with larger size
                animationContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                animationContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                animationContainerView.widthAnchor.constraint(equalToConstant: 450),
                animationContainerView.heightAnchor.constraint(equalToConstant: 450),
                
                // Preview label - Fixed to bottom center with padding
                previewLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                previewLabel.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -40), // Fixed distance from bottom
                previewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                previewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
            ])
        }

    
    private func setupAnimation() {
        // Try to load animation from bundle
        if let animationPath = Bundle.main.path(forResource: "lottie", ofType: "json") {
            let animation = LottieAnimation.filepath(animationPath)
            animationView = LottieAnimationView(animation: animation)
        } else {
            // Fallback to named animation if file not found in bundle
            let animation = LottieAnimation.named("lottie")
            animationView = LottieAnimationView(animation: animation)
        }
        
        guard let animationView = animationView else { return }
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add animation view to container
        animationContainerView.addSubview(animationView)
        
        // Setup animation constraints to fill container
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: animationContainerView.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: animationContainerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: animationContainerView.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: animationContainerView.bottomAnchor)
        ])
    }
    
    private func startAnimation() {
        animationView?.play()
        
        // Simulate loading time and then dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.dismiss(animated: true) {
                // After dismissal, present the chat interface
                self?.presentChatInterface()
            }
        }
    }
    
    private func presentChatInterface() {
        // Here you would typically present your chat interface
        // This will be handled by your chat SDK
    }
    
    // MARK: - Public Methods
    public func updatePreviewText(_ text: String) {
        previewLabel.text = text
    }
    
    public func setPreviewTextStyle(_ attributes: [NSAttributedString.Key: Any]) {
        if let text = previewLabel.text {
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            previewLabel.attributedText = attributedString
        }
    }
}
