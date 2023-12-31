//
//  OnboardingButton.swift
//  Motiv
//
//  Created by William Little on 2023-12-27.
//

import SwiftUI

struct OnboardingButton: View {
    
    var text: String
    var width: CGFloat
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: width / 2.4, height: 50)
                .foregroundColor(Color("Grey"))
                .opacity(isActive ? 1.0 : 0.5)
            Text(text)
                .foregroundColor(.black)
                .font(.custom("F37Ginger-Bold", size: 14))
        }
    }
}

//struct OnboardingButton_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingButton(text: "Next", width: 350.0, opacityVal: 1.0)
//    }
//}
