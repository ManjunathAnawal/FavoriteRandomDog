//
//  MockPersistenceService.swift
//  FavDog
//
//  Created by Manjunath Anawal on 27/02/24.
//

import UIKit

final class MockPersistenceService: PersistenceServiceDelegate {
    var favoriteValue: String?
    
    func saveFavorite(value: String, key: String) {
        favoriteValue = value
    }
    
    func loadFavorite(key: String) -> String? {
        return favoriteValue
    }
}
