//
//  AsyncImageView.swift
//  FavDog
//
//  Created by Manjunath Anawal on 27/02/24.
//

import SwiftUI


struct AsyncImageView: View {
    let imageURLString: String
    
    var body: some View {
        GeometryReader { geometry in
            AsyncImage(url: URL(string: imageURLString)) { phase in
                switch phase {
                case .empty:
                    Text("Loading...")
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure(let error):
                    Text("Error: \(error.localizedDescription)")
                @unknown default:
                    Text("Unknown state")
                }
            }
            
            .frame(width: geometry.size.width, height: geometry.size.width)
            .clipped()
        }
    }
}
