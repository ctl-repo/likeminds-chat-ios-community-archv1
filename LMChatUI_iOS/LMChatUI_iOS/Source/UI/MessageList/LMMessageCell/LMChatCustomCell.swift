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
    
    // MARK: configure
    open func setData(with data: ContentModel, index: IndexPath) {
    }
}
