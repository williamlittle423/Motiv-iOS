//
//  InstagramDisplay.swift
//  Motiv
//
//  Created by William Little on 2024-01-02.
//

import SwiftUI

struct InstagramDisplay: View {
    
    var width: CGFloat
    var connected: Bool
    
    var body: some View {
        
        HStack {
            Image("ig_white")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 16)
            Text("Connect")
                .font(.custom("F37Ginger", size: 12))
                .foregroundColor(.white)
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("Opacity"))
                .opacity(0.27)
        )
    }
}

struct InstagramDisplay_Previews: PreviewProvider {
    static var previews: some View {
        InstagramDisplay(width: 350, connected: false)
    }
}
