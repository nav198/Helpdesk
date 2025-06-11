//
//  MaintainanceRequest.swift
//  EdiqueSupport
//
//  Created by Beera Naveen on 07/05/25.

import SwiftUI

struct ServiceRequest: View {
    @Environment(\.presentationMode) var presentationMode
    let device: Results
    
    @StateObject private var assetCategory = AssetCategoryVM()
    @StateObject private var assetCategoryIssues = AssetCategoryIssuesVM()
    
    @State private var projectId: Int?
    @State private var categoryId: Int?

    @State private var selectedOption = "Select an Option"
    @State private var selectedOption2 = "Select an Option"
    @State private var searchText1 = ""
    @State private var searchText2 = ""
    @State private var profileText = ""
    
    @State private var isPresented = true
    @State private var isNotPresented = false
    
    let options = ["Device not turning on", "Frequent restarts", "Overheating", "Performance slowdown", "No display/black screen", "Color distortion","Battery not charging"]
    let typeOfProblem = ["Hardware","Software"]
    
    
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(alignment: .leading, spacing: 12) {
                
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
                    options: typeOfProblem,
                    isPresented: $isNotPresented
                )
                
                Divider()
                
                Text("Please select the issue")
                DropdownView(
                    selectedOption: $selectedOption2,
                    searchText: $searchText2,
                    options: options,
                    isPresented: $isPresented
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
                ToastManager.shared.show(message: "Please fill all the fields", type: .failure)
             
                
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
        .onChange(of: selectedOption) { newValue in
            if let projectId = projectId, let categoryId = categoryId, newValue != "Select an Option" {
                getAssetIssue(projectId: projectId, categoryId: categoryId, issueType: newValue)
            }
        }
        .withToast()
    }
    
 
    func callAPI() {
        Task {
            await assetCategory.fetchData()
            if let allCategoryResponse = assetCategory.data {
//                print("✅ All Categories: \(allCategoryResponse)")
                if let matchedCategory = allCategoryResponse.first(where: {
                    $0.name.lowercased() == device.itemCategory?.lowercased()
                }) {
                    projectId = matchedCategory.projectID
                    categoryId = matchedCategory.id
                } else {
                    print("❌ No matching category found for \(device.itemCategory ?? "")")
                }
            }
        }
    }

    func getAssetIssue(projectId: Int, categoryId: Int, issueType: String) {
        Task {
            await assetCategoryIssues.fetchData(projectID: projectId, category_id: categoryId, issueType: "software")
            if let response = assetCategoryIssues.data {
                print("✅ Asset Issue Response: \(response)")
                let hello = response.compactMap({$0.issueType})
            } else {
                print("❌ Failed to fetch asset issues")
            }
        }
    }
    
}

struct DropdownView: View {
    @Binding var selectedOption: String
    @Binding var searchText: String
    let options: [String]
    
    @Binding var isPresented: Bool
    
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
                    if isPresented == true{
                        TextField("Search...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    
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
