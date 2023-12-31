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
    
    @EnvironmentObject var signupVM: StudentSignupViewModel
        
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack {
                    
                    // Progress bar
                    ProgressBar(numOfSlides: 6, currentSlide: signupVM.currentSlide, width: reader.size.width / 1.16)
                        .padding()
                    
                    Spacer()
                    
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
                        .padding(.vertical, 10)
                    
                    MSecureField(title: "Re-enter password", text: $signupVM.rePassword)
                        .padding(.horizontal, reader.size.width / 10)
                        .padding(.bottom, reader.size.height / 3.7)

                    
                    Spacer()
                    
                    Button {
                        withAnimation(.linear) {
                            // TODO: Implement sign up logic with mongodb and keychain
                            Void()
                        }
                    } label: {
                        OnboardingButton(text: "Next", width: reader.size.width, isActive: $signupVM.alwaysTrue)
                        
                    }
                    .padding(.bottom)
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
