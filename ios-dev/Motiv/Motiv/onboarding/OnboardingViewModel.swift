//
//  OnboardingViewModel.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    
    // MARK: Which view to display
    @Published var displayEstablishmentSignup: Bool = false
    @Published var displaySignupOptions: Bool = false
    @Published var displayStudentSignup: Bool = false
    @Published var displaySignin: Bool = false
    @Published var onboardingTab: Int = 0
    
}
