//
//  MSecureField.swift
//  Motiv
//
//  Created by William Little on 2023-12-31.
//

import SwiftUI

struct MSecureField: View {
    
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("F37Ginger-Light", size: 12))
                .foregroundColor(.white)
            SecureField("*******", text: $text)
                .padding(12)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.white, lineWidth: 1)
                )
                .foregroundColor(.white)
                .accentColor(.white)
        }
    }
}
