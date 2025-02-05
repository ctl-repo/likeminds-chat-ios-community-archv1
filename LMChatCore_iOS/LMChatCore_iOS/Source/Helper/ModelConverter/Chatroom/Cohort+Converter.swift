//
//  Cohort+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import LikeMindsChatUI
import LikeMindsChatData

extension Cohort {
    /**
     Converts this `Cohort` struct to a `CohortViewData` object.
     
     - Returns: A new `CohortViewData` with properties copied from this `Cohort`.
     */
    public func toViewData() -> CohortViewData {
        let viewData = CohortViewData()
        viewData.id = self.id
        viewData.totalMembers = self.totalMembers
        viewData.name = self.name
        viewData.members = self.members?.map { $0.toViewData() }
        return viewData
    }
}

extension CohortViewData {
    /**
     Converts this `CohortViewData` back into a `Cohort` struct.
     
     Since `Cohort` is a `Decodable`-only struct in your code snippet, it doesn’t have
     a public memberwise initializer. For simplicity here, we define one in an extension.
     
     - Returns: A new `Cohort` instance created from this view data.
     */
    public func toCohort() -> Cohort {
        return Cohort(
            id: self.id,
            totalMembers: self.totalMembers,
            name: self.name,
            members: self.members?.map { $0.toMember() }
        )
    }
}
