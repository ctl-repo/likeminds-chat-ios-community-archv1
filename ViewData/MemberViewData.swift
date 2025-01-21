//
//  MemberViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/**
 A view-data class that mirrors the properties of `Member`.

 This class can be used in UI layers or other scenarios where a mutable,
 class-based model is preferred. It keeps the domain/networking-focused
 `Member` (with its decoding logic) separate from any UI or intermediate logic.
 */
public class MemberViewData {
    
    // MARK: - Properties
    
    public var id: String?
    public var userUniqueId: String?
    public var name: String?
    public var imageUrl: String?
    public var questionAnswers: [QuestionViewData]?
    public var state: Int?
    public var isGuest: Bool = false
    public var customIntroText: String?
    public var customClickText: String?
    public var memberSince: String?
    public var communityName: String?
    public var isOwner: Bool = false
    public var isDeleted: Bool?
    public var customTitle: String?
    public var menu: [MemberActionViewData]?
    public var communityId: String?
    public var chatroomId: String?
    public var route: String?
    public var attendingStatus: Bool?
    public var hasProfileImage: Bool?
    public var updatedAt: Int?
    public var sdkClientInfo: SDKClientInfoViewData?
    public var uuid: String?
    public var roles: [UserRoleViewData]?
    
    // MARK: - Initializer
    
    /// Default initializer; properties may be set as needed after creation.
    public init() {}
}
