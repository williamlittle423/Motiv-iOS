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
//                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center) {
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
                        
                        HStack {
                            Text("Host Event")
                                .font(.custom("F37Ginger-Bold", size: 30))
                                .padding(.horizontal, reader.size.width / 14)
                                .padding(.bottom, reader.size.height / 500)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        
                        
                        // MARK: SwiftUI only allows a limited amount of subviews per view so I have to group these
                        Group {
                            // Event title textfield
                            MTextField(title: "Event Title", text: $eventVM.eventTitle, autoCap: false)
                                .padding(.horizontal, reader.size.width / 14)
                                .padding(.bottom, reader.size.height / 150)
                            
                            // Description textfield
                            MTextField(title: "Description", text: $eventVM.eventDescription, autoCap: false)
                                .padding(.horizontal, reader.size.width / 14)
                                .padding(.vertical, reader.size.height / 130)
                            
                            // Location Search
                            LocationSubView(width: reader.size.width)
                                .environmentObject(eventVM)
                            .onTapGesture {
                                eventVM.displaySearchLocation = true
                            }
                        }

                        
                        // Search Location
                        NavigationLink(destination: LocationSearchView()
                            .environmentObject(eventVM)
                            .toolbar(.hidden)
                                       ,
                                       isActive: $eventVM.displaySearchLocation) {
                            EmptyView()
                        }
                        
                        // Invite friends view
                        InviteListView(width: reader.size.width)
                            .environmentObject(eventVM)
                            .padding(.top, reader.size.height / 70)
                        
                        SelectThemeView(width: reader.size.width)
                            .environmentObject(eventVM)
                            .padding(.top, reader.size.height / 130)
                        
                        // Search Location
                        NavigationLink(destination: InviteFriendsView(width: reader.size.width)
                            .environmentObject(eventVM)
                            .toolbar(.hidden)
                                       ,
                                       isActive: $eventVM.displayInviteView) {
                            EmptyView()
                        }

                        Spacer()
                        
                        // Post button
                        Button {
                            Void()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: reader.size.width / 2.1, height: reader.size.width / 10)
                                    .foregroundColor(Color("Cyan"))
                                Text("Post")
                                    .font(.custom("F37Ginger", size: 14))
                                    .foregroundColor(Color("SheetGrey"))
                            }
                        }
                        .padding(.bottom, reader.size.height / 50)
                    }
//                }
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
