//
//  EmailVerification.swift
//  Motiv
//
//  Created by William Little on 2023-12-27.
//

import SwiftUI

@MainActor
struct EmailVerification: View {
    
    // MARK: Displays textfield for user email
    
    @State var displayConfirmSheet: Bool = false
    @State var codeSent: Bool = false
    @State var otpEntered: Bool = false
    @State var emailEntered: Bool = true
    @State var verCode: String = ""
    @State var navigateToPassword: Bool = false
    @FocusState var isTextFieldFocused: Bool
    @State var err: String = ""
    
    @EnvironmentObject var signupVM: StudentSignupViewModel
    @EnvironmentObject var appState: AppState
    
    @Environment(\.presentationMode) var presentationMode
    
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
                    ProgressBar(numOfSlides: 6, currentSlide: 4, width: reader.size.width / 1.16)
                        .padding()
                    
                    // Navigation to the password page
                    NavigationLink(destination: StudentPasswordView()
                        .toolbar(.hidden)
                        .environmentObject(appState)
                        .environmentObject(signupVM),
                                   isActive: $navigateToPassword) {
                        EmptyView()
                    }
                    
                    // Title
                    VStack {
                        if (signupVM.isLoading) {
                            Spacer()
                            LoadingView()
                            Spacer()
                        } else if (codeSent) {
                            
                            // MARK: Once the code is sent, display verification code input
                            Image(systemName: "checkmark.shield.fill")
                                .resizable()
                                .frame(width: 24, height: 30)
                                .foregroundColor(.white)
                                .padding(.top)
                            // Title text
                            Text("Enter verification code")
                                .font(.custom("F37Ginger-Bold", size: 28))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                            
                            VStack(spacing: 1) {
                                Text("Your temporary verification code was sent to")
                                    .font(.custom("F37Ginger-Light", size: 12))
                                    .foregroundColor(.gray)
                                Text(signupVM.email)
                                    .font(.custom("F37Ginger-Light", size: 12))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            
                            // MARK: Custom OTP textfield
                            OTPTextField(numberOfFields: 6, otp: $signupVM.verificationInput)
                                .onChange(of: signupVM.verificationInput) { newOtp in
                                    if newOtp.count == 6 {
                                        otpEntered = true
                                    } else {
                                        otpEntered = false
                                    }
                                }
                                .focused($isTextFieldFocused)
                                .padding(.top)
                            
                            Spacer()
                            
                            Button {
                                // Checks if the OTP matches the one sent
                                navigateToPassword = true
                                
                                // MARK: THIS IS TEMPORARY
//                                checkOTP(otpEntered: signupVM.verificationInput, validOTP: verCode) { result in
//                                    switch result {
//                                        case .success(let successMessage):
//                                            print(successMessage)
//                                            navigateToPassword = true
//                                        case .failure(let error):
//                                            signupVM.emailViewError = error.localizedDescription
//                                            print(error.localizedDescription)
//                                        }
//                                }
                            } label: {
                                OnboardingButton(text: "Next", width: reader.size.width, isActive: $otpEntered)
                            }
                            .disabled(!otpEntered)
                            
                            if (signupVM.emailViewError != "") {
                                Text(signupVM.emailViewError)
                                    .font(.custom("F37Ginger-Light", size: 12))
                                    .foregroundColor(.red)
                                    .padding(.vertical, 4)
                            }
                            
                            
                        } else {
                            
                            // MARK: First display for inputting email
                            Text("Enter your school email")
                                .font(.custom("F37Ginger-Bold", size: 30))
                                .frame(maxWidth: reader.size.width / 2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.top, 30)
                            
                            Spacer()
                            
                            // Email textfield
                            MTextField(title: "Email", text: $signupVM.email, autoCap: false)
                                .padding(.horizontal, reader.size.width / 10)
                                .padding(.bottom, reader.size.height / 3)
                            
                            
                            Spacer()
                            
                            // Display when the confirmation is not active
                            Button {
                                signupVM.verifyEmail(email: signupVM.email) { school in
                                    if school.isEmpty {
                                        // Handle the case where the email is not associated with a known school
                                        signupVM.emailViewError = "No valid school associated with this email."
                                        print("No known school")
                                    } else {
                                        // Save the returned school name
                                        signupVM.emailViewError = ""
                                        signupVM.school = school
                                        displayConfirmSheet = true
                                        // Proceed with the next steps since the email is verified
                                        verCode = generateRandomDigits(6)
                                    }
                                }
                                
                            } label: {
                                OnboardingButton(text: "Next", width: reader.size.width, isActive: $emailEntered)
                            }
                            .sheet(isPresented: $displayConfirmSheet) {
                                // Content of the sheet
                                SchoolConfirmSheet(school: $signupVM.school, codeSent: $codeSent, email: $signupVM.email, verCode: $verCode) { confirmed in
                                    displayConfirmSheet = false
                                    if confirmed {
                                        // Handle the confirmation action
                                        print("Confirmed with email: \(signupVM.email)")
                                    }
                                }
                                .environmentObject(signupVM)
                                .presentationDetents([.fraction(0.3)])
                            }
                            
                            // Display any errors
                            if (signupVM.emailViewError != "") {
                                Text(signupVM.emailViewError)
                                    .font(.custom("F37Ginger-Light", size: 12))
                                    .foregroundColor(.red)
                                    .padding(5)
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

struct SchoolConfirmSheet: View {
    
    @Binding var school: String
    @Binding var codeSent: Bool
    @Binding var email: String
    @Binding var verCode: String
    
    @EnvironmentObject var signupVM: StudentSignupViewModel
    
    // This is for input to the onboarding button view
    @State var confirm: Bool = true
    
    // AWS
    private let endpoint: String = "https://jfj07z8kt7.execute-api.us-east-2.amazonaws.com/Development"
    
    let onConfirm: (Bool) -> Void
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack() {
                    Text("You are confirming that you attend")
                        .foregroundColor(.white)
                        .font(.custom("F37Ginger-Light", size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.top, 60)
                    Text(school)
                        .foregroundColor(.white)
                        .font(.custom("F37Ginger-Bold", size: 16))
                        .multilineTextAlignment(.center)
                    
                    
                    Spacer()
                    
                    // MARK: Sends the verification email to the user
                    Button {
                        Task {
                            do {
                                let response = try await signupVM.sendVerification(apiEndpoint: endpoint, payload: ["email": signupVM.email, "verificationCode": verCode])
                                print("Email API call response: \(response)")
                                onConfirm(true)
                                codeSent = true
                            } catch {
                                signupVM.emailViewError = error.localizedDescription
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        OnboardingButton(text: "Confirm", width: 350, isActive: $confirm)
                            .padding(.bottom, 40)
                    }
                }
                
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .background(Color("SheetGrey").edgesIgnoringSafeArea(.all))
        }
    }
}

// MARK: Used to generage the OTP
func generateRandomDigits(_ length: Int) -> String {
    var result = ""
    for _ in 1...length {
        result += String(Int.random(in: 0...9))
    }
    return result
}

// MARK: Closure for verifying the OTP entered matches the generated OTP sent to the users email
func checkOTP(otpEntered: String, validOTP: String, completion: @escaping (Result<String, Error>) -> Void) {
    if otpEntered == validOTP {
        completion(.success("Email successfully verified."))
    } else {
        completion(.failure(OTPError.invalidCode))
    }
}


struct EmailVerification_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerification()
    }
}
