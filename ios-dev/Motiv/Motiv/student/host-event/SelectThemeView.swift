//
//  SelectThemeView.swift
//  Motiv
//
//  Created by William Little on 2024-02-05.
//

import SwiftUI

struct SelectThemeView: View {
    
    let themes = ["Darty", "Food", "Birthday", "Party", "Dinner_Party"]
    
    @EnvironmentObject var eventVM: EventViewModel
    
    var width: CGFloat
    
    var body: some View {
        
        // MARK: Displays all the themes in a horizontal scroll and allows user to select one
        VStack {
            
            // Theme text
            HStack {
                Text("Theme")
                    .font(.custom("F37Ginger-Light", size: 12))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, width / 15)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(themes, id: \.self) { theme in
                        VStack {
                            // Display the image and overlayed title
                            ZStack {
                                Image(theme)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            Button {
                                withAnimation {
                                    eventVM.eventTheme = theme
                                }
                            } label: {
                                // Display "selected" if selected and "select" if not
                                if eventVM.eventTheme == theme {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: width / 4.1, height: width / 18)
                                            .foregroundColor(.clear)
                                            .background(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .strokeBorder(Color("Cyan"), lineWidth: 1)
                                            )
                                            .foregroundColor(Color("Cyan"))
                                            .accentColor(Color("Cyan"))
                                        Text("Selected")
                                            .font(.custom("F37Ginger", size: 12))
                                            .foregroundColor(Color("Cyan"))
                                    }
                                    .padding(.vertical, 7.5)

                                } else {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundColor(Color("Cyan"))
                                            .frame(width: width / 4.1, height: width / 18)
                                        Text("Select")
                                            .font(.custom("F37Ginger", size: 12))
                                            .foregroundColor(Color("SheetGrey"))
                                    }
                                    .padding(.vertical, 7.5)
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
            .padding(.horizontal, width / 15)
            
        }
    }
}

struct SelectThemeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectThemeView(width: 400)
    }
}
