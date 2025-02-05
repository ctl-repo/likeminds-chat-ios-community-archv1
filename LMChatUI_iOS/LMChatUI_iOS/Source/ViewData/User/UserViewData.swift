//
//  UserViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/// A view-data class that mirrors the properties of `User`.
///
/// This class is mutable and can be used in UI layers or intermediate layers
/// where flexibility in modifying properties is required.
public class UserViewData {
    // MARK: - Properties
    public var id: String?
    public var imageUrl: String?
    public var name: String?
    public var organisationName: String?
    public var userUniqueID: String?
    public var uuid: String?
    public var isGuest: Bool = false
    public var isDeleted: Bool?
    public var isOwner: Bool?
    public var customTitle: String?
    public var state: Int?
    public var updatedAt: Int?
    public var sdkClientInfo: SDKClientInfoViewData?
    public var roles: [UserRoleViewData]?

    // MARK: - Initializer
    /**
     Initializes a new `UserViewData`.

     - Parameters:
       - id: The unique identifier of the user.
       - imageUrl: The profile image URL of the user.
       - name: The name of the user.
       - organisationName: The name of the organization the user belongs to.
       - userUniqueID: The unique ID for the user.
       - uuid: The UUID for the user.
       - isGuest: Indicates if the user is a guest.
       - isDeleted: Indicates if the user is deleted.
       - isOwner: Indicates if the user is the owner of a resource.
       - customTitle: A custom title for the user.
       - state: The state of the user.
       - updatedAt: The last updated timestamp for the user.
       - sdkClientInfo: SDK-related client information.
       - roles: The roles associated with the user.
     */
    public init(
        id: String?,
        imageUrl: String?,
        name: String?,
        organisationName: String?,
        userUniqueID: String?,
        uuid: String?,
        isGuest: Bool,
        isDeleted: Bool?,
        isOwner: Bool?,
        customTitle: String?,
        state: Int?,
        updatedAt: Int?,
        sdkClientInfo: SDKClientInfoViewData?,
        roles: [UserRoleViewData]?
    ) {
        self.id = id
        self.imageUrl = imageUrl
        self.name = name
        self.organisationName = organisationName
        self.userUniqueID = userUniqueID
        self.uuid = uuid
        self.isGuest = isGuest
        self.isDeleted = isDeleted
        self.isOwner = isOwner
        self.customTitle = customTitle
        self.state = state
        self.updatedAt = updatedAt
        self.sdkClientInfo = sdkClientInfo
        self.roles = roles
    }
}
