//
//  UserProfileVM.swift
//  Motiv
//
//  Created by William Little on 2024-01-03.
//

import SwiftUI
import Foundation

class UserProfileVM: ObservableObject {
    
    @Published var usersFriends: [User] = []
    
    
    func screenOpened(user: User) async {
        Task {
            await fetchFriends(user: user)
        }
    }
    
    // MARK: Obtain the users friends for display
    func fetchFriends(user: User) async {
        
        DispatchQueue.main.async {
            self.usersFriends = []
        }
        
        let dbService = DatabaseService()
        
        var fetchedFriends: [User] = []
        
        for friend in user.friends {
            print("FRIEND: \(friend)")
            // Only display friend if they are an accepted friend
            if friend.status == "friends" {
                // Fetch the user from MongoDB and add it to the list
                if let friendUserObj = await dbService.fetchUser(userID: friend.friend_id) {
                    // Publish on the main thread
                    fetchedFriends.append(friendUserObj)

                } else {
                    print("ERROR FETCHING USER - origin UserProfileVM.fetchFriends")
                }
            }
        }
        self.usersFriends = fetchedFriends
    }
}
