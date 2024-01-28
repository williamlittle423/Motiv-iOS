//
//  FriendNotificationView.swift
//  Motiv
//
//  Created by William Little on 2024-01-17.
//

import SwiftUI
import SDWebImageSwiftUI

struct FriendNotificationView: View {
    
    var width: CGFloat
    var user: User
    
    @State var isLoading: Bool = false
    @State var isFriends: Bool = false
    
    @EnvironmentObject var notificationsManager: NotificationsManager
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: width / 1.15, height: width / 3.7)
                .foregroundColor(Color("CardColor"))
                .opacity(0.26)
            if !isLoading {
                VStack(spacing: 15) {
                    
                    HStack {
                        // Profile Image
                        if let profilePic =  WebImage(url: URL(string: user.profileImageURL ?? "")) {
                            profilePic
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        VStack(alignment: .leading) {
                            Text("\(user.name) sent you a friend request")
                                .font(.custom("F37Ginger-Bold", size: 12))
                                .foregroundColor(.white)
                            Text("23 Mutual Friends")
                                .font(.custom("F37Ginger", size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Display buttons until they add or remove them as a friend
                    if !isFriends {
                        // MARK: Buttons
                        HStack {
                            
                            // Accept request
                            Button {
                                Task {
                                    self.isLoading = true
                                    let success = await notificationsManager.acceptFriendship(currUser: appState.user!, friend: user)
                                    if success {
                                        withAnimation {
                                            self.isFriends = true
                                        }
                                    }
                                    self.isLoading = false
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: width / 3.2, height: width / 13)
                                        .foregroundColor(Color("Cyan"))
                                    Text("Accept")
                                        .foregroundColor(Color("SheetGrey"))
                                        .font(.custom("F37Ginger-Bold", size: 12))
                                }
                            }

                            // Delete request
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: width / 3.2, height: width / 13)
                                    .foregroundColor(Color("LightGrey"))
                                    .opacity(0.4)
                                Text("Delete")
                                    .font(.custom("F37Ginger-Bold", size: 12))
                                    .foregroundColor(.white)
                            }
                        }
                    } else {
                        // Display a request success (friends)
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: width / 1.8, height: width / 13)
                                .foregroundColor(.clear)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("Cyan"), lineWidth: 1))
                            HStack(spacing: 5) {
                                Text("Friends")
                                    .font(.custom("F37Ginger-Bold", size: 12))
                                    .foregroundColor(Color("Cyan"))
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 11, height: 11)
                                    .foregroundColor(Color("Cyan"))
                            }
                        }
                    }
                }
            } else {
                    LoadingView()
            }
        }
        .frame(width: width / 1.15, height: width / 3.7)
    }
}
