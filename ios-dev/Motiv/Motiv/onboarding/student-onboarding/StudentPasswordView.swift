//
//  StudentPasswordView.swift
//  Motiv
//
//  Created by William Little on 2023-12-31.
//

import SwiftUI

// MARK: Student sign up view for inputting their program
struct StudentPasswordView: View {
    
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var signupVM: StudentSignupViewModel
        
    @Environment(\.presentationMode) var presentationMode
    
    @State var isLoading: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack {
                    
                    // Progress bar
                    ProgressBar(numOfSlides: 6, currentSlide: signupVM.currentSlide, width: reader.size.width / 1.16)
                        .padding()
                    
                    Spacer()
                    
                    if !isLoading {
                        
                        // Title
                        Text("Enter a password")
                            .font(.custom("F37Ginger-Bold", size: 30))
                            .frame(maxWidth: reader.size.width / 1)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding()
                        
                        Spacer()
                        
                        // Secure password textfields
                        MSecureField(title: "Password", text: $signupVM.password)
                            .padding(.horizontal, reader.size.width / 10)
                            .padding(.vertical, 25)
                        
                        MSecureField(title: "Re-enter password", text: $signupVM.rePassword)
                            .padding(.horizontal, reader.size.width / 10)
                            .padding(.bottom, reader.size.height / 3.7)

                        
                        Spacer()
                        
                        Button {
                            Task {
                                isLoading = true
                                // Change this to return a user, if the user is nil, it didnt work.
                                // Set the user to the appState user
                                if let user: User = try await signupVM.signupUser() {
                                    print("User successfully signed up")
                                    appState.user = user
                                    isLoading = false
                                    appState.isStudent = true
                                    appState.isLoggedIn = true
                                } else {
                                    print("it didn't work...")
                                    isLoading = false
                                }
                            }
                        } label: {
                            OnboardingButton(text: "Sign up", width: reader.size.width, isActive: $signupVM.alwaysTrue)
                        }
                        .padding(.bottom)
                        
                        // Display any applicable errors
                        if (signupVM.passwordViewError != "") {
                            Text(signupVM.passwordViewError)
                                .font(.custom("F37Ginger-Light", size: 12))
                                .foregroundColor(.red)
                                .padding(.top, 3)
                                .padding(.bottom, 7)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                        }
                    } else {
                        // Display loading
                        LoadingView()
                        Spacer()
                    }
                }
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .background(Image("main_background"))
        }
    }
}

struct StudentPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        StudentPasswordView()
    }
}
