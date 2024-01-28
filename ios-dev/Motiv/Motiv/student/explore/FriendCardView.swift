//
//  FriendCardView.swift
//  Motiv
//
//  Created by William Little on 2024-01-09.
//

import SwiftUI
import SDWebImageSwiftUI

struct FriendCardView: View {
    
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
                        Text("15 Mutual Friends")
                            .foregroundColor(.gray)
                            .font(.custom("F37Ginger", size: 12))
                    }
                }
                .padding(.horizontal)
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

            }
            .frame(width: width / 1.2, height: width / 3)
        }
    }
}
