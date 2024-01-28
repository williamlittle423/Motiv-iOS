//
//  StudentSignupViewModel.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
class StudentSignupViewModel: ObservableObject {
    
    // MARK: Student signup information
    @Published var name: String = ""
    @Published var program: String = ""
    @Published var gradYear: String = "2025"
    @Published var email: String = ""
    @Published var school: String = ""
    @Published var verificationInput: String = ""
    @Published var OTPCode: String = ""
    @Published var password: String = ""
    @Published var rePassword: String = ""
    @Published private(set) var profilePicture: UIImage? = nil
    @Published var photoSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: photoSelection)
        }
    }
    
    // MARK: UI variables
    @Published var currentSlide: Int = 0
    @Published var isLoading: Bool = false
    
    // MARK: Error variables
    @Published var emailViewError: String = ""
    @Published var imagePickerError: String = ""
    @Published var passwordViewError: String = ""
    
    // Used for default activation of textfields
    @Published var alwaysTrue: Bool = true
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection = selection else { return }

        Task {
            do {
                guard let data = try await selection.loadTransferable(type: Data.self) else {
                    throw ImageLoadingError.invalidData
                }

                guard let uiImage = UIImage(data: data) else {
                    throw ImageLoadingError.failedToCreateImage
                }

                profilePicture = uiImage
                // TODO: Call the uploadImage function to upload it to AWS S3 using an api gateway call
            } catch {
                // Handle the error appropriately
                imagePickerError = error.localizedDescription
                print("Error loading image: \(error)")
            }
        }
    }
    
    // MARK: Sends the verification email through an AWS Lambda function using an API gateway
    func sendVerification(apiEndpoint: String, payload: [String: Any]) async throws -> String {
        isLoading = true
        
        // Define the URL
        guard let url = URL(string: apiEndpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert payload to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            throw NetworkError.invalidResponse
        }
        request.httpBody = jsonData

        // Perform the network request
        let (data, _) = try await URLSession.shared.data(for: request)

        // Decode the response
        guard let responseString = String(data: data, encoding: .utf8) else {
            throw NetworkError.invalidResponse
        }
        
        self.currentSlide += 1
        isLoading = false
        
        return responseString
    }
    
    
    // MARK: Extract the suffix of the inputted email and return the string of the associated school
    func verifyEmail(email: String, completion: @escaping (String) -> Void) {
        
        // Extract the suffix of the email
        let extractDomain: (String) -> String = { email in
            let components = email.components(separatedBy: "@")
            return components.count > 1 ? components[1] : ""
        }

        let suffix = extractDomain(email)
        
        // Verify the suffix
        switch (suffix) {
        case "queensu.ca":
            completion("Queen's University")
        default:
            completion("")
        }
    }
    
    // MARK: Validate the password
    private func isValidPassword(_ password: String) -> Bool {
        // Regular expression for password validation
        // This pattern checks for at least one number, one uppercase letter, one lowercase letter, and one special character
        let pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"

        // NSPredicate for regex evaluation
        let predicate = NSPredicate(format:"SELF MATCHES %@", pattern)
        return predicate.evaluate(with: password)
    }
        
    // MARK: Sign up the user, performs all checks
    func signupUser() async throws -> User? {
        
        // Check if password contains required letters, characters, and numbers
        if !(isValidPassword(password)) {
            passwordViewError = "Invalid password. Must contain at least one number, one uppercase letter, one lowercase letter, and one special character"
            print("Invalid password")
            return nil
        }
        
        // Check if passwords match
        if (password != rePassword) {
            passwordViewError = "Passwords do not match. Try again."
            print("Passwords do not match. Try again.")
            return nil
        }
        
        let keychainManager = KeychainManager()
                
        // Obtain a unique authentication token for the user to upload to Keychain and MongoDB
        let authToken: String = keychainManager.generateAuthToken()
        let deviceID: String = UIDevice.current.identifierForVendor!.uuidString
        
        let userID: String = UUID().uuidString
        
        let dbService = DatabaseService()
        
        // Upload the profile photo and retreive the url
        var url: String = ""
        do {
            url = try await dbService.uploadImageToS3(uiImage: profilePicture!, userID: userID)
            print("API Call Response (should be url): \(url)")
        } catch {
            self.passwordViewError = "Network error occured."
            return nil
        }
        
        let school = determineSchool(email: email)
        
        // Create user object
        let newUser = UserAuthentication(_id: userID,
                                         name: name,
                                         email: email,
                                         profileImageURL: url,
                                         gradYear: gradYear,
                                         program: program,
                                         joinDate: Date.now,
                                         instagram: "",
                                         privacy: "Public",
                                         houseID: "",
                                         friends: [],
                                         school: school,
                                         password: password)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Specify your format here
        let dateString = dateFormatter.string(from: newUser.joinDate)
        
        
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
        
        
        let userObj = User(_id: userID, name: name, email: email, profileImageURL: url, gradYear: gradYear, program: program, joinDate: dateString, instagram: "", privacy: "Public", houseID: "", friends: [], school: determineSchool(email: email))
        
        // Try to upload user data to MongoDB
        do {
            let userSuccess = try await uploadUserToMongoDB(user: newUser)
            let tokenSuccess = try await uploadAuthToken(token: authToken, userID: userID)
            if userSuccess && tokenSuccess {
                print("MongoDB upload successfully performed")
            } else {
                self.passwordViewError = "Network error occured."
                return nil
            }
        } catch {
            print("Error occured during sign up: \(error.localizedDescription)")
            passwordViewError = error.localizedDescription
            return nil
        }
            
        // Store the authentication token for the new user in their devices keychain
        // This is used when the user closes the app and reopens it to obtain their information
        keychainManager.storeAuthToken(authToken, for: deviceID)
        
        return userObj
    }
    
    func uploadUserToMongoDB(user: UserAuthentication) async throws -> Bool {
        
        // API Gateway for AWS Lambda function
        guard let endpoint = URL(string: "https://vfxu75s7nj.execute-api.us-east-2.amazonaws.com/development") else {
            throw URLError(.badURL)
        }
        
        // Create a dictionary to hold the data
        let requestData = RequestData(body: user)

        // Encode the requestData dictionary as JSON
        let jsonData = try JSONEncoder().encode(requestData)

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let responseBody = String(data: data, encoding: .utf8) {
            print("Response Body: \(responseBody)")
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            // Handle the error case (e.g., throw a custom error or log a message)
            throw URLError(.badServerResponse)
        }
        
        return true
    }
    
    // MARK: Upload an authentication token to the database
    func uploadAuthToken(token: String, userID: String) async throws -> Bool {
        
        // API Gateway for AWS Lambda function
        guard let endpoint = URL(string: "https://1xcl1tekm2.execute-api.us-east-2.amazonaws.com/development") else {
            throw URLError(.badURL)
        }
        
        // Get the current date and time in ISO8601 format
        let dateFormatter = ISO8601DateFormatter()
        let dateCreated = dateFormatter.string(from: Date())
        
        // Create a dictionary to hold the data
        let data: [String: Any] = [
            "authToken": token,
            "userID": userID,
            "dateCreated": dateCreated
        ]
        
        // Specificy the database
        let payload: [String: Any] = [
            "body": data,
            "collection": "auth-tokens"
        ]

        // Encode the data dictionary as JSON
        let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            // Process the response data if needed
        } catch {
            self.passwordViewError = "Error uploading data. Try again later."
            return false
        }
        
        return true
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



struct RequestData: Encodable {
    let body: UserAuthentication
}

// NetworkError for error handling
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}

enum OTPError: LocalizedError {
    case invalidCode

    var errorDescription: String? {
        switch self {
        case .invalidCode:
            return "Invalid verification code entered. Please try again."
        }
    }
}

enum ImageLoadingError: Error, CustomStringConvertible {
    case invalidData
    case failedToCreateImage

    var description: String {
        switch self {
        case .invalidData:
            return "Invalid or no data was returned from the PhotosPickerItem."
        case .failedToCreateImage:
            return "Unable to create an image from the provided data."
        }
    }
}

enum ImageUploadError: Error {
    case invalidImageData
    case invalidURL
    case invalidResponse
}
