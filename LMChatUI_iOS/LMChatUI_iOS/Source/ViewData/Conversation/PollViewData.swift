//
//  PollViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/// A view-data class that mirrors the properties of `Poll`.
///
/// This class is mutable and can be used in UI layers or intermediate layers
/// where flexibility in modifying properties is required.
public class PollViewData {
    // MARK: - Properties
    public var id: String?
    public var text: String?
    public var isSelected: Bool?
    public var percentage: Double?
    public var subText: String?
    public var noVotes: Int?
    public var member: UserViewData?
    public var userId: String?
    public var conversationId: String?

    // MARK: - Initializer
    /**
     Initializes a new `PollViewData`.

     - Parameters:
       - id: The unique identifier of the poll.
       - text: The text of the poll option.
       - isSelected: Indicates if the option is selected.
       - percentage: The percentage of votes received.
       - subText: Any additional text associated with the poll.
       - noVotes: The number of votes received.
       - member: The user who created the poll option.
       - userId: The ID of the user who created the poll option.
       - conversationId: The ID of the conversation this poll belongs to.
     */
    public init(
        id: String?,
        text: String?,
        isSelected: Bool?,
        percentage: Double?,
        subText: String?,
        noVotes: Int?,
        member: UserViewData?,
        userId: String?,
        conversationId: String?
    ) {
        self.id = id
        self.text = text
        self.isSelected = isSelected
        self.percentage = percentage
        self.subText = subText
        self.noVotes = noVotes
        self.member = member
        self.userId = userId
        self.conversationId = conversationId
    }
}
