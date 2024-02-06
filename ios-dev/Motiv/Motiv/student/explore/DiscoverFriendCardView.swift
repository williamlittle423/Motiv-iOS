//
//  FriendCardView.swift
//  Motiv
//
//  Created by William Little on 2024-01-09.
//

import SwiftUI
import SDWebImageSwiftUI

struct DiscoverFriendCardView: View {
    
    var width: CGFloat
    var user: User
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var exploreVM: ExploreViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: width / 1.2, height: width / 3.6)
                .foregroundColor(Color("CardColor"))
                .opacity(0.27)
            
            VStack {
                // Two items in this
                HStack {
                    if let profilePic = WebImage(url: URL(string: user.profileImageURL ?? "")) {
                        profilePic
                            .resizable()
                            .scaledToFill()
                            .frame(width: width / 10, height: width / 10)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    } else {
                        
                    }

                    // Profile photo
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text(user.name)
                                .foregroundColor(.white)
                                .font(.custom("F37Ginger", size: 16))
                            Spacer()
                            Text(user.school)
                                .foregroundColor(.gray)
                                .font(.custom("F37Ginger", size: 12))
                            // Name and school
                        }
                        // Mutual friends
                        Text("Suggested")
                            .foregroundColor(.gray)
                            .font(.custom("F37Ginger-Light", size: 10))
                    }
                }
                .padding(.horizontal)
                
                // Request not sent
                if !(exploreVM.requestsSent.contains(user._id)) {
                    // MARK: Add friend button
                    Button {
                        Task {
                            await exploreVM.sendFriendRequest(senderID: appState.user!._id, recipientID: user._id)
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: width / 2.7, height: 30)
                                .foregroundColor(Color("Cyan"))
                            Text("Add Friend")
                                .foregroundColor(.black)
                                .font(.custom("F37Ginger-Bold", size: 12))
                        }
                    }
                } else {
                    // Display request sent
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: width / 2.7, height: 30)
                            .foregroundColor(.clear)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("Cyan"), lineWidth: 1))
                        HStack(spacing: 5) {
                            Text("Request sent")
                                .font(.custom("F37Ginger-Bold", size: 12))
                                .foregroundColor(Color("Cyan"))
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 10, height: 10)
                                .foregroundColor(Color("Cyan"))
                        }
                    }
                }
            }
            .frame(width: width / 1.2, height: width / 3)
        }
    }
}
