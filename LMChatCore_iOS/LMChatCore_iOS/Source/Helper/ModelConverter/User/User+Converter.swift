//
//  User+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//
import LikeMindsChatData
import LikeMindsChatUI

extension User {
    /**
     Converts a `User` instance into a `UserViewData`.

     - Returns: A `UserViewData` populated with the data from this `User`.
     */
    public func toViewData() -> UserViewData {
        var sdkClientInfo = self.sdkClientInfo?.toViewData()
        
        return UserViewData(
            id: self.id,
            imageUrl: self.imageUrl,
            name: self.name,
            organisationName: self.organisationName,
            userUniqueID: self.userUniqueID,
            uuid: self.uuid,
            isGuest: self.isGuest,
            isDeleted: self.isDeleted,
            isOwner: self.isOwner,
            customTitle: self.customTitle,
            state: self.state,
            updatedAt: self.updatedAt,
            sdkClientInfo: sdkClientInfo,  // Assuming `SDKClientInfo` has a `toViewData` method
            roles: self.roles?.compactMap{ $0.toUserRoleViewData() } ?? []  // Assuming `UserRole` has a `toViewData` method
        )
    }
}

extension UserViewData {
    /**
     Converts a `UserViewData` instance back into a `User`.

     - Returns: A `User` created using the data from this `UserViewData`.
     */
    public func toUser() -> User {
        var user = User(id: self.id, imageUrl: self.imageUrl)
        user.name = self.name
        user.organisationName = self.organisationName
        user.userUniqueID = self.userUniqueID
        user.uuid = self.uuid
        user.isGuest = self.isGuest
        user.isDeleted = self.isDeleted
        user.isOwner = self.isOwner
        user.customTitle = self.customTitle
        user.state = self.state
        user.updatedAt = self.updatedAt
        user.sdkClientInfo = self.sdkClientInfo?.toSDKClientInfo()  // Assuming `SDKClientInfoViewData` has a `toSDKClientInfo` method
        user.roles = self.roles?.compactMap { $0.toUserRole() }  // Assuming `UserRoleViewData` has a `toUserRole` method
        return user
    }
}
