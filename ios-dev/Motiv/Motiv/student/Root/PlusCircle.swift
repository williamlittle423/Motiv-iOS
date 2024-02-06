//
//  PlusCircle.swift
//  Motiv
//
//  Created by William Little on 2023-11-19.
//

import SwiftUI

struct PlusCircle: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.5), radius: 2, y: 1)
            Image(systemName: "plus")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.black)
        }
    }
}

struct PlusCircle_Previews: PreviewProvider {
    static var previews: some View {
        PlusCircle()
    }
}
