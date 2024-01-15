//
//  SignOutButton.swift
//  Motiv
//
//  Created by William Little on 2024-01-03.
//

import SwiftUI

struct SignOutButton: View {
    
    var width: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: width / 3, height: 45)
                .foregroundColor(Color("Opacity"))
                .opacity(0.3)
            Text("Sign out")
                .font(.custom("F37Ginger-Bold", size: 12))
                .foregroundColor(.white)
        }
    }
}

struct SignOutButton_Previews: PreviewProvider {
    static var previews: some View {
        SignOutButton(width: 400)
    }
}
