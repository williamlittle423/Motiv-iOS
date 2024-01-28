//
//  AuthTokenObject.swift
//  Motiv
//
//  Created by William Little on 2024-01-26.
//

import Foundation

struct AuthTokenObject: Codable {
    let _id: String
    let dateCreated: String
    let authToken: String
    let userID: String
}
