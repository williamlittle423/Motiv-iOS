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
                .padding(12) // Add padding inside the text field
                .frame(height: 50) // Set the height of the text field
                .textInputAutocapitalization(autoCap ? .words : .never)
                .background(
                    RoundedRectangle(cornerRadius: 10) // Set the corner radius of the rectangle
                        .strokeBorder(Color.white, lineWidth: 1) // Set the border color and width
                )
                .foregroundColor(.white) // Set the text color inside the text field
                .accentColor(.white) // Set the cursor and selection color
        }
    }
}
