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
            return try await fetchUserFromAuthToken(authToken: authToken!)
        } catch {
            print("Error occured: \(error)")
            return nil
        }
    }
    
    // MARK: Performs fetchUser more efficiently *hopefully
    func fetchUserFromAuthToken(authToken: String) async throws -> User? {
        
        let dbService = DatabaseService()
        
        let tokenQuery = [
            "authToken": authToken
        ]
        
        struct ResponseData: Codable {
            let statusCode: Int
            let body: String
        }
        
        do {
            // Perform a query for a AuthToken object
            let tokenData = try await dbService.generalDBQuery(queryParams: tokenQuery, collection: "auth-tokens")
            let tokenResponseString = String(data: tokenData, encoding: .utf8)
            print("TOKEN DATA: \(tokenResponseString)")
            
            let tokenResponseData = try JSONDecoder().decode(ResponseData.self, from: tokenResponseString!.data(using: .utf8)!)
            
            if tokenResponseData.statusCode == 200 {
                print(tokenResponseData.body)
                if let token: [AuthTokenObject] = try? JSONDecoder().decode([AuthTokenObject].self, from: tokenResponseData.body.data(using: .utf8)!) {
                    if (token.count == 1) {
                        print("WORKED: Trying to fetch user with \(token[0].userID)")
                        return await dbService.fetchUser(userID: token[0].userID)
                    } else {
                        print("Too many auth tokens associated with user")
                        return nil
                    }
                } else {
                    print("No user associated with token data")
                    return nil
                }
            } else {
                print("Error code 500 obtaining current user")
            }
            
            
        } catch {
            print("Error fetching current user")
            return nil
        }
        
        print("No user found")
        return nil
    }
    
    
    // MARK: Perform API gateway call to fetchUser lambda function for retreiving a user
