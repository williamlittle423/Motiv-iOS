//
//  OnboardingPhases.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import SwiftUI

struct OnboardingPhases: View {
    
    @State var buttonActive = true
    
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack {
                    // Header
                    Text("motiv")
                        .font(.custom("F37Ginger-Bold", size: 18))
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                    
                    // Illustration image
                    switch (onboardingVM.onboardingTab) {
                    case 0: Image("OnboardingGr1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: reader.size.width / 1.2, height: reader.size.height / 3.5)
                            .padding()
                    case 1: Image("OnboardingGr2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: reader.size.height / 3)
                            .padding()
                    case 2: Image("OnboardingGr3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: reader.size.width / 1.4)
                            .padding()
                    default: Image("OnboardingGr1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: reader.size.width / 1.7)
                            .padding()
                    }
                    
                    
                    Spacer()
                    
                    // Onboarding text
                    switch (onboardingVM.onboardingTab) {
                    case 0:
                        Text("Connecting you directly to bars and clubs")
                            .font(.custom("F37Ginger-Bold", size: 36))
                            .foregroundColor(.white)
                            .padding(.bottom, reader.size.height / 9)
                            .multilineTextAlignment(.leading)
                    case 1:
                        Text("Host parties with your university house")
                            .font(.custom("F37Ginger-Bold", size: 36))
                            .foregroundColor(.white)
                            .frame(maxWidth: reader.size.width / 1.1)
                            .padding(.bottom, reader.size.height / 9)
                            .multilineTextAlignment(.leading)
                    case 2:
                        Text("Enjoy your years of university with Motiv")
                            .font(.custom("F37Ginger-Bold", size: 36))
                            .foregroundColor(.white)
                            .padding(.bottom, reader.size.height / 9)
                            .multilineTextAlignment(.leading)
                    default: EmptyView()
                    }
                    

                    
                    HStack {
                        OnboardingProgress(currentTab: $onboardingVM.onboardingTab)
                            .padding(.vertical)
                            .padding(.leading, 25)
                        Spacer()
                        if (onboardingVM.onboardingTab < 2) {
                            // Mark: Pre signup button
                            Button {
                                withAnimation {
                                    onboardingVM.onboardingTab += 1
                                }
                            } label: {
                                OnboardingButton(text: "Next", width: reader.size.width / 1.1, isActive: $buttonActive)
                                    .padding(.horizontal, 25)
                                    .padding()
                            }
                        } else {
                            
                            // MARK: Display sign up button and login button
                            VStack {
                                // Sign up button
                                Button {
                                    withAnimation {
                                        onboardingVM.displaySignupOptions = true
                                    }
                                } label: {
                                    SignupButton(width: reader.size.width)
                                        .padding(.bottom, 10)
                                        .padding(.horizontal, 20)
                                }
                                
                                // Login option
                                HStack(spacing: 5) {
                                    Text("Already signed up?")
                                        .font(.custom("F37Ginger-Light", size: 14))
                                        .foregroundColor(.gray)
                                    Button {
                                        Void()
                                    } label: {
                                        Text("Sign in")
                                            .font(.custom("F37Ginger-Bold", size: 14))
                                            .foregroundColor(.white)
                                            .padding(.trailing, 20)
                                            
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .background(Image("main_background"))
        }
    }
}
