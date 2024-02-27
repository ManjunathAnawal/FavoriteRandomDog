//
//  BreedSelectionView.swift
//  FavDog
//
//  Created by Manjunath Anawal on 27/02/24.
//

import SwiftUI

struct BreedSelectionView: View {
    @EnvironmentObject var viewModel: DogViewModel
    @State private var selectedBreedIndex = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            textView
            picker
        }
    }
    
    var textView: some View {
        Text("Select a breed")
            .bold()
    }
    
    @ViewBuilder
    var picker: some View {
        if let breedNames = viewModel.breedNames {
            
            VStack {
                Picker(selection: $selectedBreedIndex, label: Text("Select Breed")) {
                    ForEach(0..<breedNames.count, id: \.self) { index in
                        Text(breedNames[index])
                            .tag(index)
                    }
                }
                .onChange(of: selectedBreedIndex) { breedIndex in
                    Task {
                        viewModel.favoriteDog = try? await viewModel.networkService?.requestRandomImage(breed: breedNames[breedIndex])
                    }
                    PersistenceService.shared.saveFavorite(value: breedNames[breedIndex], key: UserDefaultKeys.favoriteBreedKey)
                }
                
            }
            .padding()
        }
    }
}
