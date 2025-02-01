//
//  RecipesServiceTests.swift
//  RecipesTests
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

import XCTest
@testable import Recipes

final class RecipesServiceTests: XCTestCase {
    var sut: RecipesService!
    var featureFlagsProviderDouble: FeatureFlagsProviderDouble!
    var dataFetcherDouble: DataFetcherDouble!

    override func setUpWithError() throws {
        featureFlagsProviderDouble = .init(.init(expectedServiceResponse: .empty))
        dataFetcherDouble = .init()
        sut = .init(featureFlagsProvider: featureFlagsProviderDouble, dataFetcher: dataFetcherDouble)
    }

    override func tearDownWithError() throws {
        featureFlagsProviderDouble = nil
        dataFetcherDouble = nil
        sut = nil
    }
    
    func testGetRecipesPopulated() async {
        let expectation = expectation(description: "DataFetcher.data(from:) is called")
        let jsonResponseString = "{ \"recipes\": [ { \"cuisine\": \"Malaysian\", \"name\": \"Apam Balik\", \"photo_url_large\": \"https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg\", \"photo_url_small\": \"https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg\", \"source_url\": \"https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ\", \"uuid\": \"0c6ca6e7-e32a-4053-b824-1dbf749910d8\", \"youtube_url\": \"https://www.youtube.com/watch?v=6R8ffRRJcrg\" } ] }"
        let jsonResponseData = jsonResponseString.data(using: .utf8)
        dataFetcherDouble.dataFromURLImplementation = { url in
            expectation.fulfill()
            XCTAssertEqual(url.absoluteString, "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
            return (jsonResponseData!, URLResponse())
        }
        featureFlagsProviderDouble.expectedServiceResponse = .success
        do {
            let recipes = try await sut.getRecipes()
            XCTAssertEqual(recipes.recipes.count, 1)
            XCTAssertEqual(
                recipes.recipes[0],
                Recipe(uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", name: "Apam Balik", cuisine: "Malaysian", thumbnailPath: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
            )
        } catch {
            XCTFail()
        }
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testGetRecipesEmpty() async {
        let expectation = expectation(description: "DataFetcher.data(from:) is called")
        let jsonResponseString = "{ \"recipes\": [] }"
        let jsonResponseData = jsonResponseString.data(using: .utf8)
        dataFetcherDouble.dataFromURLImplementation = { url in
            expectation.fulfill()
            XCTAssertEqual(url.absoluteString, "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
            return (jsonResponseData!, URLResponse())
        }
        featureFlagsProviderDouble.expectedServiceResponse = .empty
        do {
            let recipes = try await sut.getRecipes()
            XCTAssertEqual(recipes.recipes.count, 0)
        } catch {
            XCTFail()
        }
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testGetRecipesError() async {
        let expectation1 = expectation(description: "DataFetcher.data(from:) is called")
        let expectation2 = expectation(description: "DataFetcher.data(from:) throws error")
        let jsonResponseString = "{ \"recipes\": [ { \"cuisine\": \"British\", \"photo_url_large\": \"https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg\", \"photo_url_small\": \"https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg\", \"source_url\": \"https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble\",         \"uuid\": \"599344f4-3c5c-4cca-b914-2210e3b3312f\",         \"youtube_url\": \"https://www.youtube.com/watch?v=4vhcOwVBDO4\" } ] }"
        let jsonResponseData = jsonResponseString.data(using: .utf8)
        dataFetcherDouble.dataFromURLImplementation = { url in
            expectation1.fulfill()
            XCTAssertEqual(url.absoluteString, "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
            return (jsonResponseData!, URLResponse())
        }
        featureFlagsProviderDouble.expectedServiceResponse = .error
        do {
            let _ = try await sut.getRecipes()
        } catch {
            expectation2.fulfill()
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it is missing.")
        }
        await fulfillment(of: [expectation1, expectation2], timeout: 1.0)
    }
}
