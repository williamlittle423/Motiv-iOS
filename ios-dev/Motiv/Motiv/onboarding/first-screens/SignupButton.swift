//
//  SignupButton.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import SwiftUI

struct SignupButton: View {
    
    var width: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: width / 2.4, height: 50)
                .foregroundColor(Color("Cyan"))
            Text("Sign up")
                .foregroundColor(.black)
                .font(.custom("F37Ginger-Bold", size: 14))
        }
    }
}
