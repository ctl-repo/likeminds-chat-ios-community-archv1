//
//  MemberAction+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import LikeMindsChatUI
import LikeMindsChatData

extension MemberAction {
    /**
     Converts this `MemberAction` instance into a `MemberActionViewData` object.

     - Returns: A `MemberActionViewData` populated with this action's data.
     */
    public func toViewData() -> MemberActionViewData {
        let viewData = MemberActionViewData()
        viewData.title = self.title
        viewData.route = self.route
        return viewData
    }
}

extension MemberActionViewData {
    /**
     Converts this `MemberActionViewData` object back into a `MemberAction` struct.

     - Returns: A `MemberAction` created using this view data's properties.
     */
    public func toMemberAction() -> MemberAction {
        return MemberAction(
            title: self.title,
            route: self.route
        )
    }
}
