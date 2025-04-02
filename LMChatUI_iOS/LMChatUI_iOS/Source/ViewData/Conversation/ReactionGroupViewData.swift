//
//  ReactionGroupViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/03/25.
//

public class ReactionGroupViewData {
    public let memberUUID: [String]
    public let reaction: String
    public let count: Int
    
    public init(memberUUID: [String], reaction: String, count: Int) {
        self.memberUUID = memberUUID
        self.reaction = reaction
        self.count = count
    }
}
