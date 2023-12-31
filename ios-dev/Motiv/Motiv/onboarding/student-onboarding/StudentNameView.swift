//
//  StudentNameView.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import SwiftUI

struct StudentNameView: View {
    
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    
    @StateObject var signupVM = StudentSignupViewModel()
    
    @State private var navigateToProgram: Bool = false
    
    func nextSlide() {
        signupVM.currentSlide += 1
        navigateToProgram = true
    }
    
    
    var body: some View {
        NavigationStack {
            GeometryReader { reader in
                ZStack {
                    // Progress bar
                    VStack {
                        ProgressBar(numOfSlides: 6, currentSlide: signupVM.currentSlide, width: reader.size.width / 1.16)
                            .padding()
                        
                        Spacer()
                        
                        // Title
                        Text("What is your name?")
                            .font(.custom("F37Ginger-Bold", size: 30))
                            .frame(maxWidth: reader.size.width / 1)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding()
                        
                        Spacer()
                        
                        // Name textfield
                        MTextField(title: "Name", text: $signupVM.name, autoCap: false)
                            .padding(.horizontal, reader.size.width / 10)
                            .padding(.bottom, reader.size.height / 3)
                        
                        
                        Spacer()
                        
                        NavigationLink(destination: StudentProgramView()
                            .toolbar(.hidden)
                            .environmentObject(signupVM), isActive: $navigateToProgram) {
                            EmptyView()
                        }
                        
                        Button {
                            if (signupVM.name != "") {
                                nextSlide()
                            }
                        } label: {
                            OnboardingButton(text: "Next", width: reader.size.width, isActive: $signupVM.alwaysTrue)
                                .padding(.bottom)
                        }
                    }
                }
                .frame(width: reader.size.width, height: reader.size.height)
                .background(Image("main_background"))
            }
        }
    }
}

struct StudentNameView_Previews: PreviewProvider {
    static var previews: some View {
        StudentNameView()
    }
}
