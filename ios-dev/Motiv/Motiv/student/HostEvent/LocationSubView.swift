//
//  LocationSubView.swift
//  Motiv
//
//  Created by William Little on 2024-01-29.
//

import SwiftUI

struct LocationSubView: View {
    
    var width: CGFloat
    
    @EnvironmentObject var eventVM: EventViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Location")
                .font(.custom("F37Ginger-Light", size: 12))
                .foregroundColor(.white)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 50)
                    .foregroundColor(.clear)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.white, lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .accentColor(.white)
                HStack {
                    Text(eventVM.eventFullAddress)
                        .font(.custom("F37Ginger", size: 12))
                        .foregroundColor(Color("Opacity"))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 12, height: 20)                }
            }
        }
        .padding(.horizontal, width / 15)
    }
}
