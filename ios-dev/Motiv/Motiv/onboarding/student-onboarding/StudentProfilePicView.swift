//
//  StudentProfilePicView.swift
//  Motiv
//
//  Created by William Little on 2023-12-31.
//

import SwiftUI

struct StudentProfilePicView: View {
    
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    
    @EnvironmentObject var signupVM: StudentSignupViewModel
    
    @State private var navigateToEmail: Bool = false
        
    @Environment(\.presentationMode) var presentationMode
    
    func nextSlide() {
        signupVM.currentSlide += 1
        navigateToEmail = true
    }
    
    func previousSlide() {
        signupVM.currentSlide -= 1
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack {
                    
                    // Back button
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 14, height: 23)
                            .padding(.horizontal, reader.size.width / 14)
                            .foregroundColor(.white)
                            .onTapGesture {
                                previousSlide()
                            }
                        Spacer()
                    }
                    
                    // Progress bar
                    ProgressBar(numOfSlides: 6, currentSlide: signupVM.currentSlide, width: reader.size.width / 1.16)
                        .padding()
                    
                    Spacer()
                    
                    // Title
                    Text("Add a profile photo")
                        .font(.custom("F37Ginger-Bold", size: 30))
                        .frame(maxWidth: reader.size.width / 1)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.top)
                        .padding(.bottom, 3)
                    
                    Spacer()
                    
                    // TODO: Implement
                    
                    
                    Spacer()
                    
                    // Navigation to the email verification page
                    NavigationLink(destination: EmailVerification()
                        .toolbar(.hidden)
                        .environmentObject(signupVM),
                                   isActive: $navigateToEmail) {
                        EmptyView()
                    }
                    
                    Button {
                        nextSlide()
                    } label: {
                        OnboardingButton(text: "Next", width: reader.size.width, isActive: $signupVM.alwaysTrue)
                    }
                    .padding(.vertical)
                }
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .background(Image("main_background"))
        }
    }
}
struct StudentProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        StudentProfilePicView()
    }
}
