//
//  FriendCardView.swift
//  Motiv
//
//  Created by William Little on 2024-01-27.
//

import SwiftUI
import SDWebImageSwiftUI

struct FriendCardView: View {
    
    var width: CGFloat
    var user: User
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: width / 1.1, height: width / 6)
                .foregroundColor(Color("Grey").opacity(0.2))
            HStack {
                
                if let profilePic = WebImage(url: URL(string: (user.profileImageURL))) {
                    profilePic
                        .resizable()
                        .scaledToFill()
                        .frame(width: width / 10, height: width / 10)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                } else {
                    Circle()
                        .stroke(Color("LightGrey"), lineWidth: 1)
                        .frame(width: width / 10, height: width / 10)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 0) {
                    Text(user.name)
                        .font(.custom("F37Ginger", size: 12))
                        .foregroundColor(.white)
                    Text("35 mutual friends")
                        .font(.custom("F37Ginger", size: 12))
                        .foregroundColor(.gray)
                }
                
//                Button {
//                    // Implement send friend request functionality
//                    Void()
//                } label: {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 7.5)
//                            .frame(width: width / 5, height: width / 14)
//                            .foregroundColor(Color("Cyan"))
//                        Text("Add")
//                            .font(.custom("F37Ginger-Bold", size: 12))
//                            .foregroundColor(Color("SheetGrey"))
//                    }
//                    .padding(.trailing)
//                    .padding(.leading, 7.5)
//                }
            }
            .frame(width: width / 1.2, height: width / 6)

        }
    }
}
