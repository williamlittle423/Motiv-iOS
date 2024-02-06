//
//  LocationSearchView.swift
//  Motiv
//
//  Created by William Little on 2024-01-28.
//

import SwiftUI

struct LocationSearchView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var eventVM: EventViewModel
    
    func backButton() {
        self.presentationMode.wrappedValue.dismiss()
        self.eventVM.poiText = ""
        self.eventVM.viewData = []
    }
    
    // MARK: When the user selects the location
    //  - Assign the values in the view model
    //  - Return to the event details view
    func selectLocation(address: String, fullAddress: String) {
        self.eventVM.eventAddress = address
        self.eventVM.eventFullAddress = fullAddress
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack(alignment: .center) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 14, height: 23)
                            .padding(.horizontal, reader.size.width / 14)
                            .foregroundColor(.white)
                            .onTapGesture {
                                backButton()
                            }
                        Spacer()
                    }
                    
                    HStack {
                        Text("Event Location")
                            .font(.custom("F37Ginger-Bold", size: 24))
                            .padding(.horizontal, reader.size.width / 14)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    
                    MTextField(title: "", text: $eventVM.poiText, autoCap: false)
                        .padding(.horizontal, reader.size.width / 14)
                    
                    
                    ForEach(eventVM.viewData, id: \.self) { location in
                        // Display each location
                        Button {
                            self.selectLocation(address: location.title, fullAddress: location.subtitle)
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: reader.size.width / 1.2, height: reader.size.width / 6)
                                    .padding(.horizontal, reader.size.width / 14)
                                    .foregroundColor(Color("SheetGrey").opacity(0.4))
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(location.title)
                                            .font(.custom("F37Ginger", size: 12))
                                            .foregroundColor(.white)
                                        Text(location.subtitle)
                                            .font(.custom("F37Ginger", size: 12))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    // Select button
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 12, height: 20)
                                }
                                .padding(.horizontal, reader.size.width / 9)
                            }
                            .padding(.vertical)
                            .frame(width: reader.size.width / 1.1, height: reader.size.width / 6)
                        }


                    }
                    .padding()
                    Spacer()
                }
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .background(Image("main_background"))
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
    }
}
