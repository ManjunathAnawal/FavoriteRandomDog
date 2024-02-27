//
//  PersistenceServiceTests.swift
//  FavDogTests
//
//  Created by Manjunath Anawal on 27/02/24.
//

import XCTest
@testable import FavDog

class PersistenceServiceTests: XCTestCase {

    func testSaveAndLoadFavorite() {
        // Given
        let persistenceService = PersistenceService.shared
        let favoriteValue = "Golden Retriever"
        let key = UserDefaultKeys.favoriteDogKey
        
        // When
        persistenceService.saveFavorite(value: favoriteValue, key: key)
        let loadedValue = persistenceService.loadFavorite(key: key)
        
        // Then
        XCTAssertEqual(loadedValue, favoriteValue, "Loaded value should match the saved value")
    }
    
    func testLoadNonExistentFavorite() {
        // Given
        let persistenceService = PersistenceService.shared
        let key = "NonExistentKey"
        
        // When
        let loadedValue = persistenceService.loadFavorite(key: key)
        
        // Then
        XCTAssertNil(loadedValue, "Loaded value should be nil for non-existent key")
    }
}
