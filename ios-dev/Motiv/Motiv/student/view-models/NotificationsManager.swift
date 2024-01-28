//
//  NotificationsManager.swift
//  Motiv
//
//  Created by William Little on 2024-01-16.
//

import Foundation

class NotificationsManager: ObservableObject {
    
    @Published var friendRequests: [User] = []
    
    struct ResponseData: Codable {
        let statusCode: Int
        let body: String
    }
    
    // MARK: Fetch all the pending friendships
    func fetchPendingFriendships(user: User) async {
        
        let friends = pendingFriendships(from: user.friends)
        
        let dbService = DatabaseService()
        
        for friend in friends {
            
            if let new_friend: User = await dbService.fetchUser(userID: friend.friend_id) {
                DispatchQueue.main.async {
                    self.friendRequests.append(new_friend)
                }
                print("Found pending friendship with: \(new_friend.name)")
            } else {
                print("Error fetching users pending friend")
            }
        }
    }
    
    // MARK: Updates the friendship status in the current user and other users documents to "friends"
    func acceptFriendship(currUser: User, friend: User) async -> Bool {
        
        let currUserID = currUser._id
        let friendUserID = friend._id
        let collectionName = "users"
        
        // =============== MongoDB Parameters for current user + =================
        let queryCurr: [String: Any] = ["_id": currUserID]

        let updateCurr: [String: Any] = [
            "$mul": [
                "friends.$[i].status": "friends"
            ]
        ]

        let optionsCurr: [String: Any] = [
            "arrayFilters": [
                [
                    "i.friend_id": friendUserID
                ]
            ]
        ]
        // =============== MongoDB Parameters for current user - =================
        
        // =============== MongoDB Parameters for other user + =================
        let queryFriend: [String: Any] = ["_id": friendUserID]

        let updateFriend: [String: Any] = [
            "$set": [
                "friends.$[i].status": "friends"
            ]
        ]

        let optionsFriend: [String: Any] = [
            "arrayFilters": [
                [
                    "i.friend_id": currUserID
                ]
            ]
        ]
        // =============== MongoDB Parameters for other user - =================

        let dbService = DatabaseService()
                
        do {
            // API call to update both users documents to reflect friendship changes
            let responseCurrUser = try await dbService.updateMongo(collectionName: collectionName, filter: queryCurr, update: updateCurr, options: optionsCurr)
            let responseFriend = try await dbService.updateMongo(collectionName: collectionName, filter: queryFriend, update: updateFriend, options: optionsFriend)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    private func pendingFriendships(from friendships: [Friendship]) -> [Friendship] {
        return friendships.filter { $0.status == "pending" }
    }
}
