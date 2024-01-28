//
//  User.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import Foundation

struct User: Hashable, Codable {
    var _id: String
    var name: String
    var email: String
    var profileImageURL: String
    var gradYear: String
    var program: String
    var joinDate: String
    var instagram: String
    var privacy: String
    var houseID: String
    var friends: [Friendship]
    var school: String
    
    // Memberwise initializer
    init(_id: String, name: String, email: String, profileImageURL: String, gradYear: String, program: String, joinDate: String, instagram: String, privacy: String, houseID: String, friends: [Friendship], school: String) {
        self._id = _id
        self.name = name
        self.email = email
        self.profileImageURL = profileImageURL
        self.gradYear = gradYear
        self.program = program
        self.joinDate = joinDate
        self.instagram = instagram
        self.privacy = privacy
        self.houseID = houseID
        self.friends = friends
        self.school = school
    }
}
