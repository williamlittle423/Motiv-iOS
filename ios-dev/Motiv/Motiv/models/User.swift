//
//  User.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import Foundation
import SwiftUI

struct User: Hashable {
    
    var _id: String
    var name: String
    var email: String
    var profileImage: UIImage?
    var gradYear: String
    var program: String
    var joinDate: String
    var instagram: String
    var privacy: String
    var houseID: String
    var friends: [Friendship]
    var school: String {
        return determineSchool(email: email)
    }
    
    // Memberwise initializer
    init(_id: String, name: String, email: String, profileImage: UIImage?, gradYear: String, program: String, joinDate: String, instagram: String, privacy: String, houseID: String, friends: [Friendship]) {
                
        self._id = _id
        self.name = name
        self.email = email
        self.profileImage = profileImage ?? nil
        self.gradYear = gradYear
        self.program = program
        self.joinDate = joinDate
        self.instagram = instagram
        self.privacy = privacy
        self.houseID = houseID
        self.friends = friends
    }
    
    // MARK: Extract the suffix of the inputted email and return the string of the associated school
    func determineSchool(email: String) -> String {
        
        // Extract the suffix of the email
        let extractDomain: (String) -> String = { email in
            let components = email.components(separatedBy: "@")
            return components.count > 1 ? components[1] : ""
        }

        let suffix = extractDomain(email)
        
        // Verify the suffix
        switch (suffix) {
        case "queensu.ca":
            return "Queen's University"
        default:
            return ""
        }
    }
}

