//
//  NetworkService.swift
//  FavoriteDog
//
//  Created by Manjunath Anawal on 21/02/24.
//

import UIKit

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidData
}

protocol NetworkServiceDelegate {
    func requestRandomImage() async throws -> String?
    func requestBreedsList() async throws -> [String]
    func requestRandomImage(breed: String) async throws -> String?
    func requestMultipleImages(breed: String, numbers: Int) async throws -> [String]?
    func requestMulImages(breed: String) async throws -> [String]?
    
}

final class NetworkService: NetworkServiceDelegate {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }    
    
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case listAllBreeds
        case multipleImagesForBreed(String, Int)
        case mulImagesForBreed(String)
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            case .multipleImagesForBreed(let breed, let numbers):
                return "https://dog.ceo/api/breed/\(breed)/images/random/\(numbers)"
            case .mulImagesForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images"
            }
        }
    }
    
    
    private func fetchData(from url: URL) async throws -> Data {
        let (data, _) = try await session.data(from: url)
        return data
    }
    
    private func decodeImageData<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        let imageData = try decoder.decode(T.self, from: data)
        return imageData
    }
    
    func requestBreedsList() async throws -> [String] {
        let data = try await fetchData(from: Endpoint.listAllBreeds.url)
        let breedsResponse: BreedsResponse = try decodeImageData(data: data)
        let breeds = breedsResponse.message.keys.map { $0 }
        return breeds
    }
    
    func requestRandomImage(breed: String) async throws -> String? {
        let data = try await fetchData(from: Endpoint.randomImageForBreed(breed).url)
        let imageData: DogImage = try decodeImageData(data: data)
        return imageData.message
    }
    
    func requestMultipleImages(breed: String, numbers: Int) async throws -> [String]? {
        let data = try await fetchData(from: Endpoint.multipleImagesForBreed(breed, numbers).url)
        let imageData: DogImages = try decodeImageData(data: data)
        return imageData.message
    }
    
    func requestMulImages(breed: String) async throws -> [String]? {
        let data = try await fetchData(from: Endpoint.mulImagesForBreed(breed).url)
        let imageData: DogImages = try decodeImageData(data: data)
        return imageData.message
    }
    
    func requestRandomImage() async throws -> String? {
        let data = try await fetchData(from: Endpoint.randomImageFromAllDogsCollection.url)
        let imageData: DogImage = try decodeImageData(data: data)
        return imageData.message
    }
}
