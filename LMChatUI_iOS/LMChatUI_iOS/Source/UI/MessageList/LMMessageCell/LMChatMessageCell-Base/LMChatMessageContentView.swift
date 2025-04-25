//
//  LMChatMessageContentView.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 22/03/24.
//

import Foundation
import Kingfisher
enum CustomEventNames: String {
    case companyInfo = "Company_Info"
    case buyStock = "Buy_Stock"
    case sellStock = "Sell_Stock"
    case defaultValue = "Default_Value"
}
public protocol LMChatMessageContentViewDelegate: AnyObject {
    func clickedOnReaction(_ reaction: String)
    func clickedOnAttachment(_ url: String)
    func didTapOnProfileLink(route: String)
    func didTapOnReplyPreview()
    func didTapButton(btnName: String, metaData: [String: Any])
}

extension LMChatMessageContentViewDelegate {
    public func clickedOnReaction(_ reaction: String) {}
    public func clickedOnAttachment(_ url: String) {}
    func didTapOnProfileLink(route: String) {}
    public func didTapButton(btnName: String, metaData: [String: Any]) {}
}

@IBDesignable
open class LMChatMessageContentView: LMView {

    open private(set) lazy var bubbleView: LMChatMessageBubbleView = {
        return LMUIComponents.shared
            .messageBubbleView
            .init()
            .translatesAutoresizingMaskIntoConstraints()
    }()
    
    open private(set) lazy var chatProfileImageContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.alignment = .bottom
        view.spacing = 10
        view.addArrangedSubview(chatProfileImageView)
        return view
    }()
    
    open private(set) lazy var chatProfileImageView: LMChatProfileView = {
        let image = LMUIComponents.shared.chatProfileView.init().translatesAutoresizingMaskIntoConstraints()
        image.isUserInteractionEnabled = true
        return image
    }()
    
    open private(set) lazy var reactionsView: LMChatMessageReactionsView = {
        let view = LMUIComponents.shared.messageReactionView.init().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var reactionContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 0
        view.addArrangedSubview(reactionsView)
        return view
    }()
    var stopLossLbl : LMTextView = {
        let label =  LMTextView()
            .translatesAutoresizingMaskIntoConstraints()
        label.isScrollEnabled = false
        label.font = Appearance.shared.fonts.textFont1
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .left
        label.isEditable = false
        label.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        label.text = ""
        return label
    }()
    var entryPriceLbl : LMTextView = {
        let label =  LMTextView()
            .translatesAutoresizingMaskIntoConstraints()
        label.isScrollEnabled = false
        label.font = Appearance.shared.fonts.textFont1
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .left
        label.isEditable = false
        label.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        label.text = ""
        return label
    }()
    var targetPriceLbl : LMTextView = {
        let label =  LMTextView()
            .translatesAutoresizingMaskIntoConstraints()
        label.isScrollEnabled = false
        label.font = Appearance.shared.fonts.textFont1
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .left
        label.isEditable = false
        label.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        label.text = ""
        return label
    }()
    
    open private(set) lazy var stockInfo: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 2
        view.addArrangedSubview(stopLossLbl)
        view.addArrangedSubview(entryPriceLbl)
        view.addArrangedSubview(targetPriceLbl)
        return view
    }()
    open var companyInfoButtonTitle: String = "Company Info"
    open private(set) lazy var companyInfoButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setTitle(companyInfoButtonTitle, for: .normal)
        button.titleLabel?.font = Appearance.shared.fonts.buttonFont3
        button.tintColor = Appearance.shared.colors.blueGray
//        button.sizeToFit()
        button.setInsets(forContentPadding: UIEdgeInsets(
            top: 8, left: 16, bottom: 8, right: 16), imageTitlePadding: 0)
        button.backgroundColor = Appearance.shared.colors.gray155
        button.setTitleColor(Appearance.shared.colors.black, for: .normal)
        button.cornerRadius(with: 8)
        button.setHeightConstraint(with: 40)
        button.setWidthConstraint(with: 116)
        button.addTarget(self, action: #selector(companyInfoClicked), for: .touchUpInside)
        return button
    }()
    open var buyButtonTitle: String = "Buy"
    open private(set) lazy var buyButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setTitle(buyButtonTitle, for: .normal)
        button.titleLabel?.font = Appearance.shared.fonts.buttonFont3
        button.tintColor = Appearance.shared.colors.blueGray
