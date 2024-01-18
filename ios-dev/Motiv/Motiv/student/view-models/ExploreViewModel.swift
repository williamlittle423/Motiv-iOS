//
//  ExploreViewModel.swift
//  Motiv
//
//  Created by William Little on 2024-01-08.
//

import Foundation
import SwiftUI

@MainActor
class ExploreViewModel: ObservableObject {
    
    @Published var friendsToDisplay: [User] = []
    
    func appOpened(userID: String, school: String) async {
        Task {
            do {
                self.friendsToDisplay = try await fetchFriends(userID: userID, school: school) ?? []
//                print("Updated friends to display: \(self.friendsToDisplay)")
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: Retreive a list of users to display in the friends tab of the explore view
    // V1: Fetch all users that contain the school (CURRENT)
    // V2: Fetch all users that are in the same year FIRST then
    // V3: Mutual friends algorithm
    func fetchFriends(userID: String, school: String) async throws -> [User]? {
        
        let dbService = DatabaseService()
        
        let query = ["school": school]
        
        do {
            print("Attempting friends query")
            let data = try await dbService.generalDBQuery(queryParams: query, collection: "users")
            let responseData = try JSONDecoder().decode(ResponseData.self, from: data)
            
            guard responseData.statusCode == 200 else {
                print("Unexpected status code: \(responseData.statusCode)")
                return nil
            }
            
            guard let bodyData = responseData.body.data(using: .utf8) else {
                print("Error converting body string to Data")
                return nil
            }
            
            let friendsResponses = try JSONDecoder().decode([FriendsResponse].self, from: bodyData)
            let idList = friendsResponses.map { $0._id }
//            print("id list: \(idList)")
            
            let profileImagesBase64 = await fetchProfilePhotos(idList: idList)
            
            var users: [User] = []
            for i in 0..<friendsResponses.count {
                let userID = friendsResponses[i]._id
                let base64String = profileImagesBase64[i]
                if let imageData = Data(base64Encoded: base64String) {
                    // Create user object for each person
                    let image = UIImage(data: imageData)
                    let user = User(_id: userID,
                                    name: friendsResponses[i].name,
                                    email: friendsResponses[i].email,
                                    profileImage: image,
                                    gradYear: friendsResponses[i].gradYear,
                                    program: friendsResponses[i].program,
                                    joinDate: friendsResponses[i].joinDate,
                                    instagram: friendsResponses[i].instagram,
                                    privacy: friendsResponses[i].privacy,
                                    houseID: friendsResponses[i].houseID,
                                    friends: friendsResponses[i].friends)
                    users.append(user)
//                    print("found user \(user.name) - with image")
                } else {
                    let user = User(_id: userID,
                                    name: friendsResponses[i].name,
                                    email: friendsResponses[i].email,
                                    profileImage: nil,
                                    gradYear: friendsResponses[i].gradYear,
                                    program: friendsResponses[i].program,
                                    joinDate: friendsResponses[i].joinDate,
                                    instagram: friendsResponses[i].instagram,
                                    privacy: friendsResponses[i].privacy,
                                    houseID: friendsResponses[i].houseID,
                                    friends: friendsResponses[i].friends)
                    users.append(user)
//                    print("found user \(user.name) - with image")
                }
                
            }
            return users
        } catch {
            print("Error fetching friends: \(error)")
        }
        
        return nil
    }
    
    // Function to fetch a single profile photo from S3
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
    
    // Function to fetch profile photos for a list of user IDs
    func fetchProfilePhotos(idList: [String]) async -> [String] {
        var base64Images: [String] = []
        
        for i in 0..<idList.count {
            let id: String = idList[i]
            let objectKey = "students/profilephotos/\(id)_profilephoto.jpg"
//            print("Object key: \(objectKey)")
            if let base64String = await fetchProfilePhoto(objectKey: objectKey) {
                base64Images.append(base64String)
            } else {
                print("No image found!!!")
            }
        }
        
        return base64Images
    }
    
    // MARK: When the current user taps the add friend option on another user
    // Sends an API request and creates a friendship pending object in the users profile
    func sendFriendRequest(senderID: String, recipientID: String) async {
        
        // Initialize the API parameters
        let collectionName = "users"
        
        // Senders document update
        let filter: [String: Any] = ["_id": recipientID]
        let update: [String: Any] = [
            "$push": [
                "friends": [
                    "friend_id": senderID,
                    "status": "pending"
                ]
            ]
        ]
        
        let dbService = DatabaseService()
                
        do {
            let response = try await dbService.updateMongo(collectionName: collectionName, filter: filter, update: update) 
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

struct ProfilePhotoResponse: Codable {
    let body: String?
    let error: String?
}


struct FriendsResponse: Codable {
    let _id: String
    let joinDate: String
    let gradYear: String
    let program: String
    let email: String
    let school: String
    let profileImageURL: String
    let name: String
    let instagram: String
    let privacy: String
    let houseID: String
    let friends: [Friendship]
}


struct ResponseData: Codable {
    let statusCode: Int
    let body: String
}
