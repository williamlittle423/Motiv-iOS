//
//  ProgressBar.swift
//  Motiv
//
//  Created by William Little on 2023-12-27.
//

import SwiftUI

struct ProgressBar: View {
    
    var numOfSlides: Int
    var currentSlide: Int
    var width: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<numOfSlides, id: \.self) { slide in
                // Code to represent each slide in the progress bar
                Rectangle()
                    .foregroundColor(slide <= currentSlide ? .white : .gray)
                    .frame(width: width / CGFloat(numOfSlides), height: 1)
            }
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(numOfSlides: 6, currentSlide: 4, width: 300)
    }
}
