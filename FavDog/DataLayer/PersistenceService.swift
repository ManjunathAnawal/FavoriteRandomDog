//
//  PersistenceService.swift
//  FavoriteDog
//
//  Created by Manjunath Anawal on 21/02/24.
//

import UIKit

protocol PersistenceServiceDelegate {
    func saveFavorite(value: String, key: String)
    func loadFavorite(key: String) -> String?
}

final class PersistenceService: PersistenceServiceDelegate {
    static let shared = PersistenceService()

    private init() {}
    
    func saveFavorite(value: String, key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func loadFavorite(key: String) -> String? {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoded = try JSONDecoder().decode(String.self, from: data)
                return decoded
            } catch {
                print("Failed to decode favorite dog: \(error)")
                return nil
            }
        }
        return nil
    }
}

struct UserDefaultKeys {
    static let favoriteDogKey = "favoriteDog"
    static let favoriteBreedKey = "favoriteBreed"
}


