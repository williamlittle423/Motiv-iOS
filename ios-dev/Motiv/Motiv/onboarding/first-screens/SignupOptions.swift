//
//  SignupOptions.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import SwiftUI

struct SignupOptions: View {
    
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    
    var body: some View {
        GeometryReader { reader in
            NavigationStack {
                ZStack {
                    VStack(alignment: .leading) {
                        
                        Text("Sign up")
                            .font(.custom("F37Ginger-Bold", size: 32))
                            .foregroundColor(.white)
                            .padding(.top, 30)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 2)
                        Text("Select a sign up option below")
                            .font(.custom("F37Ginger-Light", size: 12))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 25)
                        
                        Spacer()
                        
                        // MARK: Student Signup
                        Button {
                            withAnimation(.easeIn) {
                                onboardingVM.displayStudentSignup = true
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.gray.opacity(0.3))
                                    .frame(width: reader.size.width / 1.1, height: reader.size.height / 4)
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("Cyan"), lineWidth: 1.5)
                                    .frame(width: reader.size.width / 1.1, height: reader.size.height / 4)
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Student")
                                                .font(.custom("F37Ginger-Bold", size: 18))
                                                .foregroundColor(.white)
                                            Image(systemName: "person.3")
                                                .foregroundColor(.white)
                                        }
                                        .padding(.bottom, 2)

                                        Text("Sign up as a student through your university or college and connect with thousands of other students.")
                                            .font(.custom("F37Ginger-Light", size: 12))
                                            .foregroundColor(Color("LightGrey"))
                                            .multilineTextAlignment(.leading)
                                            .padding(.trailing)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 25)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 25)
                                
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }

                        

                        
                        // MARK: Establishment Signup
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.gray.opacity(0.3))
                                .frame(width: reader.size.width / 1.1, height: reader.size.height / 4.5)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1.5)
                                .frame(width: reader.size.width / 1.1, height: reader.size.height / 4.5)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Establishment")
                                            .font(.custom("F37Ginger-Bold", size: 18))
                                            .foregroundColor(.white)
                                        Image(systemName: "house")
                                            .foregroundColor(.white)
                                    }
                                    .padding(.bottom, 4)
                                    
                                    Text("Coming soon.")
                                        .font(.custom("F37Ginger-Light", size: 12))
                                        .foregroundColor(Color("LightGrey"))
                                        .multilineTextAlignment(.leading)
                                        .padding(.trailing)
                                }
                                Spacer()
                                
                                Image(systemName: "lock")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 25)
                                    .foregroundColor(.white)
                                    .padding(.leading)
                            }
                            .padding(.horizontal, 25)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, reader.size.height / 8)
                        
                        Spacer()
                    }
                }
                .frame(width: reader.size.width, height: reader.size.height)
                    .background(Image("main_background"))
            }
        }
    }
}

struct SignupOptions_Previews: PreviewProvider {
    static var previews: some View {
        SignupOptions()
    }
}
