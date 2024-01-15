//
//  NotificationsView.swift
//  Motiv
//
//  Created by William Little on 2024-01-15.
//

import SwiftUI

struct NotificationsView: View {
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack {
                    // Back button
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 14, height: 23)
                            .padding(.horizontal, reader.size.width / 14)
                            .foregroundColor(.white)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                        
                        Spacer()
                        
                        Text("Notifications")
                            .foregroundColor(.white)
                            .font(.custom("F37Ginger-Bold", size: 22))
                            .padding(.trailing, reader.size.width / 6.5)
                        Spacer()
                    }
                    
                    Spacer()
                    
                }
                
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .background(Image("main_background"))
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
