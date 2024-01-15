//
//  UserSettingsView.swift
//  Motiv
//
//  Created by William Little on 2024-01-02.
//

import SwiftUI

struct UserSettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var appState: AppState
    
    @State var displayError: String = ""
    @State var isLoading: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack {
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 14, height: 23)
                            .padding(.horizontal, reader.size.width / 14)
                            .foregroundColor(.white)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                        Text("Settings")
                            .font(.custom("F37Ginger-Light", size: 18))
                            .foregroundColor(.white)
                            .padding(.trailing, reader.size.width / 6)
                        Spacer()
                    }
                    .padding(.top)
                    
                    if isLoading {
                        Spacer()
                        LoadingView()
                            .padding(.bottom, 30)
                        Spacer()
                    } else {
                        Spacer()
                        
                        // Sign out button
                        Button {
                            Task {
                                isLoading = true
                                await displayError = appState.signOut() ?? ""
                                isLoading = false
                            }
                        } label: {
                            SignOutButton(width: reader.size.width)
                                .padding()
                        }
                        
                        // Display any applicable errors
                        if (displayError != "") {
                            Text(displayError)
                                .font(.custom("F37Ginger-Light", size: 12))
                                .foregroundColor(.red)
                                .padding(5)
                        }
                    }
                }
            }
            .background(Image("main_background"))
            .frame(width: reader.size.width, height: reader.size.height)
        }
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
    }
}
