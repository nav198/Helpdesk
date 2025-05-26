//
//  ContentView.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 06/05/25.
//

import SwiftUI

//Not using Homeview

struct SupportMenuItem: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let borderColor: Color
    let destination: AnyView
}

struct SupportMenuButton: View {
    let title: String
    let iconName: String
    let borderColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(borderColor)
                .frame(width: 30)
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1)
        )
    }
}


struct CircleButton: View {
    let iconName: String
    let backgroundColor: Color
    let action: () -> Void 
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .foregroundColor(.white)
                .padding()
                .background(Circle().fill(backgroundColor))
                .frame(width: 60, height: 60)
        }
    }
}
