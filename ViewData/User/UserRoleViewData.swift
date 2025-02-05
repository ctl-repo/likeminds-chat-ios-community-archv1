//
//  UserRoleViewData.swift
//  LikeMindsChat
//
//  Created by Anurag Tyagi on 21/01/25.
//

import Foundation

/**
 A "view data" enum that mirrors the possible values of `UserRole`. 
 This is useful when you want to keep the core/business enum (`UserRole`) separate from 
 any UI-layer or intermediate-layer logic.
 */
public enum UserRoleViewData: String {
    
    /// Indicates the user is a chatbot entity.
    case chatbot = "chatbot"
    
    /// Indicates the user is a regular member.
    case member = "member"
}
