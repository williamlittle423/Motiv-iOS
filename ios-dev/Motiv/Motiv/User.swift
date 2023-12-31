//
//  User.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import Foundation

struct User {
    var id: String            // Unique identifier for the user
    var username: String      // User's chosen username
    var email: String         // User's email address
    var profileImageURL: URL? // URL to the user's profile picture (if applicable)
    var bio: String?          // A short bio or description about the user
    var joinDate: Date        // Date when the user joined your service

    // Consider adding more fields depending on your app's features, such as:
    // - Location
    // - Date of birth (consider privacy implications)
    // - User preferences or settings
    // - Social media links
    // - User status (e.g., online/offline, active/inactive)

    // You might also want to include computed properties for convenience,
    // such as a formatted join date or a formatted name.
}
