//
//  AppState.swift
//  Motiv
//
//  Created by William Little on 2023-12-27.
//

import Foundation
import Combine

class AppState: ObservableObject {
    
    // MARK: Sign up process
    // 1. OAuth token is generated and uploaded to users authtoken field in mongodb atlas
    // 2. Upload to keychain
    
    // MARK: App is opened
    // 1. Check if there is an authentication token stored in Keychain
    // 2. If one exists, query the database for the user associated with the token. Otherwise, display start page
    // 3. Update the user field
    
    @Published var isInitializing: Bool
    @Published var isLoggedIn: Bool = false
    @Published var isStudent: Bool = false
    @Published var isEstablishment: Bool = false
    
    @Published var shouldIndicateActivity = false
    @Published var error: String?
    @Published var networkError: Bool = false

//    var user: User?
    
    init() {
        self.isInitializing = true
        // TODO: Query the keychain for an auth token
        // TODO: Query MongoDB for the associated auth token
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isInitializing = false
        }
    }
    
}
