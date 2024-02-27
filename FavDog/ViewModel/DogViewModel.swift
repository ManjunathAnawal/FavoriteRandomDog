//
//  DogViewModel.swift
//  FavoriteDog
//
//  Created by Manjunath Anawal on 21/02/24.
//

import SwiftUI

@MainActor
class DogViewModel: ObservableObject {
    
    @Published var favoriteDog: String?
    @Published var breedNames: [String]?
    
    @Published var dogImages: [String] = []
    @Published var searchActive: Bool = false
    @Published var greetLabel: String = "Random dog image"

    let networkService: NetworkServiceDelegate?
    let persistenceService: PersistenceServiceDelegate?

    
    init(networkService: NetworkServiceDelegate = NetworkService(), persistenceService: PersistenceServiceDelegate = PersistenceService.shared) {
           self.networkService = networkService
           self.persistenceService = persistenceService
           
        Task {
            await fetchBreedsList()
        }
        Task {
                let favoriteDog = PersistenceService.shared.loadFavorite(key: UserDefaultKeys.favoriteDogKey)
                let favoriteBreed = PersistenceService.shared.loadFavorite(key: UserDefaultKeys.favoriteBreedKey)
                
                if let favoriteDog = favoriteDog {
                    DispatchQueue.main.async {
                        self.favoriteDog = favoriteDog
                    }
                   greetLabel = "Here is your favorite Dog"
                } else if let favoriteBreed = favoriteBreed {
                    await fetchRandomImage(breed: favoriteBreed)
                } else {
                    await fetchRandomDogImage()
                }
        }
    }
    
    func fetchBreedsList() async {
        do {
            if let breedNames =  try await networkService?.requestBreedsList() {
                self.breedNames = breedNames
            }
           
        } catch {
            print("Error decoding breeds: \(error)")
            return
        }
    }

    func fetchRandomDogImage() async {
        do {
            let dogImage = try await networkService?.requestRandomImage()
            favoriteDog = dogImage
        } catch {
            print("Failed to fetch random dog image: \(error)")
        }
    }

    func fetchRandomImage(breed: String) async {
        do {
            let dogImage = try await networkService?.requestRandomImage(breed: breed)
            favoriteDog = dogImage
        } catch {
            print("Failed to fetch random dog image: \(error)")
        }
    }

    func fetchMultipleImages(breed: String, numbers: Int) async {
        do {
            let dogImages = try await networkService?.requestMultipleImages(breed: breed.lowercased(), numbers: numbers)
            self.dogImages = dogImages ?? []
        } catch {
            print("Failed to fetch random dog image: \(error)")
        }
    }
    
    func fetchMulImages(breed: String) async {
        do {
            let dogImages = try await networkService?.requestMulImages(breed: breed.lowercased())
            self.dogImages = dogImages ?? []
        } catch {
            print("Failed to fetch random dog image: \(error)")
        }
    }
}










