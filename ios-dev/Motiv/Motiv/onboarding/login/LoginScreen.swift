//
//  LoginScreen.swift
//  Motiv
//
//  Created by William Little on 2024-01-03.
//

import SwiftUI

struct LoginScreen: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var displayError: String = ""
    @State var isLoading: Bool = false
    
    @State var activate: Bool = true
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack(spacing: 5) {
                    
                    // Back button
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 14, height: 23)
                            .padding(.horizontal, reader.size.width / 14)
                            .foregroundColor(.white)
                            .onTapGesture {
                                onboardingVM.displaySignin = false
                            }
                        Spacer()
                    }
                    if isLoading {
                        Spacer()
                        LoadingView()
                            .padding(.bottom, 30)
                        Spacer()
                    } else {
                        // Titles
                        Text("Sign in")
                            .font(.custom("F37Ginger-Bold", size: 28))
                            .foregroundColor(.white)
                            .padding(.top)
                        Text("Welcome back! It's good to see you again.")
                            .font(.custom("F37Ginger-Light", size: 12))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        MTextField(title: "School or Establishment Email", text: $email, autoCap: false)
                            .padding()
                        
                        MSecureField(title: "Password", text: $password)
                            .padding(.horizontal)
                            .padding(.bottom, reader.size.height / 8)
                        
                        Spacer()
                        
                        Button {
                            Task {
                                isLoading = true
                                do {
                                    try await appState.login(email: email, password: password)
                                    isLoading = false
                                } catch {
                                    displayError = error.localizedDescription
                                    isLoading = false
                                }
                            }
                        } label: {
                            OnboardingButton(text: "Sign in", width: reader.size.width, isActive: $activate)
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

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
