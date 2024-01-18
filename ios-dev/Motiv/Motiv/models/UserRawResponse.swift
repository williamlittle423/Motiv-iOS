//
//  UserRawResponse.swift
//  Motiv
//
//  Created by William Little on 2024-01-16.
//

import Foundation

struct UserRawResponse: Codable {
    let _id: String
    let joinDate: String
    let gradYear: String
    let program: String
    let email: String
    let school: String
    let profileImageURL: String
    let name: String
    let instagram: String
    let privacy: String
    let houseID: String
    let friends: [Friendship]
}
