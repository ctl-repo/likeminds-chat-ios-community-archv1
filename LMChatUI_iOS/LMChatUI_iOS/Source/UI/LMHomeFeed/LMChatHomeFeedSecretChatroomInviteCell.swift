//
//  LMHomeFeedSecretChatroomInviteCell.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

protocol LMChatHomeFeedSecretChatroomInviteCellDelegate: AnyObject {
    func didTapAcceptButton(
        in data: LMChatHomeFeedSecretChatroomInviteCell.ContentModel)
    func didTapRejectButton(
        in data: LMChatHomeFeedSecretChatroomInviteCell.ContentModel)
}

open class LMChatHomeFeedSecretChatroomInviteCell: LMTableViewCell {

    public struct ContentModel {
        public let chatroom: ChatroomViewData

        /// The timestamp when the invite was created.
        public let createdAt: Int64

        /// The unique identifier of the invite.
        public let id: Int

        /// The status of the invite.
        public let inviteStatus: Int

        /// The timestamp when the invite was last updated.
        public let updatedAt: Int64

        /// The member who sent the invite.
        public let inviteSender: MemberViewData

        /// The member who received the invite.
        public let inviteReceiver: MemberViewData

        public init(
            chatroom: ChatroomViewData, createdAt: Int64, id: Int,
            inviteStatus: Int, updatedAt: Int64, inviteSender: MemberViewData,
            inviteReceiver: MemberViewData
        ) {
            self.chatroom = chatroom
            self.createdAt = createdAt
            self.id = id
            self.inviteStatus = inviteStatus
            self.updatedAt = updatedAt
            self.inviteSender = inviteSender
            self.inviteReceiver = inviteReceiver
        }
    }

    public var data: ContentModel?
    weak var delegate: LMChatHomeFeedSecretChatroomInviteCellDelegate?

    // MARK: UI Elements
    open private(set) lazy var chatroomView: LMChatHomeFeedChatroomView = {
        let view = LMUIComponents.shared.homeFeedChatroomView.init()
            .translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        return view
    }()

    open private(set) lazy var sepratorView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()

    public let rejectButton: LMButton = {
        let button = LMButton(type: .system)
            .translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.crossIcon, for: .normal)
        button.tintColor = Appearance.shared.colors.gray102

        // Make the background clear or white; up to your design choice
        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.setInsets(forContentPadding: .zero, imageTitlePadding: .zero)
        return button
    }()

    public let acceptButton: LMButton = {
        let button = LMButton(type: .system)
            .translatesAutoresizingMaskIntoConstraints()
        button.setImage(UIImage.strokedCheckmark, for: .normal)
        button.tintColor = Appearance.shared.colors.appTintColor

        // Make the background clear or white; up to your design choice
        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.setInsets(forContentPadding: .zero, imageTitlePadding: .zero)
        return button
    }()

    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()

        contentView.addSubview(containerView)
        containerView.addSubview(chatroomView)
        chatroomView.chatroomContainerStackView.addArrangedSubview(rejectButton)
        chatroomView.chatroomContainerStackView.addArrangedSubview(acceptButton)
        containerView.addSubview(sepratorView)
    }

    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()

        contentView.pinSubView(subView: containerView)
        NSLayoutConstraint.activate([
            chatroomView.topAnchor.constraint(equalTo: containerView.topAnchor),
            chatroomView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor),
            chatroomView.bottomAnchor.constraint(
                equalTo: sepratorView.topAnchor),

            sepratorView.leadingAnchor.constraint(
                equalTo: chatroomView.chatroomImageView.leadingAnchor,
                constant: 5),
            sepratorView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor),
            sepratorView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor),
            sepratorView.heightAnchor.constraint(equalToConstant: 1),

            acceptButton.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor, constant: -16),
            acceptButton.centerYAnchor.constraint(
                equalTo: chatroomView.chatroomContainerStackView.centerYAnchor),
            acceptButton.widthAnchor.constraint(equalToConstant: 50),
            acceptButton.heightAnchor.constraint(equalToConstant: 50),

            rejectButton.trailingAnchor.constraint(
                equalTo: acceptButton.leadingAnchor, constant: -8),
            rejectButton.centerYAnchor.constraint(
                equalTo: acceptButton.centerYAnchor),
            rejectButton.widthAnchor.constraint(equalToConstant: 50),
            rejectButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()

        sepratorView.backgroundColor = Appearance.shared.colors.gray4
        backgroundColor = Appearance.shared.colors.clear
        contentView.backgroundColor = Appearance.shared.colors.clear
    }

    open override func setupActions() {
        super.setupActions()
        rejectButton.addTarget(
            self, action: #selector(didTapRejectButton), for: .touchUpInside)
        acceptButton.addTarget(
            self, action: #selector(didTapAcceptButton), for: .touchUpInside)
    }

    @objc private func didTapRejectButton() {
        guard let data = data else { return }
        delegate?.didTapRejectButton(in: data)
    }

    @objc private func didTapAcceptButton() {
        guard let data = data else { return }
        delegate?.didTapAcceptButton(in: data)
    }

    // MARK: configure
    open func configure(with data: ContentModel) {
        self.data = data
        setChatroomData(data)
    }

    open func setChatroomData(_ data: ContentModel) {
        chatroomView.lastMessageLabel.text =
            "\(data.inviteSender.name ?? "") sent you an invite"
        chatroomView.timestampLabel.isHidden = true
        chatroomView.chatroomCountBadgeLabel.isHidden = true

        chatroomView.chatroomName(data.chatroom.header ?? "")

        chatroomView.muteIconImageView.isHidden = true
        chatroomView.announcementIconImageView.isHidden = true
        chatroomView.lockIconImageView.isHidden = true
        chatroomView.tagIconImageView.isHidden = true
        chatroomView.chatroomCountBadgeLabel.isHidden = true

        let placeholder = UIImage.generateLetterImage(
            name: data.chatroom.title.components(separatedBy: " ").first ?? "")
        if let imageUrl = data.chatroom.chatroomImageUrl,
            let url = URL(string: imageUrl)
        {
            chatroomView.chatroomImageView.kf.setImage(
                with: url, placeholder: placeholder,
                options: [.fromMemoryCacheOrRefresh])
        } else {
            chatroomView.chatroomImageView.image = placeholder
        }
    }

}
