//
//  LMChatCustomCell.swift
//  Pods
//
//  Created by Anurag Tyagi on 12/11/24.
//

@IBDesignable
open class LMChatCustomCell: LMChatMessageCell {
    public var index: IndexPath?
    
    // MARK: Setup Views
    open override func setupViews() {
        super.setupViews()
//        chatMessageView.chatProfileImageView.isHidden = true
//        chatMessageView.usernameLabel.isHidden = true
    }
    
    // MARK: Configure
    open override func setData(with data: ContentModel, index: IndexPath) {
        // You can customize this method to set additional data if needed
        self.data = data
        self.index = index
        chatMessageView.chatProfileImageView.isHidden = false
//        chatMessageView.chatProfileImageView.imageView.kf.setImage(with: URL(string: data.message.member?.imageUrl ?? ""), placeholder: UIImage.generateLetterImage(name: data.message.createdBy?.components(separatedBy: " ").first ?? ""))
        chatMessageView.usernameLabel.isHidden = false
        chatMessageView.setDataView(data, index: index)
        chatMessageView.delegate = self
    }
}
