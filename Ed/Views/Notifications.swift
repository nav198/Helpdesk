//
//  Notifications.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 08/05/25.
//

import SwiftUI


struct SupportItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let iconName: String
}

struct Notifications: View {
    @Environment(\.presentationMode) var presentationMode
    
    let items: [SupportItem] = [
        SupportItem(title: "Welcome", message: "Welcome to EdiQue Support.", iconName: "iphone.gen1"),
        SupportItem(title: "Products", message: "All your products have been listed on the my devices section.", iconName: "iphone.gen1"),
        SupportItem(title: "Welcome", message: "Welcome to EdiQue Support.", iconName: "iphone.gen1"),
        SupportItem(title: "Products", message: "All your products have been listed on the my devices section.", iconName: "iphone.gen1")
    ]
    
    var body: some View {
        if #available(iOS 14.0, *) {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(items) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: item.iconName)
                            .font(.system(size: 30))
                            .foregroundColor(.green)
                            .frame(width: 40, alignment: .leading)
                        Divider().frame(height: 50)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                                .bold()
                            
                            Divider()
                            
                            Text(item.message)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                    Divider()
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Notifications")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton.view {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarTitleDisplayMode(.inline)
        } else {
            // Fallback on earlier versions
        }
    }
    
}

struct Notifications_Previews: PreviewProvider {
    static var previews: some View {
        Notifications()
    }
}
