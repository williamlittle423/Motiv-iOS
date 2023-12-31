//
//  RootOnboarding.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import SwiftUI

struct RootOnboarding: View {
    
    @StateObject var onboardingVM = OnboardingViewModel()
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if (onboardingVM.displayEstablishmentSignup) {
            Text("Coming soon.")

        } else if (onboardingVM.displayStudentSignup) {
            StudentNameView().environmentObject(onboardingVM)
        } else if (onboardingVM.displaySignin) {
            Text("Coming soon.")
        } else if (onboardingVM.displaySignupOptions) {
            SignupOptions().environmentObject(onboardingVM)
        } else {
            OnboardingPhases().environmentObject(onboardingVM)
        }
    }
}

struct RootOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        RootOnboarding()
    }
}