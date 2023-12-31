//
//  LoadingView.swift
//  Motiv
//
//  Created by William Little on 2023-12-31.
//

import SwiftUI

// MARK: Custom loading view
struct LoadingView: View {
    
    @State private var showSpinner:Bool = false
    @State private var degree:Int = 270
    @State private var spinnerLength = 0.6
    
    var body: some View {
        Circle()
            .trim(from: 0.0,to: spinnerLength)
            .stroke(Color("Cyan"), style: StrokeStyle(lineWidth: 5.0,lineCap: .round,lineJoin:.round))
            .animation(Animation.easeIn(duration: 1.5).repeatForever(autoreverses: true))
            .frame(width: 30,height: 30)
            .rotationEffect(Angle(degrees: Double(degree)))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            .onAppear{
                degree = 270 + 360
                spinnerLength = 0
            }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
