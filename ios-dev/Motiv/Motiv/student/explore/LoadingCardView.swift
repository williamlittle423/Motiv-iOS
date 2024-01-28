//
//  LoadingCardView.swift
//  Motiv
//
//  Created by William Little on 2024-01-26.
//

import SwiftUI

struct LoadingCardView: View {
    var width: CGFloat
    
    @State private var gradientPosition: CGFloat = -200 // Initial position off-screen
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: width / 1.2, height: width / 3.6)
                .foregroundColor(Color("CardColor"))
                .opacity(0.27)
        
            LinearGradient(gradient: Gradient(colors: [.clear, .white, .clear]), startPoint: .leading, endPoint: .trailing)
                .frame(width: width / 1.2, height: width / 3.6)
                .mask(
                    RoundedRectangle(cornerRadius: 20) // Apply corner radius to the mask
                        .frame(width: width / 1.2, height: width / 3.6)
                )
                .opacity(0.4)
                .offset(x: gradientPosition) // Move the gradient using offset
        }
        .padding(.vertical, 7.5)
        .onAppear {
            withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                gradientPosition = width / 1.2 + 150 // Move the gradient off-screen to the right
            }
        }
    }
}

struct LoadingCardView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingCardView(width: 400)
    }
}
