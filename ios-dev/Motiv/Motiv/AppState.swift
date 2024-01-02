//
//  AppState.swift
//  Motiv
//
//  Created by William Little on 2023-12-27.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class AppState: ObservableObject {
    
    // MARK: Sign up process
    // 1. OAuth token is generated and uploaded to users authtoken field in mongodb atlas
    // 2. Upload to keychain
    
    @Published var isInitializing: Bool
    @Published var isLoggedIn: Bool = false
    @Published var isStudent: Bool = false
    @Published var isEstablishment: Bool = false
    
    @Published var shouldIndicateActivity = false
    @Published var error: String?
    @Published var networkError: Bool = false

    var user: User?
    
    // MARK: App is opened
    // 1. Check if there is an authentication token stored in Keychain
    // 2. If one exists, query the database for the user associated with the token. Otherwise, display onboarding
    // 3. Update the user field if it exists display main student page (no establishment logic yet)
    init() {
        self.isInitializing = true
        
        // Attempt to obtain user
        Task {
            await self.user = appOpened()
            
            // No user found
            if user == nil {
                self.isLoggedIn = false
                self.isInitializing = false
            } else {
                self.isLoggedIn = true
                self.isStudent = true
                self.isInitializing = false
            }
        }
    }
    
    // MARK: Check if an authentication token is associated with the device from keychain and retreive the user from the database
    func appOpened() async -> User? {
        
        let keychainManager = KeychainManager()
        
        // Retreive deviceID
        let deviceID: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        // Query keychain for an associated authenticationToken
        let authToken = keychainManager.retrieveAuthToken(for: deviceID)
        
        if authToken == nil || authToken == "" {
            // No auth token associated with this device
            print("No auth token found with deviceID")
            return nil
        } else {
            print("Auth token found: \(authToken!)")
        }
        
        // Attempt database query for user
        do {
            return try await fetchUser(authToken: authToken!)
        } catch {
            print("Error occured: \(error)")
            return nil
        }
    }
    
    enum APIError: Error {
        case networkError(Error)
        case invalidResponse
        case decodingError(Error)
    }

    // MARK: Perform API gateway call to fetchUser lambda function for retreiving a user
    func fetchUser(authToken: String) async throws -> User? {
        // Your API endpoint URL
        let apiURL = URL(string: "https://v68xnmoi64.execute-api.us-east-2.amazonaws.com/development")!
        
        // Create a UserRequest struct to encode the authToken
        struct UserRequest: Codable {
            let auth_token: String
        }
        
        let userRequest = UserRequest(auth_token: authToken)
        
        do {
            // Encode the UserRequest struct as JSON data
            let jsonData = try JSONEncoder().encode(userRequest)
            
            // Create an HTTP request
            var request = URLRequest(url: apiURL)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Send the request and get the response data
            let (data, _) = try await URLSession.shared.data(for: request)
            
            struct ResponseData: Codable {
                let statusCode: Int
                let body: String
            }
            
            struct UserResponse: Codable {
                let _id: String
                let joinDate: String
                let gradYear: String
                let program: String
                let email: String
                let profileImageURL: String
                let name: String
                let instagram: String
            }
            
            let dateFormatter = ISO8601DateFormatter() // Create an ISO8601 date formatter
            
            let responseString = String(data: data, encoding: .utf8)
            
            let responseData = try JSONDecoder().decode(ResponseData.self, from: responseString!.data(using: .utf8)!)
            
            if responseData.statusCode == 200 {
                let userResponseString = responseData.body
                print(userResponseString)
                if let userData: UserResponse = try? JSONDecoder().decode(UserResponse.self, from: responseData.body.data(using: .utf8)!) {
                    // Create a user instance from the userData and return it
                    let user = User(
                        _id: userData._id,
                        name: userData.name,
                        email: userData.email,
                        profileImageURL: userData.profileImageURL,
                        gradYear: userData.gradYear,
                        program: userData.program,
                        joinDate: dateFormatter.date(from: userData.joinDate) ?? Date(), // Convert ISO8601 date string to Date
                        instagram: userData.instagram
                    )
                    return user
                } else {
                    print("Failed to decode user data.")
                    return nil
                }
            } else {
                print("Non-200 status code in response.")
                return nil
            }
        }
    }
}
