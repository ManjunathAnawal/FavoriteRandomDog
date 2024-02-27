//
//  SearchBar.swift
//  FavDog
//
//  Created by Manjunath Anawal on 27/02/24.
//

import SwiftUI

struct SearchBar: View {
    @EnvironmentObject var viewModel: DogViewModel
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    viewModel.searchActive = true
                }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    viewModel.dogImages = []
                    viewModel.searchActive = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.red)
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
    }
}
