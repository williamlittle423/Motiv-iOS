//
//  KeychainManager.swift
//  Motiv
//
//  Created by William Little on 2023-12-31.
//

import Foundation
import KeychainAccess

class KeychainManager {
    
    // MARK: Generate a unique authentication token for the user to upload to Keychain and MongoDB
    func generateAuthToken() -> String {
        return UUID().uuidString
    }

    // MARK: Securely store an authentication token in the user's keychain
    func storeAuthToken(_ token: String, for account: String) {
        let keychain = Keychain(service: "cpp.Motiv")
        keychain[account] = token
    }

    // MARK: Retreive an authentication token from the user's keychain
    func retrieveAuthToken(for account: String) -> String? {
        let keychain = Keychain(service: "cpp.Motiv")
        return keychain[account]
    }
    
    // MARK: Remove an authentication token from the user's keychain
    func removeAuthToken(for account: String) {
        let keychain = Keychain(service: "cpp.Motiv")
        keychain[account] = nil // This will remove the value associated with the account
    }
    
}
