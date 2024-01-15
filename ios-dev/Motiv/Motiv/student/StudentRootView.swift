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
        
    var body: some View {
        ZStack {
            
            // MARK: Screen determination used with Tab enumeration
            switch currentTab {
            case .map: Text("Map View")
                
            case .explore: ExploreView()
                    .environmentObject(appState)
                    .environmentObject(exploreVM)
                
            case .house: Text("House")
                
            case .user: UserProfileView()
                    .environmentObject(appState)
                
            default: Text("User")
            }
            
            StudentTabView(currentTab: $currentTab)
                .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
        .onAppear {
            Task {
                print("Attempting to call fetchFriends")
                await exploreVM.appOpened(userID: appState.user!._id, school: appState.user!.school)
            }
        }
    }
}

struct StudentRootView_Previews: PreviewProvider {
    static var previews: some View {
        StudentRootView()
    }
}
