//
//  LaunchScreen.swift
//  Motiv
//
//  Created by William Little on 2023-12-30.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Image("LaunchScreen")
                    .ignoresSafeArea(.all)
                    .frame(width: reader.size.width, height: reader.size.height)
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
