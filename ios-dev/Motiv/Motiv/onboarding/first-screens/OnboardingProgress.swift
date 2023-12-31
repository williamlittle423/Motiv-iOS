//
//  OnboardingProgress.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import SwiftUI

struct OnboardingProgress: View {
    
    @Binding var currentTab: Int
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0...2, id: \.self) { i in
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: i == currentTab ? 40 : 20, height: 20)
                    .foregroundColor(i == currentTab ? Color("ProgressBlue") : Color("ProgressBlueNA"))
            }
        }
    }
}

//struct OnboardingProgress_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingProgress(currentTab: 0)
//    }
//}
