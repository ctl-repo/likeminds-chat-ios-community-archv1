//
//  SDKClientInfo+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import LikeMindsChatData
import LikeMindsChatUI

extension SDKClientInfo {
    /**
     Converts this `SDKClientInfo` instance into a `SDKClientInfoViewData` object.

     - Returns: A new `SDKClientInfoViewData` with property values mirroring this `SDKClientInfo`.
     */
    public func toViewData() -> SDKClientInfoViewData {
        let viewData = SDKClientInfoViewData()
        viewData.community = self.community
        viewData.user = self.user
        viewData.userUniqueID = self.userUniqueID
        viewData.uuid = self.uuid
        return viewData
    }
}

extension SDKClientInfoViewData {
    /**
     Converts this `SDKClientInfoViewData` instance back into a `SDKClientInfo` struct.

     - Returns: A new `SDKClientInfo` with property values copied from this view data.
     */
    public func toSDKClientInfo() -> SDKClientInfo {
        return SDKClientInfo(
            community: self.community,
            user: self.user,
            userUniqueID: self.userUniqueID,
            uuid: self.uuid
        )
    }
}
