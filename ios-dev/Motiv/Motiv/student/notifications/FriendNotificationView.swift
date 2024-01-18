//
//  FriendNotificationView.swift
//  Motiv
//
//  Created by William Little on 2024-01-17.
//

import SwiftUI

struct FriendNotificationView: View {
    
    var width: CGFloat
    
    var user: User
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: width / 1.15, height: width / 3.7)
                .foregroundColor(Color("CardColor"))
                .opacity(0.26)
            VStack(spacing: 15) {
                HStack {
                    if let profilePic = user.profileImage {
                        Image(uiImage: profilePic)
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
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: width / 3.2, height: width / 13)
                            .foregroundColor(Color("Cyan"))
                        Text("Accept")
                            .font(.custom("F37Ginger-Bold", size: 12))
                    }

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
                
            }

            
        }
        .frame(width: width / 1.15, height: width / 3.7)
    }
}

//struct FriendNotificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendNotificationView(width: 400)
//    }
//}
