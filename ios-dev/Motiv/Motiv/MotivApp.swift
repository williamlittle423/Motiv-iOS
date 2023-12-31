//
//  MotivApp.swift
//  Motiv
//
//  Created by William Little on 2023-12-27.
//

import SwiftUI

@main
struct MotivApp: App {
    
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
