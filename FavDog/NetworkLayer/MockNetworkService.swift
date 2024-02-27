//
//  MockNetworkService.swift
//  FavDog
//
//  Created by Manjunath Anawal on 27/02/24.
//

import Foundation

class MockNetworkService: NetworkServiceDelegate {
    func requestRandomImage() async throws -> String? {
        return "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg"
    }
    
    func requestBreedsList() async throws -> [String] {
        return ["Breed1", "Breed2", "Breed3"]
    }
    
    func requestRandomImage(breed: String) async throws -> String? {
        return "https://images.dog.ceo/breeds/\(breed)/n02088094_1003.jpg"
    }
    
    func requestBreedsList() async throws -> [String]? {
        return [
            "affenpinscher",
            "african",
            "airedale",
            "akita",
            "appenzeller",
            "australian",
            "basenji",
            "beagle",
            "bluetick",
            "borzoi",
            "bouvier"
        ]
    }

    func requestMultipleImages(breed: String, numbers: Int) async throws -> [String]? {
        var resImages = [String]()
        for i in 0..<numbers {
            resImages.append("https://images.dog.ceo/breeds/\(breed)/n02088094_1003.jpg")
        }
        return resImages
    }

    func requestMulImages(breed: String) async throws -> [String]? {
        return [
            "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg",
                    "https://images.dog.ceo/breeds/hound-afghan/n02088094_1007.jpg",
                    "https://images.dog.ceo/breeds/hound-afghan/n02088094_1023.jpg",
                    "https://images.dog.ceo/breeds/hound-afghan/n02088094_10263.jpg",
                    "https://images.dog.ceo/breeds/hound-afghan/n02088094_10715.jpg",
                    "https://images.dog.ceo/breeds/hound-afghan/n02088094_10822.jpg",
                    "https://images.dog.ceo/breeds/hound-afghan/n02088094_10832.jpg",
                    "https://images.dog.ceo/breeds/hound-afghan/n02088094_10982.jpg",
                    "https://images.dog.ceo/breeds/hound-afghan/n02088094_11006.jpg",
                    "https://images.dog.ceo/breeds/hound-afghan/n02088094_11172.jpg",
                    "https://images.dog.ceo/breeds/hound-afghan/n02088094_11182.jpg",
        ]
    }
}
