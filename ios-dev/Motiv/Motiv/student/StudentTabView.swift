//
//  StudentTabView.swift
//  Motiv
//
//  Created by William Little on 2024-01-02.
//

import SwiftUI

enum Tab {
    case map
    case house
    case user
    case create
    case explore
}

struct StudentTabView: View {
    
    @Binding var currentTab: Tab
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: reader.size.width, height: 1)
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "0A1A5E"), Color(hex: "#070610")]), startPoint: .leading, endPoint: .trailing))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .frame(height: reader.size.height / 10)
                        .ignoresSafeArea(.all)
                        .opacity(currentTab == .map ? 1 : 0)
                }
                
                HStack(spacing: 40) {
                    Image(systemName: "map")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundColor(.white)
                        .onTapGesture(perform: {
                            currentTab = .map
                        })
                    
                    
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundColor(.white)
                        .onTapGesture(perform: {
                            currentTab = .explore
                        })
                    
                    
                    
                    ZStack {
                        PlusCircle()
                            .offset(y: -14)
                            .onTapGesture(perform: {
                                currentTab = .create
                            })
                    }
                    
                    
                    Image(systemName: "house.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundColor(.white)
                        .onTapGesture(perform: {
                            currentTab = .house
                        })
                    
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundColor(.white)
                        .onTapGesture(perform: {
                            currentTab = .user
                        })
                }
                .offset(y: -1 * reader.size.height / 54)
                .frame(width: UIScreen.main.bounds.maxX, height: 70)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 10)
            .edgesIgnoringSafeArea(.bottom)
            .offset(y: reader.size.height / 17)
        }
    }
}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

