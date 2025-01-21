//
//  UserConverter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//
import LikeMindsChatData
import LikeMindsChatUI

extension Member {
    /**
     Converts a `Member` instance into a `MemberViewData` instance.

     - Returns: A `MemberViewData` object populated with the data from this `Member`.
     */
    public func toViewData() -> MemberViewData {
        let viewData = MemberViewData()
        viewData.id = self.id
        viewData.userUniqueId = self.userUniqueId
        viewData.name = self.name
        viewData.imageUrl = self.imageUrl
        viewData.questionAnswers = self.questionAnswers?.compactMap{ $0.toViewData() }
        viewData.state = self.state
        viewData.isGuest = self.isGuest
        viewData.customIntroText = self.customIntroText
        viewData.customClickText = self.customClickText
        viewData.memberSince = self.memberSince
        viewData.communityName = self.communityName
        viewData.isOwner = self.isOwner
        viewData.isDeleted = self.isDeleted
        viewData.customTitle = self.customTitle
        viewData.menu = self.menu?.compactMap { $0.toViewData() } ?? []  // No transformation needed as MemberAction has no ViewData class
        viewData.communityId = self.communityId
        viewData.chatroomId = self.chatroomId
        viewData.route = self.route
        viewData.attendingStatus = self.attendingStatus
        viewData.hasProfileImage = self.hasProfileImage
        viewData.updatedAt = self.updatedAt
        viewData.sdkClientInfo = self.sdkClientInfo?.toViewData() ?? nil  // Uses SDKClientInfo to SDKClientInfoViewData conversion
        viewData.uuid = self.uuid
        viewData.roles = self.roles?.compactMap { $0.toUserRoleViewData() }  // Convert each UserRole to UserRoleViewData
        return viewData
    }
}
extension MemberViewData {
    /**
     Converts a `MemberViewData` instance back into a `Member` using the builder pattern.

     - Returns: A `Member` object populated with the data from this `MemberViewData`.
     */
    public func toMember() -> Member {
        return Member.Builder()
            .id(id ?? "")
            .userUniqueId(userUniqueId ?? "")
            .name(name ?? "")
            .imageUrl(imageUrl ?? "")
            .questionAnswers(questionAnswers?.compactMap{ $0.toQuestion() } ?? [] )
            .state(state)
            .isGuest(isGuest)
            .customIntroText(customIntroText)
            .customClickText(customClickText)
            .memberSince(memberSince)
            .communityName(communityName)
            .isOwner(isOwner)
            .customTitle(customTitle)
            .menu(menu?.compactMap{ $0.toMemberAction() } ?? [] )
            .communityId(communityId)
            .chatroomId(chatroomId)
            .route(route)
            .attendingStatus(attendingStatus)
            .hasProfileImage(hasProfileImage)
            .updatedAt(updatedAt)
            .sdkClientInfo(sdkClientInfo?.toSDKClientInfo())  // Convert SDKClientInfoViewData back to SDKClientInfo
            .uuid(uuid ?? "")
            .roles(roles?.compactMap { $0.toUserRole() } ?? [])  // Convert each UserRoleViewData to UserRole
            .build()
    }
}
