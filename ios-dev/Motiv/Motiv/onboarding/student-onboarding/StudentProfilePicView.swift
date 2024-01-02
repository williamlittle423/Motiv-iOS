//
//  StudentProfilePicView.swift
//  Motiv
//
//  Created by William Little on 2023-12-31.
//

import SwiftUI
import PhotosUI

struct StudentProfilePicView: View {
    
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @EnvironmentObject var appState: AppState
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
                                        
                    // Title
                    Text("Add a profile photo")
                        .font(.custom("F37Ginger-Bold", size: 30))
                        .frame(maxWidth: reader.size.width / 1)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.top)
                        .padding(.bottom, 3)
                    
                    Spacer()
                    
                    // TODO: Implement photo picker
                    
                    // Display the selected image
                    if let profilePic = signupVM.profilePicture {
                        Image(uiImage: profilePic)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    } else {
                        ZStack {
                            Circle()
                                .stroke(Color("LightGrey"), lineWidth: 1)
                                .frame(width: 120, height: 120)
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                        }
                        
                    }
                    
                    PhotosPicker(selection: $signupVM.photoSelection, matching: .images) {
                        Text(signupVM.profilePicture != nil ? "Change profile photo" : "Add profile photo")
                            .font(.custom("F37Ginger-Light", size: 14))
                            .foregroundColor(Color("LightGrey"))
                            .padding()

                    }
                    
                    Spacer()
                    
                    // Navigation to the email verification page
                    NavigationLink(destination: EmailVerification()
                        .toolbar(.hidden)
                        .environmentObject(appState)
                        .environmentObject(signupVM),
                                   isActive: $navigateToEmail) {
                        EmptyView()
                    }
                    
                    Button {
                        nextSlide()
                    } label: {
                        OnboardingButton(text: "Next", width: reader.size.width, isActive: $signupVM.alwaysTrue).opacity(signupVM.profilePicture != nil ? 1.0 : 0.5)
                    }
                    .padding(.vertical)
                    
                    // Display any applicable errors
                    if (signupVM.imagePickerError != "") {
                        Text(signupVM.imagePickerError)
                            .font(.custom("F37Ginger-Light", size: 12))
                            .foregroundColor(.red)
                            .padding(5)
                    }
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
