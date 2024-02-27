//
//  NetworkServiceTests.swift
//  FavDogTests
//
//  Created by Manjunath Anawal on 27/02/24.
//
import XCTest
@testable import FavDog


class NetworkServiceTests: XCTestCase {
    
    var sut: NetworkService!
    var session: URLSession!
    
    override func setUpWithError() throws {
        // Set url session for mock networking
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        super.tearDown()
    }
    
    private func getData(jsonString: String) throws -> Data? {
        if let jsonData = jsonString.data(using: .utf8) {
            return jsonData
        }
        return nil
    }
    
    func testRandomDogAPI() async throws {
        
        let ds = NetworkService(session: session)
        
        let jsonString = """
        {
            "message": "https://images.dog.ceo/breeds/hound-english/n02089973_981.jpg",
            "status": "success"
        }
        """
        
        guard let data = try getData(jsonString: jsonString) else { return }
        
        
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), data)
        }
                
        let randomImage = try? await ds.requestRandomImage()
        
        XCTAssertEqual(randomImage, "https://images.dog.ceo/breeds/hound-english/n02089973_981.jpg")
    }
    
    func testRequestBreedsList() async throws {
        // Given
        let ds = NetworkService(session: session)
        
        let jsonString = """
        {
            "message": {
                "breed1": [],
                "breed2": [],
                "breed3": []
            },
            "status": "success"
        }
        """
        
        guard let data = try getData(jsonString: jsonString) else { return }
        
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), data)
        }
                
        // When
        let breedsList = try? await ds.requestBreedsList()
        
        // Then
        XCTAssertEqual(breedsList?.count ?? 0, 3)
    }

    func testRequestRandomImage() async throws {
        // Given
        let ds = NetworkService(session: session)
        let breed = "hound-english"
        
        let jsonString = """
        {
            "message": "https://images.dog.ceo/breeds/hound-english/n02089973_981.jpg",
            "status": "success"
        }
        """
        
        guard let data = try getData(jsonString: jsonString) else { return }
        
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), data)
        }
                
        // When
        let randomImage = try? await ds.requestRandomImage(breed: breed)
        
        // Then
        XCTAssertEqual(randomImage, "https://images.dog.ceo/breeds/hound-english/n02089973_981.jpg")
    }

    func testRequestMultipleImages() async throws {
        // Given
        let ds = NetworkService(session: session)
        let breed = "hound-english"
        let numbers = 5
        
        let jsonString = """
        {
            "message": [
                "https://images.dog.ceo/breeds/hound-english/n02089973_981.jpg",
                "https://images.dog.ceo/breeds/hound-english/n02089973_982.jpg",
                "https://images.dog.ceo/breeds/hound-english/n02089973_983.jpg",
                "https://images.dog.ceo/breeds/hound-english/n02089973_984.jpg",
                "https://images.dog.ceo/breeds/hound-english/n02089973_985.jpg"
            ],
            "status": "success"
        }
        """
        
        guard let data = try getData(jsonString: jsonString) else { return }
        
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), data)
        }
                
        // When
        let multipleImages = try? await ds.requestMultipleImages(breed: breed, numbers: numbers)
        
        // Then
        XCTAssertEqual(multipleImages?.count, numbers)
    }

    func testRequestMulImages() async throws {
        // Given
        let ds = NetworkService(session: session)
        let breed = "hound-english"
        
        let jsonString = """
        {
            "message": [
                "https://images.dog.ceo/breeds/hound-english/n02089973_981.jpg",
                "https://images.dog.ceo/breeds/hound-english/n02089973_982.jpg",
                "https://images.dog.ceo/breeds/hound-english/n02089973_983.jpg",
                "https://images.dog.ceo/breeds/hound-english/n02089973_984.jpg",
                "https://images.dog.ceo/breeds/hound-english/n02089973_985.jpg"
            ],
            "status": "success"
        }
        """
        
        guard let data = try getData(jsonString: jsonString) else { return }
        
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), data)
        }
                
        // When
        let multipleImages = try? await ds.requestMulImages(breed: breed)
        
        // Then
        XCTAssertEqual(multipleImages?.count, 5)
    }

}
