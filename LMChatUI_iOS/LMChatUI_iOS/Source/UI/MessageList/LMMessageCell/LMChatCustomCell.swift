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
    
    public var data: ContentModel?
    public var index: IndexPath?
    
    // MARK: Setup Views
    open override func setupViews() {
        super.setupViews()
        chatMessageView.chatProfileImageView.isHidden = true
        chatMessageView.usernameLabel.isHidden = true
    }
    
    open override func setupLayouts() {
        contentView.setWidthConstraint(with: 0)
        contentView.setHeightConstraint(with: 0)
    }
    
    // MARK: Configure
    open func setData(with data: ContentModel, index: IndexPath) {
        // You can customize this method to set additional data if needed
        self.data = data
        self.index = index
    }
}
