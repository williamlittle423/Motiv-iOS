//
//  UserResponse.swift
//  Motiv
//
//  Created by William Little on 2024-01-03.
//

import Foundation

struct UserResponse: Codable {
    var _id: String
    var name: String
    var email: String
    var profileImageURL: String?
    var gradYear: String
    var program: String
    var joinDate: String
    var instagram: String
    var privacy: String
    var houseID: String
    var friends: [Friendship]
    var school: String
}
