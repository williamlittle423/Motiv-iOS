//
//  ExploreView.swift
//  Motiv
//
//  Created by William Little on 2024-01-03.
//

import SwiftUI

struct ExploreView: View {
    
    @State var searchText: String = ""
    
    @EnvironmentObject var exploreVM: ExploreViewModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var notificationsManager: NotificationsManager
    
    @State var notificationsActive: Bool = false
    
    enum ExploreTab {
        case friends
        case events
        case houses
        
        var str: String {
            switch self {
            case .friends:
                return "Friends"
            case .events:
                return "Events"
            case .houses:
                return "Houses"
            }
        }
    }
    
    @State var selectedTab: ExploreTab = .events
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        // Title
                        Text("Explore")
                            .font(.custom("F37Ginger-Bold", size: 24))
                            .foregroundColor(.white)
                            .padding(.top, 5)
                            .padding(.leading, reader.size.width / 9)
                        Spacer()
                        
                        NavigationLink(destination: NotificationsView()
                            .environmentObject(notificationsManager)
                            .environmentObject(exploreVM)
                            .environmentObject(appState)
                            .toolbar(.hidden),
                                       isActive: $notificationsActive) {
                            EmptyView()
                        }
    
                        
                        
                        // Notifications bell
                        ZStack {
                            Image(systemName: "bell")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 19, height: 23)
                            Circle()
                                .foregroundColor(Color("Cyan"))
                                .frame(width: 9, height: 9)
                                .offset(x: 6, y: -8)
                        }
                        .padding(.top, 5)
                        .padding(.trailing, reader.size.width / 16)
                        .onTapGesture {
                            notificationsActive = true
                        }
                    }
                    
                    // Search textfield
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                            .padding(.leading, reader.size.width / 14)
                        
                        TextField("", text: $searchText)
                            .padding(12)
                            .frame(height: reader.size.height / 17)
                            .font(.custom("F37Ginger", size: 14))
                            .textInputAutocapitalization(.none)
                            .foregroundColor(.white)
                            .accentColor(.white)
                    }
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(Color.white, lineWidth: 1)
                            .padding(.horizontal, reader.size.width / 16)
                    )
                    
                    HStack {
                        Text("Discover")
                            .font(.custom("F37Ginger-Bold", size: 14))
                            .foregroundColor(.white)
                            .padding(.leading, reader.size.width / 16)
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    // MARK: Tab view
                    HStack(spacing: 0) {
                        // Friends
                        Text(ExploreTab.friends.str)
                            .foregroundColor(selectedTab == .friends ? .black : .white)
                            .font(.custom("F37Ginger-Bold", size: 12))
//                            .padding(.vertical, 2)
                            .frame(width: selectedTab == .friends ? reader.size.width / 2.5 : reader.size.width / 4.3, height: 30)
                            .background(selectedTab == .friends ? Color("Cyan") : Color.clear)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: selectedTab == .friends ? 0 : 1)
                            )
                            .padding(.leading, reader.size.width / 14)
                            .padding(.trailing, 3)
                            .onTapGesture {
                                withAnimation {
                                    selectedTab = .friends
                                }
                            }
                        
                        Text(ExploreTab.events.str)
                            .foregroundColor(selectedTab == .events ? .black : .white)
                            .font(.custom("F37Ginger-Bold", size: 12))
                            .padding(.vertical, 2)
                            .frame(width: selectedTab == .events ? reader.size.width / 2.5 : reader.size.width / 4.3, height: 30)
                            .background(selectedTab == .events ? Color("Cyan") : Color.clear)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: selectedTab == .events ? 0 : 1)
                            )
                            .padding(.horizontal, 3)
                            .onTapGesture {
                                withAnimation {
                                    selectedTab = .events
                                }
                            }
                        
                        Text(ExploreTab.houses.str)
                            .foregroundColor(selectedTab == .houses ? .black : .white)
                            .font(.custom("F37Ginger-Bold", size: 12))
                            .padding(.vertical, 2)
                            .frame(width: selectedTab == .houses ? reader.size.width / 2.5 : reader.size.width / 4.3, height: 30)
                            .background(selectedTab == .houses ? Color("Cyan") : Color.clear)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: selectedTab == .houses ? 0 : 1)
                            )
                            .padding(.trailing, reader.size.width / 14)
                            .padding(.leading, 3)
                            .onTapGesture {
                                withAnimation {
                                    selectedTab = .houses
                                }
                            }
                    }
                    
                    // MARK: Display friends view
                    if (selectedTab == .friends) {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 0) {
                                if !exploreVM.fetchingFriends {
                                    ForEach(exploreVM.friendsToDisplay, id: \._id) { friend in
                                        FriendCardView(width: reader.size.width, user: friend)
                                            .environmentObject(appState)
                                            .environmentObject(exploreVM)
                                    }
                                } else {
                                    ForEach(0..<5, id: \.self) { _ in
                                        LoadingCardView(width: reader.size.width)
                                    }
                                }
                            }
                        }
                        .padding(.top, reader.size.height / 75)
                        .padding(.bottom, reader.size.height / 21)
                    }
                    
                    Spacer()
                }
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .background(Image("main_background"))
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
