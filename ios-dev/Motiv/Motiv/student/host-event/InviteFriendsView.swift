//
//  InviteFriendsView.swift
//  Motiv
//
//  Created by William Little on 2024-02-05.
//

import SwiftUI

struct InviteFriendsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var eventVM: EventViewModel
    
    var width: CGFloat
    
    func backButton() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack(alignment: .center) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 14, height: 23)
                            .padding(.horizontal, reader.size.width / 14)
                            .foregroundColor(.white)
                            .onTapGesture {
                                backButton()
                            }
                        Spacer()
                    }
                    
                    HStack {
                        Text("Invite friends")
                            .font(.custom("F37Ginger-Bold", size: 24))
                            .padding(.horizontal, reader.size.width / 14)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    ForEach(0..<5, id: \.self) { location in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: width / 1.14, height: 50)
                                .foregroundColor(Color("Grey").opacity(0.3))
                            HStack {
                                Image("Darty")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .scaledToFill()
                                    .clipShape(Circle())
                                Text("John Doe")
                                    .font(.custom("F37Ginger", size: 12))
                                    .foregroundColor(.white)
                                Spacer()
                                Rectangle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.clear)
                                    .background(
                                        Rectangle()
                                            .strokeBorder(Color("Cyan"), lineWidth: 1)
                                    )
                                    .foregroundColor(Color("Cyan"))
                                    .accentColor(Color("Cyan"))
                            }
                            .padding(.horizontal, width / 24)
                        }
                        .frame(width: width / 1.2, height: 50)
                        .onTapGesture {
                            // TODO: Add user to invite list
                        }
                    }
                    Spacer()
                }
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .background(Image("main_background"))
        }
    }
}


