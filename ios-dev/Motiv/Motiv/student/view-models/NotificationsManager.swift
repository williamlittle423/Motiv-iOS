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
                friendRequests.append(new_friend)
                print("Found pending friendship with: \(new_friend.name)")
            } else {
                print("Error fetching users pending friend")
            }
        }
    }
    
    func pendingFriendships(from friendships: [Friendship]) -> [Friendship] {
        return friendships.filter { $0.status == "pending" }
    }
}
