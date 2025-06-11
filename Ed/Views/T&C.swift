//
//  T&C.swift
//  Ed
//
//  Created by Beera Naveen on 27/05/25.
//

import SwiftUI
import WebKit

struct TermsConditionsView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        WebView(url: URL(string: "https://www.edique.in/Edique_files/EdiQue-Terms-Conditions.pdf")!)
            .navigationTitle("Terms & Conditions")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton.view {
                presentationMode.wrappedValue.dismiss()
            })
    }
}


struct PrivacyView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        WebView(url: URL(string: "https://www.edique.in/Edique_files/EdiQue-Privacy-Policy.pdf")!)
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton.view {
                presentationMode.wrappedValue.dismiss()
            })
    }
}


struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        WebView(url: URL(string: "https://edique.in/#aboutSection")!)
            .navigationTitle("About Us")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton.view {
                presentationMode.wrappedValue.dismiss()
            })
    }
}

struct ContactView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Color.clear
            .onAppear {
                sendEmail(to: "info@edique.in")
            }
            .navigationTitle("Contact Us")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton.view {
                presentationMode.wrappedValue.dismiss()
            })
    }
    
    private func sendEmail(to address: String) {
        if let url = URL(string: "mailto:\(address)") {
            UIApplication.shared.open(url)
        }
    }
}


struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
