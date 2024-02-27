//
//  ContentView.swift
//  FavDog
//
//  Created by Manjunath Anawal on 24/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DogViewModel()
    @State private var searchText = ""
    @State private var numberOfImages = 5
    
    var body: some View {
        VStack {
            
            searchBarView
            
            gridView
            
            if !viewModel.searchActive {
                
                greetView
                
                VStack {
                    if let _ = viewModel.favoriteDog {
                        
                        imageView
                        
                        buttonView
                        
                    } else {
                        Text("Loading...")
                    }
                }
            }
            
            Spacer()
            
        }
        .background{
            Color.gray
                .ignoresSafeArea()
        }
        .environmentObject(viewModel)

    }
    
    @ViewBuilder
    var searchBarView: some View {
        SearchBar(text: $searchText, placeholder: "Search for breed")
            .padding()
            .onChange(of: searchText) { breed in
                if breed.count > 3 {
                    Task {
                        await viewModel.fetchMulImages(breed: breed)
                    }
                } else if breed.isEmpty {
                    viewModel.dogImages = []
                }
            }
    }
    
    @ViewBuilder
    var gridView: some View {
        if viewModel.searchActive {
            
            Stepper(value: $numberOfImages, in: 1...100, step: 1) {
                Text("Number of Images: \(numberOfImages)")
            }
            .padding()
            
            if !viewModel.dogImages.isEmpty {
                // Display images based on search and number of images
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                        ForEach(viewModel.dogImages.filter {
                            searchText.isEmpty || $0.lowercased().contains(searchText.lowercased())
                        }
                            .prefix(numberOfImages), id: \.self) { dogImage in
                                AsyncImageView(imageURLString: dogImage)
                                    .aspectRatio(contentMode: .fit) // Adjust aspect ratio to fit the grid
                                
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding()
                                    .onTapGesture {
                                        searchText = ""
                                        viewModel.favoriteDog = dogImage
                                        viewModel.searchActive = false
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                            }
                    }
                }
                .padding()
            }
        }
    }

    
//    var searchBar: some View {
//        VStack {
//           
//            searchBarView
//            
//            gridView
//        }
//    }
    
    var greetView: some View {
        Text(viewModel.greetLabel)
            .font(.title)
    }

    var imageView: some View {
        VStack {
            if let dogImage = viewModel.favoriteDog {
                AsyncImageView(imageURLString: dogImage)
                
            }
        }
        .padding()
    }
    
    var buttonView: some View {
        VStack(alignment: .leading, spacing: 20) {
            BreedSelectionView()
            
            Button("Share to friends"){
                Task {
                    await shareImage()
                }
            }
            Button("Save as favorite"){
                if let dogImage = viewModel.favoriteDog {
                    viewModel.greetLabel = "Here is your favorite Dog"
                    PersistenceService.shared.saveFavorite(value: dogImage, key: UserDefaultKeys.favoriteDogKey)
                }
            }
        }
    }
    
    private func loadImage(_ urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                return uiImage
            } else {
                print("Invalid image data")
                return nil
            }
        } catch {
            print("Error loading image: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func loadImage(url: URL) -> UIImage {
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data) ?? UIImage() // Return loaded image or a placeholder
        } catch {
            print("Error loading image: \(error)")
            return UIImage() // Return a placeholder image
        }
    }
    
    private  func shareImage() async {
        guard let imageUrl = viewModel.favoriteDog else { return }
        
        // Load image asynchronously
        if let uiImage = await loadImage(imageUrl) {
            let text = "Powered by Dog API app!"
            let shareItems: [Any] = [text, uiImage]
            
            let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            
            // Find the visible view controller
            if let visibleViewController = UIApplication.shared.windows.first?.rootViewController?.visibleViewController {
                 visibleViewController.present(activityViewController, animated: true, completion: nil)
            }
        } else {
            print("Failed to load image")
        }
    }
}

#Preview {
    ContentView()
}