//        button.sizeToFit()
        button.setInsets(forContentPadding: UIEdgeInsets(
            top: 8, left: 16, bottom: 8, right: 16), imageTitlePadding: 0)
        button.backgroundColor = Appearance.shared.colors.buyButtonColor
        button.setTitleColor(Appearance.shared.colors.buyButtonTextColor, for: .normal)
        button.cornerRadius(with: 8)
        button.setHeightConstraint(with: 40)
        button.setWidthConstraint(with: 56)
        button.addTarget(self, action: #selector(buyBtnClicked), for: .touchUpInside)
        return button
    }()
    open var sellButtonTitle: String = "Sell"
    open private(set) lazy var sellButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setTitle(sellButtonTitle, for: .normal)
        button.titleLabel?.font = Appearance.shared.fonts.buttonFont3
        button.tintColor = Appearance.shared.colors.blueGray
//        button.sizeToFit()
        button.setInsets(forContentPadding: UIEdgeInsets(
            top: 8, left: 16, bottom: 8, right: 16), imageTitlePadding: 0)
        button.backgroundColor = Appearance.shared.colors.sellButtonColor
        button.setTitleColor(Appearance.shared.colors.sellButtonTextColor, for: .normal)
        button.setHeightConstraint(with: 40)
        button.setWidthConstraint(with: 56)
        button.cornerRadius(with: 8)
        button.addTarget(self, action: #selector(sellBtnClicked), for: .touchUpInside)
        return button
    }()
    open private(set) lazy var emptyView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    open private(set) lazy var companyStack: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .trailing
        view.spacing = 4
        view.addArrangedSubview(emptyView)
        view.addArrangedSubview(companyInfoButton)
        view.addArrangedSubview(buyButton)
        view.addArrangedSubview(sellButton)
        view.setHeightConstraint(with: 48)
        return view
    }()

    open private(set) lazy var replyMessageView: LMChatMessageReplyPreview = {[unowned self] in
        let view = LMUIComponents.shared.messageReplyView.init().translatesAutoresizingMaskIntoConstraints()
        view.widthAnchor.constraint(equalToConstant: widthViewSize).isActive = true
        return view
    }()
    
    var textLabel: LMTextView = {
        let label =  LMTextView()
            .translatesAutoresizingMaskIntoConstraints()
        label.isScrollEnabled = false
        label.font = Appearance.shared.fonts.textFont1
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .left
        label.isEditable = false
        label.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        label.text = ""
        return label
    }()
    
    open private(set) lazy var usernameLabel: LMLabel = {
        let label =  LMLabel()
            .translatesAutoresizingMaskIntoConstraints()
        label.numberOfLines = 1
        label.font = Appearance.shared.fonts.headingLabel
        label.textColor = Appearance.shared.colors.red
        label.paddingLeft = 4
        label.paddingTop = 2
        label.text = ""
        label.isUserInteractionEnabled = true
        label.widthAnchor.constraint(lessThanOrEqualToConstant: widthViewSize).isActive = true
        return label
    }()
    
    open private(set) lazy var cancelRetryContainerStackView: LMStackView = {[unowned self] in
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 0
        view.addArrangedSubview(loaderView)
        view.addArrangedSubview(retryView)
        return view
    }()
    
    open private(set) lazy var loaderView: LMAttachmentLoaderView = {
        let view = LMUIComponents.shared.attachmentLoaderView.init().translatesAutoresizingMaskIntoConstraints()
        view.setHeightConstraint(with: 44)
        view.setWidthConstraint(with: 44)
        view.cornerRadius(with: 22)
        view.isHidden = true
        return view
    }()
    
    open private(set) lazy var retryView: LMChatAttachmentUploadRetryView = {
        let view = LMUIComponents.shared.attachmentRetryView.init().translatesAutoresizingMaskIntoConstraints()
        view.isHidden = true
        return view
    }()
    
    var bubbleLeadingConstraint: NSLayoutConstraint?
    var bubbleTrailingConstraint: NSLayoutConstraint?
    
    var outgoingbubbleLeadingConstraint: NSLayoutConstraint?
    var outgoingbubbleTrailingConstraint: NSLayoutConstraint?
    
    var replyViewWidthConstraint: NSLayoutConstraint?
    
    weak var delegate: LMChatMessageContentViewDelegate?
    var dataView: LMChatMessageCell.ContentModel?
    
    open var textLabelFont: UIFont = Appearance.shared.fonts.textFont1
    open var deletedTextLabelFont: UIFont = Appearance.shared.fonts.italicFont16
    open var textLabelColor: UIColor = Appearance.shared.colors.black
    open var deletedTextLabelColor: UIColor = Appearance.shared.colors.textColor
    
    @objc func didTapOnProfileLink(_ gesture: UITapGestureRecognizer) {
        delegate?.didTapOnProfileLink(route: Constants.getProfileRoute(withUUID: self.dataView?.message.member?.userUniqueId ?? "") )
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        let bubble = createBubbleView()
        bubbleView = bubble
        addSubview(bubble)
        addSubview(chatProfileImageContainerStackView)
        addSubview(reactionContainerStackView)
        bubble.addArrangeSubview(usernameLabel)
        bubble.addArrangeSubview(replyMessageView)
        bubble.addArrangeSubview(textLabel)
        bubble.addArrangeSubview(stockInfo)
        bubble.addArrangeSubview(companyStack)
        backgroundColor = .clear
        reactionsView.isHidden = true
        replyMessageView.isHidden = true
        stockInfo.isHidden = true
        companyStack.isHidden = true
        reactionsView.delegate = self
        
        let tapImageGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnProfileLink))
        tapImageGesture.numberOfTapsRequired = 1
        let tapNameLabelGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnProfileLink))
        tapNameLabelGesture.numberOfTapsRequired = 1
        chatProfileImageView.addGestureRecognizer(tapImageGesture)
        usernameLabel.addGestureRecognizer(tapNameLabelGesture)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            reactionContainerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            reactionContainerStackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            reactionContainerStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            chatProfileImageContainerStackView.topAnchor.constraint(equalTo: topAnchor),
            chatProfileImageContainerStackView.bottomAnchor.constraint(equalTo: reactionContainerStackView.topAnchor, constant: 2),
            chatProfileImageContainerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            bubbleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            bubbleView.bottomAnchor.constraint(equalTo: chatProfileImageContainerStackView.bottomAnchor, constant: -2),
            companyStack.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8)
        ])
        
         bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: chatProfileImageContainerStackView.trailingAnchor)
         bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -35)
        
        outgoingbubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: chatProfileImageContainerStackView.trailingAnchor, constant: 40)
        outgoingbubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor)
        
    }
    
    open func createBubbleView() -> LMChatMessageBubbleView {
        let bubble = LMUIComponents.shared
            .messageBubbleView
            .init()
            .translatesAutoresizingMaskIntoConstraints()
        bubble.backgroundColor = Appearance.shared.colors.clear
        return bubble
    }
    
    open func setDataView(_ data: LMChatMessageCell.ContentModel, index: IndexPath) {
        dataView = data
        self.textLabel.isUserInteractionEnabled = true
        
        let formattedString =  GetAttributedTextWithRoutes.getAttributedText(from: (data.message.message ?? "").trimmingCharacters(in: .whitespacesAndNewlines), font: textLabelFont, withHighlightedColor: Appearance.Colors.shared.linkColor, withTextColor: textLabelColor);
        
        formattedString.applyBoldFormat()

        self.textLabel.attributedText = formattedString
        
        
        if let widgetData = data.message.widget {
            let metaData = widgetData.metadata
            if let isCustom = metaData?["customWidgetType"] as? String, isCustom == "FinXRecommendation" {
                let dataDict = metaData?["searchRsp"] as? [String: Any]
                if let stockName = dataDict?["SecName"] as? String {
                    let tempFormatString =  GetAttributedTextWithRoutes.getAttributedText(from: stockName, font: textLabelFont, withHighlightedColor: Appearance.Colors.shared.linkColor, withTextColor: textLabelColor);
                    tempFormatString.applyBoldFormat()
                    self.textLabel.attributedText = tempFormatString
                }
                if let stopLossPrice = metaData?["slPrice"] as? String {
                    let tempFormatString =  GetAttributedTextWithRoutes.getAttributedText(from: "Stop Loss".trimmingCharacters(in: .whitespacesAndNewlines), font: Appearance.shared.fonts.subHeadingFont1, withHighlightedColor: Appearance.Colors.shared.linkColor, withTextColor: textLabelColor);
                    tempFormatString.applyBoldFormat()
                    let tempFormatString2 =  GetAttributedTextWithRoutes.getAttributedText(from: "\(stopLossPrice)".trimmingCharacters(in: .whitespacesAndNewlines), font: Appearance.shared.fonts.buttonFont3, withHighlightedColor: Appearance.Colors.shared.linkColor, withTextColor: textLabelColor);
                    tempFormatString2.applyBoldFormat()
                    let combinedAttText = NSMutableAttributedString()
                    combinedAttText.append(tempFormatString)
                    combinedAttText.append(NSAttributedString(string: "\n"))
                    combinedAttText.append(tempFormatString2)
                    self.stopLossLbl.attributedText = combinedAttText
                    self.stopLossLbl.isHidden = self.stopLossLbl.text.isEmpty
                    self.stockInfo.isHidden = false
                }
                if let entryPrice = metaData?["entryPrice"] as? String {
                    let tempFormatString =  GetAttributedTextWithRoutes.getAttributedText(from: "Entry Price".trimmingCharacters(in: .whitespacesAndNewlines), font: Appearance.shared.fonts.subHeadingFont1, withHighlightedColor: Appearance.Colors.shared.linkColor, withTextColor: textLabelColor);
                    tempFormatString.applyBoldFormat()
                    let tempFormatString2 =  GetAttributedTextWithRoutes.getAttributedText(from: "\(entryPrice)".trimmingCharacters(in: .whitespacesAndNewlines), font: Appearance.shared.fonts.buttonFont3, withHighlightedColor: Appearance.Colors.shared.linkColor, withTextColor: textLabelColor);
                    tempFormatString2.applyBoldFormat()
                    let combinedAttText = NSMutableAttributedString()
                    combinedAttText.append(tempFormatString)
                    combinedAttText.append(NSAttributedString(string: "\n"))
                    combinedAttText.append(tempFormatString2)
                    self.entryPriceLbl.attributedText = combinedAttText
                    self.entryPriceLbl.isHidden = self.entryPriceLbl.text.isEmpty
                    self.stockInfo.isHidden = false
                }
                if let targetPrice = metaData?["targetPrice"] as? String {
                    let tempFormatString =  GetAttributedTextWithRoutes.getAttributedText(from: "Target Price".trimmingCharacters(in: .whitespacesAndNewlines), font: Appearance.shared.fonts.subHeadingFont1, withHighlightedColor: Appearance.Colors.shared.linkColor, withTextColor: textLabelColor);
                    tempFormatString.applyBoldFormat()
                    let tempFormatString2 =  GetAttributedTextWithRoutes.getAttributedText(from: "\(targetPrice)".trimmingCharacters(in: .whitespacesAndNewlines), font: Appearance.shared.fonts.buttonFont3, withHighlightedColor: Appearance.Colors.shared.linkColor, withTextColor: textLabelColor);
                    tempFormatString2.applyBoldFormat()
                    let combinedAttText = NSMutableAttributedString()
                    combinedAttText.append(tempFormatString)
                    combinedAttText.append(NSAttributedString(string: "\n"))
                    combinedAttText.append(tempFormatString2)
                    self.targetPriceLbl.attributedText = combinedAttText
                    self.targetPriceLbl.isHidden = self.targetPriceLbl.text.isEmpty
                    self.stockInfo.isHidden = false
                }
                if let isBuy = metaData?["isBuy"] as? Bool {
                    if isBuy {
                        buyButton.isHidden = false
                        sellButton.isHidden = true
                    } else {
                        buyButton.isHidden = true
                        sellButton.isHidden = false
                    }
                    companyInfoButton.isHidden = false
                    companyStack.isHidden = false
                }
            }
        }
        
        self.textLabel.isHidden = self.textLabel.text.isEmpty
        setTimestamps(data)
        let isIncoming = data.message.isIncoming ?? true
        bubbleView.bubbleFor(isIncoming)
        
        if !isIncoming {
            chatProfileImageView.isHidden = true
            usernameLabel.isHidden = true
            bubbleLeadingConstraint?.isActive = false
            bubbleTrailingConstraint?.isActive = false
            outgoingbubbleLeadingConstraint?.isActive = true
            outgoingbubbleTrailingConstraint?.isActive = true
        } else {
            chatProfileImageView.imageView.kf.setImage(with: URL(string: data.message.member?.imageUrl ?? ""), placeholder: UIImage.generateLetterImage(name: data.message.createdBy?.components(separatedBy: " ").first ?? ""))
            chatProfileImageView.isHidden = false
            messageByName(data)
            usernameLabel.isHidden = false
            bubbleLeadingConstraint?.isActive = true
            bubbleTrailingConstraint?.isActive = true
            outgoingbubbleLeadingConstraint?.isActive = false
            outgoingbubbleTrailingConstraint?.isActive = false
        }
        
        if data.message.isDeleted == true {
            deletedConversationView(data)
            textLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        } else {
            replyView(data)
            reactionsView(data)
        }
        if (data.message.attachments?.isEmpty == false || data.message.ogTags != nil || data.message.replyConversation != nil) && data.message.isDeleted == false {
            textLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        } else {
            textLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        bubbleView.layoutIfNeeded()
    }
    
    open func setTimestamps(_ data: LMChatMessageCell.ContentModel) {
        let edited = data.message.isEdited == true ? "Edited \(Constants.shared.strings.dot) " : ""
        let timestamp = edited + (data.message.createdTime ?? "")
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: timestamp))
        if data.message.isIncoming == false {
            bubbleView.updateTimestampLabelTrailingConstraint()
            let image = ((data.message.messageStatus == .sent) ? Constants.shared.images.checkmarkIcon.withSystemImageConfig(pointSize: 9)?.withTintColor(Appearance.shared.colors.textColor) :  Constants.shared.images.clockIcon.withSystemImageConfig(pointSize: 9)?.withTintColor(Appearance.shared.colors.textColor)) ?? UIImage()
            let textAtt = NSTextAttachment(image: image)
            textAtt.bounds = CGRect(x: 0, y: -1, width: 11, height: 11)
            attributedText.append(NSAttributedString(string: " "))
            attributedText.append(NSAttributedString(attachment: textAtt))
        } else {
            bubbleView.updateTimestampLabelTrailingConstraint(withConstant: -10)
        }
        bubbleView.timestampLabel.attributedText = attributedText
        bubbleView.updateTimestampLabelTopConstraint(withConstant: textLabel.isHidden ? 6 : 0)
    }
    
    open func messageByName(_ data: LMChatMessageCell.ContentModel) {
        
        let myAttribute = [ NSAttributedString.Key.font: Appearance.shared.fonts.headingLabel, .foregroundColor: Appearance.shared.colors.red]
        let myString = NSMutableAttributedString(string: "\(data.message.createdBy ?? "")", attributes: myAttribute )
        if let memberTitle = data.message.memberTitle {
            let myAttribute2 = [ NSAttributedString.Key.font: Appearance.shared.fonts.buttonFont1, .foregroundColor: Appearance.shared.colors.textColor]
            myString.append(NSAttributedString(string: " \(Constants.shared.strings.dot) \(memberTitle)", attributes: myAttribute2))
        }
        usernameLabel.attributedText = myString
    }
    
    open func deletedConversationView(_ data: LMChatMessageCell.ContentModel) {
        self.textLabel.attributedText = NSAttributedString(string: "")
        self.textLabel.font = deletedTextLabelFont
        self.textLabel.textColor = deletedTextLabelColor
        self.textLabel.text = Constants.shared.strings.messageDeleteText
        self.textLabel.isUserInteractionEnabled = false
        self.textLabel.isHidden = false
    }

    open func replyView(_ data: LMChatMessageCell.ContentModel) {
        if let repliedMessage = data.message.replyConversation {
            replyMessageView.isHidden = false
            replyMessageView.closeReplyButton.isHidden = true
            let message = repliedMessage.isDeleted == true ? Constants.shared.strings.messageDeleteText : repliedMessage.message
            replyMessageView.setData(.init(username: repliedMessage.createdBy, replyMessage: message, attachmentsUrls: repliedMessage.attachments?.compactMap({($0.thumbnailUrl, $0.url, $0.type)}), messageType: data.message.messageType, isDeleted: repliedMessage.isDeleted))
            replyMessageView.onClickReplyPreview = {[weak self] in
                self?.delegate?.didTapOnReplyPreview()
            }
        } else {
            replyMessageView.isHidden = true
        }
    }
    
    open func reactionsView(_ data: LMChatMessageCell.ContentModel) {
        if let reactions = data.message.reactions, reactions.count > 0 {
            reactionsView.isHidden = false
            reactionsView.setData(reactions)
        } else {
            reactionsView.isHidden = true
        }
    }
    
    func prepareToResuse() {
        reactionsView.isHidden = true
        replyMessageView.isHidden = true
        textLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}

extension LMChatMessageContentView: LMChatMessageReactionsViewDelegate {
    
    public func clickedOnReaction(_ reaction: String) {
        delegate?.clickedOnReaction(reaction)
    }
}
extension LMChatMessageContentView {
    @objc func buyBtnClicked(_ sender: UIButton) {
        delegate?.didTapButton(btnName: CustomEventNames.buyStock.rawValue, metaData: dataView?.message.widget?.metadata ?? [:])
    }
    @objc func companyInfoClicked(_ sender: UIButton) {
        delegate?.didTapButton(btnName: CustomEventNames.companyInfo.rawValue, metaData: dataView?.message.widget?.metadata ?? [:])
    }
    @objc func sellBtnClicked(_ sender: UIButton) {
        delegate?.didTapButton(btnName: CustomEventNames.sellStock.rawValue, metaData: dataView?.message.widget?.metadata ?? [:])
    }
}