//    func fetchUser(authToken: String) async throws -> User? {
//        // Your API endpoint URL
//        let apiURL = URL(string: "https://v68xnmoi64.execute-api.us-east-2.amazonaws.com/development")!
//
//        // Create a UserRequest struct to encode the authToken
//        struct UserRequest: Codable {
//            let auth_token: String
//        }
//
//        let userRequest = UserRequest(auth_token: authToken)
//
//        do {
//            // Encode the UserRequest struct as JSON data
//            let jsonData = try JSONEncoder().encode(userRequest)
//
//            // Create an HTTP request
//            var request = URLRequest(url: apiURL)
//            request.httpMethod = "POST"
//            request.httpBody = jsonData
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//            // Send the request and get the response data
//            let (data, _) = try await URLSession.shared.data(for: request)
//
//            struct ResponseData: Codable {
//                let statusCode: Int
//                let body: String
//            }
//
//            let responseString = String(data: data, encoding: .utf8)
//
//            let responseData = try JSONDecoder().decode(ResponseData.self, from: responseString!.data(using: .utf8)!)
//
//            if responseData.statusCode == 200 {
//                if let userData: UserResponse = try? JSONDecoder().decode(UserResponse.self, from: responseData.body.data(using: .utf8)!) {
//                    // Create a user instance from the userData and return it
//                    let data = Data(base64Encoded: userData.profileImageBase64)
//                    if let image = UIImage(data: data!) {
//                        print("Image conversion worked from Base64 -> UIImage")
//                        // Image conversion worked
//                        let user = User(_id: userData._id,
//                                        name: userData.name,
//                                        email: userData.email,
//                                        profileImage: image,
//                                        gradYear: userData.gradYear,
//                                        program: userData.program,
//                                        joinDate: userData.joinDate,
//                                        instagram: userData.instagram,
//                                        privacy: userData.privacy,
//                                        houseID: userData.houseID,
//                                        friends: userData.friends)
//                        return user
//                    } else {
//                        let user = User(_id: userData._id,
//                                        name: userData.name,
//                                        email: userData.email,
//                                        profileImage: nil,
//                                        gradYear: userData.gradYear,
//                                        program: userData.program,
//                                        joinDate: userData.joinDate,
//                                        instagram: userData.instagram,
//                                        privacy: userData.privacy,
//                                        houseID: userData.houseID,
//                                        friends: userData.friends)
//                        return user
//                    }
//                } else {
//                    print("Failed to decode user data.")
//                    return nil
//                }
//            } else {
//                print("Non-200 status code in response.")
//                return nil
//            }
//        }
//    }
    
    // MARK: Sign out the user
    // 1. Display loading
    // 2. Delete authentication token in database (api call)
    // 3. Delete the users authentication token in keychain
    // 4. Set user to nil
    // 5. Set loggedIn to false and isStudent to false
    // Return an error string if one occurs
    func signOut() async -> String? {
        
        let dbService = DatabaseService()
        
        do {
            // Delete the auth token
            if user != nil {
                let success = try await dbService.deleteDocumentInMongoDB(key: "userID", value: user!._id, collection: "auth-tokens")
                if success {
                    // Successfully signed out
                    print("Signed out successfully")
                    let keychainManager = KeychainManager()
                    
                    if let deviceID: String = UIDevice.current.identifierForVendor?.uuidString {
                        // Remove the authentication token
                        keychainManager.removeAuthToken(for: deviceID)
                    } else {
                        return "An unexpected error occured."
                    }
                    
                    self.isLoggedIn = false
                    self.isStudent = false
                    return nil
                } else {
                    return "An unexpected error occured."
                }
            } else {
                self.isLoggedIn = false
                self.isStudent = false
                return nil
            }
        } catch {
            return error.localizedDescription
        }
    }
    
    // MARK: Attempt to login a user
    // 1. Query database for document containing email
    // 2. Fetch the password in the document
    // 3. Encrypt the inputted password
    // 4. Check if the encrypted inputted password matches the fetched document password
    // 5. If so, create an authentication token (if not, display error)
    // 6. Return a response of the user
    func login(email: String, password: String) async throws {
        
        let input = UserAuthenticationInput(email: email, password: password)
        let dateFormatter = ISO8601DateFormatter() // Create an ISO8601 date formatter
        
        print("Starting login")
        
            // Perform sign in API Call
            print("Authentication beginning")
            // Response determined
            if let response = await authenticateUser(input: input) {
                // User found
                if (response.statusCode == 200) {
                    if let user: User = try? JSONDecoder().decode(User.self, from: response.body!.data(using: .utf8)!) {
                        print("User authenticated successfully: \(response.body ?? "")")
                        
                        // TODO: Upload authentication token for the user, place it in the keychain
                        let keychainManager = KeychainManager()
                        let authToken = keychainManager.generateAuthToken()
                        
                        // Try database upload first
                        do {
                            let response = try await uploadAuthToken(authToken: authToken, userID: user._id)
                            if response.statusCode == 200 {
                                print("Auth token uploaded to MongoDB")
                            } else {
                                throw AuthenticationError.networkingError
                            }
                        } catch {
                            throw AuthenticationError.networkingError
                        }
                        
                        // Then place the authToken in the keychain
                        if let deviceID: String = UIDevice.current.identifierForVendor?.uuidString {
                            print("Authentication token succesfully placed in user's Keychain")
                            keychainManager.storeAuthToken(authToken, for: deviceID)
                        } else {
                            throw AuthenticationError.invalidResponse
                        }
                        
                        self.user = user
                        self.isStudent = true
                        self.isLoggedIn = true
                    } else {
                        print("Error decoding user response")
                        throw AuthenticationError.encodingError
                    }
                } else if (response.statusCode == 404) {
                    print("User not found")
                    throw AuthenticationError.userNotFound
                } else if (response.statusCode == 401) {
                    print("Password doesn't match")
                    throw AuthenticationError.passwordMatch
                } else {
                    throw AuthenticationError.networkingError
                }
            } else {
                print("Authentication failed.")
                throw AuthenticationError.invalidResponse
            }
    }
    
    // MARK: Queries the database with user authentication input and verifies if the input matches database records
    func authenticateUser(input: UserAuthenticationInput) async -> UserAuthenticationResponse? {
        // Construct the URL for your AWS Lambda function
        let lambdaURL = URL(string: "https://1xs99gpddb.execute-api.us-east-2.amazonaws.com/development")!
        
        // Create a URLRequest
        var request = URLRequest(url: lambdaURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the input as JSON
        let encoder = JSONEncoder()
        guard let inputData = try? encoder.encode(input) else {
            print("Error encoding user input")
            return nil
        }
        
        request.httpBody = inputData
        
        do {
            // Send the request and handle the response
            let (data, _) = try await URLSession.shared.data(for: request)

            let decoder = JSONDecoder()
            let responseModel = try decoder.decode(UserAuthenticationResponse.self, from: data)
            
            return responseModel
        } catch {
            return nil
        }
    }

    // MARK: Upload an authentication token associated with a userID
    func uploadAuthToken(authToken: String, userID: String) async throws -> APIResponse {
        let apiUrl = URL(string: "https://1xcl1tekm2.execute-api.us-east-2.amazonaws.com/development")! // Replace with your API Gateway URL
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        
        let body: [String: Any] = [
            "authToken": authToken,
            "userID": userID
        ]
        
        let requestData: [String: Any] = [
            "collection": "auth-tokens",
            "body": body
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestData)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                let apiResponse = APIResponse(body: String(data: data, encoding: .utf8) ?? "", statusCode: httpResponse.statusCode)
                return apiResponse
            } else {
                throw AuthenticationError.networkingError
            }
        } catch {
            throw error
        }
    }
}

struct UserAuthenticationResponse: Codable {
    let statusCode: Int
    let body: String?
    let error: String?
}

struct UserAuthenticationInput: Codable {
    let email: String
    let password: String
}

enum AuthenticationError: Error {
    case encodingError
    case networkingError
    case invalidResponse
    case passwordMatch
    case userNotFound
    
    var localizedDescription: String {
            switch self {
            case .encodingError:
                return NSLocalizedString("An internal error occured.", comment: "")
            case .networkingError:
                return NSLocalizedString("A networking error occurred.", comment: "")
            case .invalidResponse:
                return NSLocalizedString("Invalid credentials. Try again.", comment: "")
            case .passwordMatch:
                return NSLocalizedString("Invalid password.", comment: "Invalid password.")
            case .userNotFound:
                return NSLocalizedString("User not found with email.", comment: "User not found with email.")
            }
        }
}
