//
//  ImageCacheTests.swift
//  RecipesTests
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

import XCTest
@testable import Recipes

final class ImageCacheTests: XCTestCase {
    var sut: ImageCache!
    var imageStorageDouble: ImageStorageDouble!

    override func setUpWithError() throws {
        imageStorageDouble = .init()
    }

    override func tearDownWithError() throws {
        imageStorageDouble = nil
        sut = nil
    }
    
    func testGetImageExpiredCache() async {
        sut = .init(cacheExpiration: 0, imageStorage: imageStorageDouble)
        let expectation1 = expectation(description: "ImageStorage.read(url:) is called")
        let expectation2 = expectation(description: "ImageStorage.delete(url:) is called")
        let image = UIImage(systemName: "fork.knife")!
        let imageData = image.pngData()!
        imageStorageDouble.readImplementation = { url in
            expectation1.fulfill()
            XCTAssertEqual(url, "http://test.com/image")
            return StoredImage(timestamp: Date().addingTimeInterval(-10), data: imageData)
        }
        imageStorageDouble.deleteImplementation = { url in
            expectation2.fulfill()
            XCTAssertEqual(url, "http://test.com/image")
        }
        let cachedImage = await sut.getImage(urlString: "http://test.com/image")
        XCTAssertNil(cachedImage)
        
        await fulfillment(of: [expectation1, expectation2], timeout: 1.0)
    }
    
    func testGetImageCurrentNonEmptyCache() async {
        sut = .init(cacheExpiration: 100000, imageStorage: imageStorageDouble)
        let expectation = expectation(description: "ImageStorage.read(url:) is called")
        let image = UIImage(systemName: "fork.knife")!
        let imageData = image.pngData()!
        imageStorageDouble.readImplementation = { url in
            expectation.fulfill()
            XCTAssertEqual(url, "http://test.com/image")
            return StoredImage(timestamp: Date().addingTimeInterval(-10), data: imageData)
        }
        imageStorageDouble.deleteImplementation = { url in
            XCTFail()
            fatalError()
        }
        let cachedImage = await sut.getImage(urlString: "http://test.com/image")
        XCTAssertNotNil(cachedImage)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testGetImageCurrentEmptyCache() async {
        sut = .init(cacheExpiration: 100000, imageStorage: imageStorageDouble)
        let expectation = expectation(description: "ImageStorage.read(url:) is called")
        imageStorageDouble.readImplementation = { url in
            expectation.fulfill()
            XCTAssertEqual(url, "http://test.com/image")
            return nil
        }
        imageStorageDouble.deleteImplementation = { url in
            XCTFail()
            fatalError()
        }
        let cachedImage = await sut.getImage(urlString: "http://test.com/image")
        XCTAssertNil(cachedImage)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testGetImageCurrentEmptyDate() async {
        sut = .init(cacheExpiration: 100000, imageStorage: imageStorageDouble)
        let expectation = expectation(description: "ImageStorage.read(url:) is called")
        imageStorageDouble.readImplementation = { url in
            expectation.fulfill()
            XCTAssertEqual(url, "http://test.com/image")
            return StoredImage(timestamp: Date().addingTimeInterval(-10), data: nil)
        }
        imageStorageDouble.deleteImplementation = { url in
            XCTFail()
            fatalError()
        }
        let cachedImage = await sut.getImage(urlString: "http://test.com/image")
        XCTAssertNil(cachedImage)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testSaveImage() async {
        sut = .init(cacheExpiration: 100000, imageStorage: imageStorageDouble)
        let expectation = expectation(description: "ImageStorage.create(image:,url:) is called")
        let image = UIImage(systemName: "fork.knife")!
        let imageData = image.pngData()!
        imageStorageDouble.createImplementation = { data, url, timestamp in
            expectation.fulfill()
            XCTAssertEqual(url, "http://test.com/image")
            XCTAssertEqual(imageData, data)
            XCTAssertNotNil(timestamp)
        }
        await sut.saveImage(urlString: "http://test.com/image", data: imageData)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
