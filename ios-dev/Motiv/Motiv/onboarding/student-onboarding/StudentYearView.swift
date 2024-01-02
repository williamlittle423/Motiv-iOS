//
//  StudentYearView.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import SwiftUI

// MARK: The user inputs their grad year using a simple picker
struct StudentYearView: View {
    
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var signupVM: StudentSignupViewModel
    
    @State private var navigateToProfilePic: Bool = false
        
    @Environment(\.presentationMode) var presentationMode
    
    func nextSlide() {
        signupVM.currentSlide += 1
        navigateToProfilePic = true
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
                    Text("What year are you graduating?")
                        .font(.custom("F37Ginger-Bold", size: 30))
                        .frame(maxWidth: reader.size.width / 1)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.top)
                        .padding(.bottom, 3)
                    Text("Connect with students in your year")
                        .font(.custom("F37Ginger-Light", size: 14))
                        .frame(maxWidth: reader.size.width)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // MARK: Allows students to
                    Picker("", selection: $signupVM.gradYear) {
                        ForEach(2023...2027, id: \.self) {
                            Text(String($0))
                                .font(.custom("F37Ginger-Light", size: 14))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom)
                    .pickerStyle(InlinePickerStyle())
                    
                    
                    Spacer()
                    
                    // Navigation to the grad year page
                    NavigationLink(destination: StudentProfilePicView()
                        .toolbar(.hidden)
                        .environmentObject(appState)
                        .environmentObject(signupVM),
                                   isActive: $navigateToProfilePic) {
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


struct StudentYearView_Previews: PreviewProvider {
    static var previews: some View {
        StudentYearView()
    }
}
