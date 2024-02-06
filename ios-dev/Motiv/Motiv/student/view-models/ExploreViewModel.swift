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
    @Published var fetchingFriends: Bool = false
    @Published var requestsSent: [String] = []
    
    func appOpened(user: User, school: String) async {
        Task {
            do {
                fetchingFriends = true
                if let fetchedUsers = try await fetchSuggestedUsers(user: user, school: "Queen's University") {
                    self.friendsToDisplay = fetchedUsers
                    print("Success finding users to display")
                }
                fetchingFriends = false
            } catch {
                fetchingFriends = false
                print(error)
            }
        }
    }
    
    // MARK: Fetch friends V2
    // MARK: Retreive a list of users to display in the friends tab of the explore view
    // MARK: This version fetches users from the target school who are not friends with the current user
    func fetchSuggestedUsers(user: User, school: String) async -> [User]? {
        
        // Make API call to fetch all the raw users
        let queryParams: [String: Any] = [
            "school": school
        ]
        
        let dbService = DatabaseService()
        
        // Fetch the data
        do {
            let data = try await dbService.generalDBQuery(queryParams: queryParams, collection: "users")
                        
            let responseData = try JSONDecoder().decode(ResponseData.self, from: data)
            
            guard let bodyData = responseData.body.data(using: .utf8) else {
                print("Error converting body string to Data")
                return nil
            }
            
            let dataString = String(data: bodyData, encoding: .utf8)
                        
            let userResponse = try JSONDecoder().decode([User].self, from: bodyData)
            
            let friendIds = user.friends.map { $0.friend_id }

            
            var returnUsers: [User] = []
            for suggestion in userResponse {
                // Check if it the current user
                if suggestion._id != user._id {
                    // Check if they are already friends or sent a request
                    if !(friendIds.contains(suggestion._id)) {
                        returnUsers.append(suggestion)
                    }
                }
            }
                        
            return returnUsers
            
        } catch {
            print("An error occured querying all the users")
        }
        
        return nil
    }

    // MARK: When the current user taps the add friend option on another user
    // Sends an API request and creates a friendship pending object in the users profile
    func sendFriendRequest(senderID: String, recipientID: String) async {
        
        // Initialize the API parameters
        let collectionName = "users"
        
        // Senders document update
        let filterSender: [String: Any] = ["_id": senderID]
        let updateSender: [String: Any] = [
            "$push": [
                "friends": [
                    "friend_id": recipientID,
                    "status": "pending"
                ]
            ]
        ]
        
        // Receivers document update
        let filterRecipient: [String: Any] = ["_id": recipientID]
        let updateRecipient: [String: Any] = [
            "$push": [
                "friends": [
                    "friend_id": senderID,
                    "status": "pending"
                ]
            ]
        ]
        
        let dbService = DatabaseService()
                
        do {
            // Update both the sender and receivers documents of the pending friendship
            let responseSender = try await dbService.updateMongo(collectionName: collectionName, filter: filterSender, update: updateSender, options: [:])
            let responseRecipient = try await dbService.updateMongo(collectionName: collectionName, filter: filterRecipient, update: updateRecipient, options: [:])
            withAnimation {
                requestsSent.append(recipientID)
            }
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
