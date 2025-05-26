//
//  MaintainanceRequest.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 07/05/25.

import SwiftUI

struct ServiceRequest: View {
    @Environment(\.presentationMode) var presentationMode
//    let device: DeviceCard
    let device: Results
    
    @State private var selectedOption = "Select an Option"
    @State private var selectedOption2 = "Select an Option"
    @State private var searchText1 = ""
    @State private var searchText2 = ""
    @State private var profileText = ""
    
    let options = ["Apple", "Banana", "Orange", "Mango", "Pineapple", "Grapes"]
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(alignment: .leading, spacing: 12) {
                //                Text(device.deviceName)
                
                Text("\(device.itemMake ?? "")")
                Divider()
                Text("\(device.itemCategory ?? "")")
                Divider()
                Text("Serial - \(device.itemSerialNo ?? "")")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.2)))
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Please select the type of problem")
                DropdownView(
                    selectedOption: $selectedOption,
                    searchText: $searchText1,
                    options: options
                )
                
                Divider()
                
                Text("Please select the issue")
                DropdownView(
                    selectedOption: $selectedOption2,
                    searchText: $searchText2,
                    options: options
                )
                
                Divider()
                
                Text("Comments")
                    .font(.callout)
                    .foregroundColor(.primary)
                
                TextEditor(text: $profileText)
                    .padding(8)
                    .frame(height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(8)
            }
            .padding(15)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.2)))
            .padding(.horizontal)
            
            Button(action: {
                print("HELLO")
            }) {
                Text("SUBMIT")
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .padding(.vertical, 16)
                    .frame(width: 200)
            }
            .background(Color.green.opacity(0.7))
            .cornerRadius(20)
            .padding(.horizontal)
            
            
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .padding()
        .navigationTitle("Maintainance Request")
        .onAppear{
            callAPI()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton.view {
            presentationMode.wrappedValue.dismiss()
        })
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func callAPI(){
        print("device \(device.projectID ?? 0 )")
        print("device \(device.itemCategory ?? "")")
        
       
    }
}

struct DropdownView: View {
    @Binding var selectedOption: String
    @Binding var searchText: String
    let options: [String]
    
    @State private var isExpanded = false
    
    var filteredOptions: [String] {
        if searchText.isEmpty {
            return options
        } else {
            return options.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(selectedOption)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .tint(Color.primary)
                .cornerRadius(8)
            }
            
            if isExpanded {
                VStack(spacing: 0) {
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    ForEach(Array(filteredOptions.enumerated()), id: \.offset) { _, option in
                        Text(option)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .onTapGesture {
                                selectedOption = option
                                isExpanded = false
                                searchText = ""
                            }
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
            }
        }
    }
}
