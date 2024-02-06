//
//  HostPersonalEventView.swift
//  Motiv
//
//  Created by William Little on 2024-01-28.
//

import SwiftUI

struct HostPersonalEventView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var eventVM: EventViewModel
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack(alignment: .leading) {
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
                    }
                    
                    Text("Host Event")
                        .font(.custom("F37Ginger-Bold", size: 30))
                        .padding(.horizontal, reader.size.width / 14)
                        .foregroundColor(.white)
                    
                                    
                    // Event title textfield
                    MTextField(title: "Event Title", text: $eventVM.eventTitle, autoCap: false)
                        .padding(.horizontal, reader.size.width / 14)
                        .padding(.vertical, reader.size.height / 130)
                    
                    // Description textfield
                    MTextField(title: "Description", text: $eventVM.eventTitle, autoCap: false)
                        .padding(.horizontal, reader.size.width / 14)
                        .padding(.vertical, reader.size.height / 130)
                    
                    // Location Search
                    LocationSubView(width: reader.size.width)
                    .onTapGesture {
                        eventVM.displaySearchLocation = true
                    }
                    
                    // Search Location
                    NavigationLink(destination: LocationSearchView()
                        .environmentObject(eventVM)
                        .toolbar(.hidden)
                                   ,
                                   isActive: $eventVM.displaySearchLocation) {
                        EmptyView()
                    }
                    
                    Spacer()
                }
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .background(Image("main_background"))
        }
    }
}

struct HostPersonalEventView_Previews: PreviewProvider {
    static var previews: some View {
        HostPersonalEventView()
    }
}
