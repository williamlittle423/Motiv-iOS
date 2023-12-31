//
//  StudentProgramView.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import SwiftUI


// MARK: Student sign up view for inputting their program
struct StudentProgramView: View {
    
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    
    @EnvironmentObject var signupVM: StudentSignupViewModel
    
    @State private var navigateToGrad: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    func nextSlide() {
        signupVM.currentSlide += 1
        navigateToGrad = true
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
                    Text("What program are you in?")
                        .font(.custom("F37Ginger-Bold", size: 30))
                        .frame(maxWidth: reader.size.width / 1)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                    
                    // Name textfield
                    MTextField(title: "Program", text: $signupVM.program, autoCap: true)
                        .padding(.horizontal, reader.size.width / 10)
                        .padding(.bottom, reader.size.height / 3)
                    
                    
                    Spacer()
                    
                    // Navigation to the grad year page
                    NavigationLink(destination: StudentYearView()
                        .toolbar(.hidden)
                        .environmentObject(signupVM),
                                   isActive: $navigateToGrad) {
                        EmptyView()
                    }
                    
                    Button {
                        nextSlide()
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


struct StudentProgramView_Previews: PreviewProvider {
    static var previews: some View {
        StudentProgramView()
    }
}
