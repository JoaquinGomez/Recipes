//
//  ImageProviderTests.swift
//  RecipesTests
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

import XCTest
@testable import Recipes

final class ImageProviderTests: XCTestCase {
    var sut: ImageProvider!
    var imageCacheDouble: ImageCacheDouble!
    var dataFetcherDouble: DataFetcherDouble!

    override func setUpWithError() throws {
        imageCacheDouble = .init()
        dataFetcherDouble = .init()
        sut = .init(cache: imageCacheDouble, dataFetcher: dataFetcherDouble)
    }

    override func tearDownWithError() throws {
        imageCacheDouble = nil
        dataFetcherDouble = nil
        sut = nil
    }
    
    func testGetImageSuccessWithEmptyCache() async {
        let expectation1 = expectation(description: "DataFetcher.data(for:) is called")
        let expectation2 = expectation(description: "ImageCache.getImage is called")
        let expectation3 = expectation(description: "ImageCache.saveImage is called")
        let image = UIImage(systemName: "fork.knife")!
        let imageData = image.pngData()!
        dataFetcherDouble.dataForRequestImplementation = { request in
            expectation1.fulfill()
            XCTAssertEqual(request.url!.absoluteString, "http://test.com/image")
            XCTAssertEqual(request.cachePolicy, .reloadIgnoringLocalCacheData)
            return (imageData, URLResponse())
        }
        imageCacheDouble.getImageImplementation = { url in
            expectation2.fulfill()
            XCTAssertEqual(url, "http://test.com/image")
            return nil
        }
        imageCacheDouble.saveImageImplementation = { url, data in
            expectation3.fulfill()
            XCTAssertEqual(url, "http://test.com/image")
            XCTAssertEqual(data, imageData)
        }
        let fetchedImage = await sut.getImage(urlString: "http://test.com/image")
        XCTAssertNotNil(fetchedImage)
        
        await fulfillment(of: [expectation1, expectation2, expectation3], timeout: 1.0)
    }
    
    func testGetImageFetchFailureWithEmptyCache() async {
        let expectation1 = expectation(description: "DataFetcher.data(for:) is called")
        let expectation2 = expectation(description: "ImageCache.getImage is called")
        dataFetcherDouble.dataForRequestImplementation = { request in
            expectation1.fulfill()
            XCTAssertEqual(request.url!.absoluteString, "http://test.com/image")
            XCTAssertEqual(request.cachePolicy, .reloadIgnoringLocalCacheData)
            throw NSError()
        }
        imageCacheDouble.getImageImplementation = { url in
            expectation2.fulfill()
            XCTAssertEqual(url, "http://test.com/image")
            return nil
        }
        imageCacheDouble.saveImageImplementation = { url, data in
            XCTFail()
            fatalError()
        }
        let fetchedImage = await sut.getImage(urlString: "http://test.com/image")
        XCTAssertNil(fetchedImage)
        
        await fulfillment(of: [expectation1, expectation2], timeout: 1.0)
    }
    
    func testGetImageInvalidDataWithEmptyCache() async {
        let expectation1 = expectation(description: "DataFetcher.data(for:) is called")
        let expectation2 = expectation(description: "ImageCache.getImage is called")
        let imageData = Data()
        dataFetcherDouble.dataForRequestImplementation = { request in
            expectation1.fulfill()
            XCTAssertEqual(request.url!.absoluteString, "http://test.com/image")
            XCTAssertEqual(request.cachePolicy, .reloadIgnoringLocalCacheData)
            return (imageData, URLResponse())
        }
        imageCacheDouble.getImageImplementation = { url in
            expectation2.fulfill()
            XCTAssertEqual(url, "http://test.com/image")
            return nil
        }
        imageCacheDouble.saveImageImplementation = { url, data in
            XCTFail()
            fatalError()
        }
        let fetchedImage = await sut.getImage(urlString: "http://test.com/image")
        XCTAssertNil(fetchedImage)
        
        await fulfillment(of: [expectation1, expectation2], timeout: 1.0)
    }
    
    func testGetImageSuccessWithValidCache() async {
        let expectation = expectation(description: "ImageCache.getImage is called")
        let image = UIImage(systemName: "fork.knife")!
        let imageData = image.pngData()!
        dataFetcherDouble.dataForRequestImplementation = { request in
            XCTFail()
            fatalError()
        }
        imageCacheDouble.getImageImplementation = { url in
            expectation.fulfill()
            XCTAssertEqual(url, "http://test.com/image")
            return imageData
        }
        imageCacheDouble.saveImageImplementation = { url, data in
            XCTFail()
            fatalError()
        }
        let cachedImage = await sut.getImage(urlString: "http://test.com/image")
        XCTAssertNotNil(cachedImage)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
