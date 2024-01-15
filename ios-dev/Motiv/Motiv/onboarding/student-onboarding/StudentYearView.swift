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
    
    @State private var selectedYear: GradYear = .twoFive

    
    @Environment(\.presentationMode) var presentationMode
    
    func nextSlide() {
        signupVM.currentSlide += 1
        navigateToProfilePic = true
        print("Selected year: \(selectedYear)")
        signupVM.gradYear = selectedYear.desc
        print("Grad year updated: \(signupVM.gradYear)")
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
                    
                    // MARK: Allows students to select a year from 2023-2027
                    Picker("Grad Year", selection: $selectedYear) {
                        ForEach(GradYear.allCases) { gradYear in
                            Text(gradYear.desc)
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

enum GradYear: String, CaseIterable, Identifiable {
    case twoThree = "2023"
    case twoFour = "2024"
    case twoFive = "2025"
    case twoSix = "2026"
    case twoSeven = "2027"
    
    var desc: String {
        return self.rawValue
    }
    
    var id: Self { self }
}

struct StudentYearView_Previews: PreviewProvider {
    static var previews: some View {
        StudentYearView()
    }
}
