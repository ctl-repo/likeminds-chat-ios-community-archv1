//
//  ConversationStatusViewData.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

/// A view-data representation of `ConversationStatus`.
///
/// This enum is used in UI layers to represent conversation status with human-readable values.
public enum ConversationStatusViewData: String {
    case sending = "Sending"
    case sent = "Sent"
    case failed = "Failed"
}
