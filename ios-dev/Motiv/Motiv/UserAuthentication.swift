//
//  UserAuthentication.swift
//  Motiv
//
//  Created by William Little on 2023-12-31.
//

import Foundation

struct UserAuthentication: Codable {
    var _id: String
    var name: String
    var email: String
    var profileImageURL: String
    var gradYear: String
    var program: String
    var joinDate: Date
    var instagram: String
    var currentAuthToken: String
    var password: String
    
    // Encode Date as ISO8601 String
    private enum CodingKeys: String, CodingKey {
        case _id, name, email, profileImageURL, gradYear, program, instagram, currentAuthToken, joinDate, password
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(name, forKey: .name)
        try container.encode(profileImageURL, forKey: .profileImageURL)
        try container.encode(gradYear, forKey: .gradYear)
        try container.encode(program, forKey: .program)
        try container.encode(instagram, forKey: .instagram)
        try container.encode(email, forKey: .email)
        let dateFormatter = ISO8601DateFormatter()
        try container.encode(dateFormatter.string(from: joinDate), forKey: .joinDate)
        try container.encode(password, forKey: .password)
    }
}
