//
//  UserRole+ViewData.swift
//  LMCore
//

import LikeMindsChatData
import LikeMindsChatUI

extension UserRole {
    /**
     Converts a `UserRole` enum instance into a `UserRoleViewData` enum.

     - Returns:
       - A `UserRoleViewData` matching the raw value of this `UserRole`.
       - `nil` if the `UserRole` value is not recognized by `UserRoleViewData`.
     */
    public func toUserRoleViewData() -> UserRoleViewData? {
        // Match each case in `UserRole` to a case in `UserRoleViewData`.
        switch self {
        case .chatbot:
            return .chatbot
        case .member:
            return .member
        default:
            return .member
        }
    }
}

extension UserRoleViewData {
    /**
     Attempts to convert this `UserRoleViewData` instance back to a `UserRole` enum.

     - Returns:
       - A `UserRole` if the `rawValue` matches a known case in `UserRole`.
       - `nil` if it does not match any case in `UserRole`.
     */
    public func toUserRole() -> UserRole? {
        switch self {
        case .chatbot:
            return .chatbot
        case .member:
            return .member
        default:
            return .member
        }
    }
}
