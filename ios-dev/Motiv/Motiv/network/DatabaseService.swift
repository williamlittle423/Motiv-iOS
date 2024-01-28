//
//  DatabaseService.swift
//  Motiv
//
//  Created by William Little on 2024-01-03.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

class DatabaseService {
    
    struct DeleteDocumentResponse: Codable {
        let statusCode: Int
        let message: String?
        let error: String?
    }

    enum DeleteDocumentError: Error {
        case networkError(Error)
        case invalidResponse
    }
    
    // MARK: Generalized function for deleting documentsfrom
    func deleteDocumentInMongoDB(key: String, value: String, collection: String) async throws -> Bool {
        
        let apiURL = URL(string: "https://qzcckbbog8.execute-api.us-east-2.amazonaws.com/development")!
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        
        let requestBody = [
            "key": key,
            "value": value,
            "collection": collection
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(DeleteDocumentResponse.self, from: data)
            
            if response.statusCode == 200 {
                return true
            }
            
            throw DeleteDocumentError.invalidResponse
        } catch {
            throw DeleteDocumentError.networkError(error)
        }
    }
    
    // MARK: Helper function to convert a UIImage object to a Base64String for upload to AWS S3
    private func convertImageToBase64String(img: UIImage) -> String? {
        guard let imageData = img.jpegData(compressionQuality: 0.7) else { return nil }
        return imageData.base64EncodedString()
    }
    
    // MARK: API call to upload the users profile picture to S3
    func uploadImageToS3(uiImage: UIImage, userID: String) async throws -> String {
        
        guard let base64String = convertImageToBase64String(img: uiImage) else {
            throw ImageUploadError.invalidImageData
        }

        // AWS API endpoint
        let endpoint = "https://djmp9u42l7.execute-api.us-east-2.amazonaws.com/development/file-upload"
        
        guard let url = URL(string: endpoint) else {
            throw ImageUploadError.invalidURL
        }

        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["image": base64String, "userID": userID]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        // Perform the request
        let (data, response) = try await URLSession.shared.data(for: request)

        // Check for HTTP response errors
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Response was not 200...")
            throw ImageUploadError.invalidResponse
        }
        
        // Parse the JSON response to extract the URL
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let url = json["url"] as? String {
            // Return the extracted URL
            return url
        } else {
            throw ImageUploadError.invalidResponse
        }
    }
    
    // MARK: Generalized MongoDB Query API Call Function
    func generalDBQuery(queryParams: [String: Any], collection: String) async throws -> Data {
        
        let endpoint = "https://z5idpuiy3h.execute-api.us-east-2.amazonaws.com/development"
        
        // Prepare the request body
        let body: [String: Any] = [
            "collection": collection,
            "query": queryParams
        ]
        
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidResponse
        }
        
        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            throw APIError.invalidResponse
        }
        
        // Perform the network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw APIError.invalidResponse
        }
        
        guard !data.isEmpty else {
            throw APIError.invalidResponse
        }
        
        return data
    }
    
    // MARK: Generalized function to update
    func updateMongo(collectionName: String, filter: [String: Any], update: [String: Any], options: [String: Any]) async throws -> String {
        let apiURL = URL(string: "https://1jcyl0e7b8.execute-api.us-east-2.amazonaws.com/development")!
        
        let requestBody: [String: Any] = [
            "collectionName": collectionName,
            "filter": filter,
            "update": update,
            "options": options
        ]
                
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            throw error
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let response = try JSONDecoder().decode(APIResponse.self, from: data)
            return response.body
        } catch {
            throw error
        }
    }
    
    
    // MARK: Fetch a users profile photo
    func fetchProfilePhoto(objectKey: String) async -> String? {
        let apiURL = URL(string: "https://rqd0iqcw6i.execute-api.us-east-2.amazonaws.com/development")!
        
        let requestBody: [String: String] = ["objectKey": objectKey]
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let response = try JSONDecoder().decode(ProfilePhotoResponse.self, from: data)
            return response.body
        } catch {
            print("Error fetching profile photo: \(error)")
            return nil
        }
    }
    
    // MARK: V2 Uses SDWebImage to fetch profile images rather than direct S3 query
    func fetchUser(userID: String) async -> User? {

        let query = [
            "_id": userID
        ]
            
        let collection = "users"
            
        do {
            let data = try await generalDBQuery(queryParams: query, collection: collection)
            
            
            let responseString = String(data: data, encoding: .utf8)
                        
            let responseData = try JSONDecoder().decode(ResponseData.self, from: responseString!.data(using: .utf8)!)
            
            print("USER FOUND RESPONSE: \(responseData.body)")
            
            if responseData.statusCode == 200 {
                if let userData: [User] = try? JSONDecoder().decode([User].self, from: responseData.body.data(using: .utf8)!) {
                    if (userData.count == 1) {
                        print("Returning user: \(userData[0])")
                        return userData[0]
                    } else {
                        print("Error: More than one account associated with ID")
                    }
                } else {
                    print("ERROR DECODING USER")
                    return nil
                }
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
        
        
        struct ResponseData: Codable {
            let statusCode: Int
            let body: String
        }
        
        return nil
    }
    
    // MARK: Abstract function for updating a document in MongoDB
    func generalMongoUpdate(query: [String: Any], update: [String: Any], options: [String: Any]) async {
        /*
            const query = { _id: userID };
            // For the matched friend, update the status to "friends"
            const updateDocument = {
              $mul: { "friends.$[i].status": "friends" }
            };
            // Only update the matched friend_id
            const options = {
              arrayFilters: [
                {
                  "i.friend_id": friend_id,
                }
              ]
            };
        */
    }
    
}
