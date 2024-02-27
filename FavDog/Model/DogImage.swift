//
//  DogModel.swift
//  FavoriteDog
//
//  Created by Manjunath Anawal on 21/02/24.
//

import Foundation

struct DogImage: Codable {
    let message: String?
    let status: String?
}

struct DogImages: Codable {
    let message: [String]?
    let status: String?
}

struct BreedsResponse: Codable {
    let message: [String: [String]]
    let status: String
}


