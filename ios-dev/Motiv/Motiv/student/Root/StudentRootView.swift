//
//  StudentRootView.swift
//  Motiv
//
//  Created by William Little on 2024-01-02.
//

import SwiftUI

struct StudentRootView: View {
    
    @State var currentTab: Tab = .map
    @EnvironmentObject var appState: AppState
    @StateObject var exploreVM = ExploreViewModel()
    @StateObject var notificationsManager = NotificationsManager()
    
    @StateObject var eventVM = EventViewModel()
    
    @State private var hasCalledAppOpened = false
        
    var body: some View {
        ZStack {
            
            NavigationLink(destination: HostPersonalEventView()
                .toolbar(.hidden)
                .environmentObject(eventVM)
                           , isActive: $eventVM.displayCreateEvent)
            {
                EmptyView()
            }
            
            // MARK: Screen determination used with Tab enumeration
            switch currentTab {
                case .map: Text("Map View")
                    
                case .explore: ExploreView()
                        .environmentObject(appState)
                        .environmentObject(exploreVM)
                        .environmentObject(notificationsManager)
                    
                case .house: Text("House")
                    
                case .user: UserProfileView()
                        .environmentObject(appState)
                    
                default: Text("User")
            }
            
            StudentTabView(currentTab: $currentTab)
                .environmentObject(eventVM)
                .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
        .onAppear {
            if !hasCalledAppOpened {
                Task {
                    // MARK: Fetch necessary explore page info
                    await exploreVM.appOpened(user: appState.user!, school: appState.user!.school)
                    
                    // MARK: Fetch notifications
                    await notificationsManager.fetchPendingFriendships(user: appState.user!)
                    
                    hasCalledAppOpened = true
                }
            }
        }
    }
}

struct StudentRootView_Previews: PreviewProvider {
    static var previews: some View {
        StudentRootView()
    }
}
