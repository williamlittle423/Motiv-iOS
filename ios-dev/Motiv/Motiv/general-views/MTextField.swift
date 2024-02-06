//
//  MTextField.swift
//  Motiv
//
//  Created by William Little on 2023-12-27.
//

import SwiftUI

import SwiftUI

struct MTextField: View {
    
    var title: String
    @Binding var text: String
    var autoCap: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("F37Ginger-Light", size: 12))
                .foregroundColor(.white)
            TextField(title, text: $text)
                .padding(12)
                .frame(height: 50)
                .textInputAutocapitalization(autoCap ? .words : .never)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.white, lineWidth: 1)
                )
                .foregroundColor(.white)
                .accentColor(.white)
        }
    }
}
