//
//  LMAIChatButton.swift
//  LikeMindsChatCore
//
//  Created by Arpit Verma on 11/04/25.
//

import UIKit
import LikeMindsChatUI

// Props class for LMChatAIButton
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

// Supporting Types
public enum IconPlacement {
    case start
    case end
}

// Delegate Protocol
public protocol LMChatAIButtonDelegate: AnyObject {
    func didTapAIButton(_ button: LMChatAIButton)
    func didTapAIButtonWithProps(_ button: LMChatAIButton, props: LMChatAIButtonProps)
}

@IBDesignable
open class LMChatAIButton: LMButton {
    // MARK: - Properties
    public weak var delegate: LMChatAIButtonDelegate?
    public var props: LMChatAIButtonProps?
    
    // Default values
    private let defaultText = "AI Bot"
    private let defaultTextSize: CGFloat = 14
    private let defaultTextColor = UIColor.white
    private let defaultBackgroundColor = UIColor(red: 2/255, green: 13/255, blue: 66/255, alpha: 1.0)
    private let defaultBorderRadius: CGFloat = 28
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultAppearance()
    }
    
    @available(*, unavailable, renamed: "init(frame:)")
    public required init?(coder: NSCoder) {
        fatalError("\(#function) not implemented in \(#filePath)")
    }
    
    // MARK: - Setup
    private func setupDefaultAppearance() {
        setTitle(defaultText, for: .normal)
        titleLabel?.font = .systemFont(ofSize: defaultTextSize)
        setTitleColor(defaultTextColor, for: .normal)
        backgroundColor = defaultBackgroundColor
        layer.cornerRadius = defaultBorderRadius
        
        // Add target for tap
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // MARK: - Customization Methods
    open func setText(_ text: String) {
        setTitle(text, for: .normal)
    }
    
    open func setTextSize(_ size: CGFloat) {
        titleLabel?.font = .systemFont(ofSize: size)
    }
    
    open func setTextColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
    }
    
    open func setBackgroundColor(_ color: UIColor) {
        backgroundColor = color
    }
    
    open func setBorderRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
    }
    
    open func setIcon(_ image: UIImage?, placement: IconPlacement = .start) {
        setImage(image, for: .normal)
        switch placement {
        case .start:
            semanticContentAttribute = .forceLeftToRight
        case .end:
            semanticContentAttribute = .forceRightToLeft
        }
    }
    
    // MARK: - Props Methods
    open func setProps(_ props: LMChatAIButtonProps) {
        self.props = props
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        delegate?.didTapAIButton(self)
        if let props = props {
            delegate?.didTapAIButtonWithProps(self, props: props)
        }
    }
}
