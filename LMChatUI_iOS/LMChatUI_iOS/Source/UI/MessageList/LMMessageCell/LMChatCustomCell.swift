//
//  LMChatCustomCell.swift
//  Pods
//
//  Created by Anurag Tyagi on 12/11/24.
//

@IBDesignable
open class LMChatCustomCell: LMChatMessageCell {
    
    public struct ContentModel {
        public let message: LMChatMessageListView.ContentModel.Message?
        public var isSelected: Bool = false
    }
    
    private let customMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "This is a custom view cell, modify it using LMUIComponent to generate your custom view"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Setup Views
    open override func setupViews() {
        super.setupViews()
        // Add the custom message label to the cell's container view
        contentView.addSubview(customMessageLabel)
        chatMessageView.chatProfileImageView.isHidden = true
        chatMessageView.usernameLabel.isHidden = true
    }
    
    // MARK: Setup Layouts
    open override func setupLayouts() {
        super.setupLayouts()
        // Add layout constraints for the custom message label
        NSLayoutConstraint.activate([
            customMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customMessageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            customMessageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: Configure
    open func setData(with data: ContentModel, index: IndexPath) {
        // You can customize this method to set additional data if needed
    }
}
