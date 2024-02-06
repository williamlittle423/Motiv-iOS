//
//  InviteListView.swift
//  Motiv
//
//  Created by William Little on 2024-02-05.
//

import SwiftUI

struct InviteListView: View {
    
    var width: CGFloat
    @EnvironmentObject var eventVM: EventViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Invite text
            HStack {
                Text("Invite friends")
                    .font(.custom("F37Ginger-Light", size: 12))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, width / 15)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: width / 1.17, height: 50)
                    .padding(.horizontal, width / 14)
                    .foregroundColor(Color("Grey").opacity(0.28))
                
                // Display invitees
                HStack {
                    Spacer()
                    // Select button
                    Image(systemName: "chevron.right")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 12, height: 20)
                }
                .padding(.horizontal, width / 9)
            }
            .frame(width: width / 1.1, height: width / 6)
            .onTapGesture {
                eventVM.displayInviteView = true
            }
        }
    }
}

struct InviteListView_Previews: PreviewProvider {
    static var previews: some View {
        InviteListView(width: 400)
    }
}
