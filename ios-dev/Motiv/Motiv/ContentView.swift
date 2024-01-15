//
//  ContentView.swift
//  Motiv
//
//  Created by William Little on 2023-12-27.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
        
    var body: some View {
        
        if appState.isInitializing {
            LaunchScreen()
        } else if (appState.isLoggedIn && appState.isStudent) {
            // MARK: User is signed in and is a student
            NavigationStack {
                StudentRootView()
                    .environmentObject(appState)
            }
        } else if (appState.isLoggedIn && appState.isEstablishment) {
            // MARK: User is signed in and is an establishment
            Text("Welcome to Motiv for establishments")
        } else {
            // MARK: User is not signed in
            RootOnboarding().environmentObject(appState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
