//
//  LMChatAIButton.swift
//  LikeMindsChatCore
//
//  Created by Arpit Verma on 11/04/25.
//

import UIKit
import LikeMindsChatUI

// MARK: - Supporting Types
public enum LMChatAIButtonIconPlacement {
    case start
    case end
}

// MARK: - Props Configuration
public class LMChatAIButtonProps {
    public var apiKey: String?
    public var uuid: String?
    public var userName: String?
    public var imageUrl: String?
    public var isGuest: Bool?
    public var accessToken: String?
    public var refreshToken: String?
    
    public init(
        apiKey: String? = nil,
        uuid: String? = nil,
        userName: String? = nil,
        imageUrl: String? = nil,
        isGuest: Bool? = nil,
        accessToken: String? = nil,
        refreshToken: String? = nil
    ) {
        self.apiKey = apiKey
        self.uuid = uuid
        self.userName = userName
        self.imageUrl = imageUrl
        self.isGuest = isGuest
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

// MARK: - Delegate Protocol
public protocol LMChatAIButtonDelegate: AnyObject {
    func didTapAIButton(_ button: LMChatAIButton, props: LMChatAIButtonProps)
}

// MARK: - Button Implementation
@IBDesignable
open class LMChatAIButton: LMButton {
    // MARK: Properties
    public weak var delegate: LMChatAIButtonDelegate?
    public private(set) var props: LMChatAIButtonProps?
    
    // MARK: Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    @available(*, unavailable, renamed: "init(frame:)")
    public required init?(coder: NSCoder) {
        fatalError("\(#function) not implemented in \(#filePath)")
    }
    
    // MARK: Setup
    private func setupButton() {
        // Add tap action
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // MARK: Configuration Methods
    public func setProps(_ props: LMChatAIButtonProps) {
        self.props = props
    }
    
    public func configureIconPlacement(_ placement: LMChatAIButtonIconPlacement) {
        switch placement {
        case .start:
            semanticContentAttribute = .forceLeftToRight
        case .end:
            semanticContentAttribute = .forceRightToLeft
        }
    }
    
    // MARK: Button Creation
    public static func createButton(
        with title: String? = Constants.shared.strings.aiChatBotButtonText,
        image: UIImage? = Constants.shared.images.aiChatBotButton,
        textColor: UIColor? = Appearance.shared.colors.white,
        textFont: UIFont = .systemFont(ofSize: 14),
        backgroundColor: UIColor? = Appearance.shared.colors.aiChatBotButtonColor,
        cornerRadius: CGFloat = 20,
        iconPlacement: LMChatAIButtonIconPlacement = .start,
        spacing: CGFloat = 8,
        contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16),
        iconSize: CGSize = CGSize(width: 20, height: 20)
    ) -> LMChatAIButton {
        let button = LMChatAIButton()
        
        // Basic Setup
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = textFont
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        
        // Image Configuration
        if let image = image {
            let resizedIcon = resizeImage(image, targetSize: iconSize)
            button.setImage(resizedIcon, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.configureIconPlacement(iconPlacement)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setInsets(forContentPadding: contentInsets, imageTitlePadding: spacing)

        return button
    }
    // MARK: Actions
    @objc private func buttonTapped() {
        guard let props = props else { return }
        delegate?.didTapAIButton(self, props: props)
    }
    private static func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        }
    // MARK: Layout
    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width, height: max(44, size.height))
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .center
    }
}
