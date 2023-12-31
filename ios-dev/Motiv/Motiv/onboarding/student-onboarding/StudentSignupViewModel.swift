//
//  StudentSignupViewModel.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import Foundation

class StudentSignupViewModel: ObservableObject {
    
    // MARK: Student signup information
    @Published var name: String = ""
    @Published var program: String = ""
    @Published var gradYear: String = ""
    @Published var email: String = ""
    @Published var school: String = ""
    @Published var verificationInput: String = ""
    @Published var OTPCode: String = ""
    @Published var password: String = ""
    @Published var rePassword: String = ""
    
    // MARK: UI variables
    @Published var currentSlide: Int = 0
    @Published var isLoading: Bool = false
    
    // MARK: Error variables
    @Published var emailViewError: String = ""
    
    // Used for default activation of textfields
    @Published var alwaysTrue: Bool = true
    
    // MARK: Sends the verification email through an AWS Lambda function using an API gateway
    func sendVerification(apiEndpoint: String, payload: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        
        isLoading = true
        
        // Define the URL
        guard let url = URL(string: apiEndpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.isLoading = false
                    completion(.failure(error))
                    return
                }
                
                guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                    self.isLoading = false
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                self.isLoading = false
                completion(.success(responseString))
            }
        }
        task.resume()
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

