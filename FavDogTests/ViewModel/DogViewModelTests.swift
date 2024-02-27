//
//  DogViewModelTests.swift
//  FavDogTests
//
//  Created by Manjunath Anawal on 27/02/24.
//

import XCTest
@testable import FavDog

@MainActor
final class DogViewModelTests: XCTestCase {

    var viewModel: DogViewModel!
     var mockNetworkService: MockNetworkService!
     var mockPersistenceService: MockPersistenceService!
     
    
    override func setUp() {
           super.setUp()
           mockNetworkService = MockNetworkService()
           mockPersistenceService = MockPersistenceService()
           viewModel = DogViewModel(networkService: mockNetworkService, persistenceService: mockPersistenceService)
       }
       
       override func tearDown() {
           mockNetworkService = nil
           mockPersistenceService = nil
           viewModel = nil
           super.tearDown()
       }

    func testFetchRandomDogImage_DogViewModel() async {
        await viewModel.fetchRandomDogImage()
        
        XCTAssertEqual(viewModel.favoriteDog, "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg")
    }
    
    func testFetchBreedsList_DogViewModel() async {
        await viewModel.fetchBreedsList()
        
        XCTAssertEqual(viewModel.breedNames, ["Breed1", "Breed2", "Breed3"])
    }
    
    func testFetchRandomImageForBreed_DogViewModel() async {
        await viewModel.fetchRandomImage(breed: "hound-afghan")
        
        XCTAssertEqual(viewModel.favoriteDog, "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg")
    }
    
    func testFetchMultipleImages_DogViewModel() async {
        await viewModel.fetchMultipleImages(breed: "hound-afghan", numbers: 2)
        
        XCTAssertEqual(viewModel.dogImages.count, 2)
    }
    
    func testFetchMultipleImagesForBreed_DogViewModel() async {
        await viewModel.fetchMulImages(breed: "hound-afghan")
        
        XCTAssertEqual(viewModel.dogImages.count, 11)
    }
}
