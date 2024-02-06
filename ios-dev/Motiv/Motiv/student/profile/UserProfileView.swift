//
//  UserProfileView.swift
//  Motiv
//
//  Created by William Little on 2024-01-02.
//

import SwiftUI
import SDWebImageSwiftUI

enum profileTab {
    case friends
    case house
}

struct UserProfileView: View {
    
    @EnvironmentObject var appState: AppState
    
    @StateObject var profileVM = UserProfileVM()
    
    @State var selectedTab: profileTab = .friends
    @State var navigateToSettings: Bool = false
    
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack(spacing: 5) {
                    HStack {
                        
                        // Edit profile navigation link
                        NavigationLink(destination: UserSettingsView()
                            .toolbar(.hidden)
                            .environmentObject(appState), isActive: $navigateToSettings) {
                                EmptyView()
                            }
                        
                        // Edit Profile
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: reader.size.width / 17)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                        
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: reader.size.width / 17)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .onTapGesture {
                                navigateToSettings = true
                            }
                    }

                    if let profilePic = WebImage(url: URL(string: (appState.user?.profileImageURL)!)) {
                        profilePic
                            .resizable()
                            .scaledToFill()
                            .frame(width: reader.size.width / 4, height: reader.size.width / 4)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    } else {
                        Circle()
                            .stroke(Color("LightGrey"), lineWidth: 1)
                            .frame(width: reader.size.width / 4, height: reader.size.width / 4)
                            .padding(.bottom)
                    }
                    
                    Text(appState.user?.name ?? "")
                        .font(.custom("F37Ginger-Bold", size: 22))
                        .foregroundColor(.white)
                        .padding(10)
                    
                    HStack {
                        
                        // MARK: School view
                        HStack {
                            Image(systemName: "graduationcap.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                            Text("Queen's University")
                                .font(.custom("F37Ginger", size: 12))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("Opacity"))
                                .opacity(0.27)
                        )
                        
                        // MARK: Program & Year
                        HStack {
                            Image(systemName: "book.closed.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                            Text("\(appState.user!.program) \(appState.user!.gradYear)")
                                .font(.custom("F37Ginger", size: 12))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("Opacity"))
                                .opacity(0.27)
                        )
                    }

                    InstagramDisplay(width: reader.size.width, connected: false)
                        .padding(5)
                    
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 2) {
                            Text("23")
                                .font(.custom("F37Ginger-Bold", size: 14))
                                .foregroundColor(.white)
                            Text("Friends")
                                .font(.custom("F37Ginger-Light", size: 14))
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            self.selectedTab = .friends
                        }
                        
                        Spacer()
                        VStack(alignment: .center, spacing: 2) {
                            Text("3")
                                .font(.custom("F37Ginger-Bold", size: 14))
                                .foregroundColor(.white)
                            Text("Events Attended")
                                .font(.custom("F37Ginger-Light", size: 14))
                                .foregroundColor(.white)
                        }
                        .padding(.leading, reader.size.width / 9)
                        Spacer()
                    }
                    .padding(.vertical)
                    .padding(.leading)
                    
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: reader.size.width, height: 1)
                    
                    HStack(alignment: .center) {
                        
                        // Friends tab
                        VStack(alignment: .center) {
                            Image(systemName: "person.3.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: reader.size.width / 27)
                                .foregroundColor(.white)
                                .padding(10)
                            
                            Rectangle()
                                .foregroundColor(.white)
                                .frame(width: reader.size.width / 2, height: 1)
                                .opacity(selectedTab == .friends ? 1.0 : 0.0)
                        }
                        .onTapGesture {
                            //                            withAnimation(.linear) {
                            self.selectedTab = .friends
                            //                            }
                        }
                        
                        VStack(alignment: .center) {
                            Image(systemName: "house.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: reader.size.width / 27)
                                .foregroundColor(.white)
                                .padding(10)
                            
                            Rectangle()
                                .foregroundColor(.white)
                                .frame(width: reader.size.width / 2, height: 1)
                                .opacity(selectedTab == .friends ? 0.0 : 1.0)
                        }
                        .onTapGesture {
                            //                            withAnimation(.easeIn) {
                            self.selectedTab = .house
                            //                            }
                        }
                        
                        Spacer()

                    }
                    
                    ScrollView(.vertical) {
                        VStack(spacing: 10) {
                            
                            // MARK: Display the users friends
                            if self.selectedTab == .friends {
                                ForEach(profileVM.usersFriends, id: \.self) { friend in
                                    FriendCardView(width: reader.size.width, user: friend)
                                }
                            } else {
                                Text("User is not in a house.")
                                    .foregroundColor(.gray)
                                    .font(.custom("F37Ginger-Light", size: 12))
                                    .padding()
                            }
                        }
                        .padding(.top, 7.5)
                    }
//                    Spacer()
                }
            }
            .background(Image("main_background"))
            .frame(width: reader.size.width, height: reader.size.height)
            .onAppear {
                Task {
                    await profileVM.fetchFriends(user: appState.user!)
                }
            }
        }
    }
}

