//
//  LMChatMessageLoadingShimmerView.swift
//  Pods
//
//  Created by Anurag Tyagi on 28/10/24.
//


import Foundation

open class LMChatMessageLoadingShimmerViewCell: LMTableViewCell {
    
    open private(set) lazy var stackView: LMStackView = {
        let stack = LMStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 8
        return stack
    }()
    
    
    open override func setupViews() {
        super.setupViews()
        addSubview(stackView)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: stackView, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        
        contentView.setHeightConstraint(with: 60)
        
        self.containerView.backgroundColor = Appearance.shared.colors.backgroundColor
        
        let shimmer = LMChatMessageTypingShimmer()
        shimmer.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(shimmer)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set the contentView background color
        contentView.backgroundColor = Appearance.shared.colors.backgroundColor
    }
       
       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           contentView.backgroundColor = Appearance.shared.colors.backgroundColor
       }
       
    required public init?(coder: NSCoder) {
           super.init(coder: coder)
           contentView.backgroundColor = Appearance.shared.colors.backgroundColor
       }
}
