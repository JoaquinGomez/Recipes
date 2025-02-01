//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import XCTest
@testable import Recipes

final class RecipesViewModelTests: XCTestCase {
    var sut: RecipesViewModel!
    var recipesServiceDouble: RecipesServiceDouble!
    var imageProviderDouble: ImageProviderDouble!

    @MainActor override func setUpWithError() throws {
        recipesServiceDouble = .init()
        imageProviderDouble = .init()
        sut = .init(service: recipesServiceDouble, imageProvider: imageProviderDouble)
    }

    override func tearDownWithError() throws {
        recipesServiceDouble = nil
        imageProviderDouble = nil
        sut = nil
    }
    
    @MainActor func testInitialState() {
        XCTAssertNil(sut.error)
        XCTAssertNil(sut.model)
    }
    
    @MainActor func testLoadSuccess() async {
        let expectation = expectation(description: "RecipesService.getRecipes is called")
        let recipesModel = RecipeModel(
            recipes: [Recipe(uuid: "uuid", name: "recipe", cuisine: "cuisine", thumbnailPath: "http://test.com/image")]
        )
        recipesServiceDouble.getRecipesImplementation = {
            expectation.fulfill()
            return recipesModel
        }
        await sut.load()
        XCTAssertEqual(sut.model, recipesModel)
        XCTAssertNil(sut.error)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    @MainActor func testLoadFailure() async {
        let expectation = expectation(description: "RecipesService.getRecipes is called")
        recipesServiceDouble.getRecipesImplementation = {
            expectation.fulfill()
            throw RecipesServiceError.invalidURL
        }
        await sut.load()
        XCTAssertNil(sut.model)
        XCTAssertEqual(sut.error, RecipesServiceError.invalidURL.localizedDescription)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    @MainActor func testLoadImageSuccess() async {
        let expectation = expectation(description: "ImageProvider.getImage is called")
        let image = UIImage(systemName: "fork.knife")
        imageProviderDouble.getImageImplementation = { url in
            expectation.fulfill()
            XCTAssertEqual(url, "http://test.com/image")
            return image
        }
        let recipe = Recipe(uuid: "uuid", name: "recipe", cuisine: "cuisine", thumbnailPath: "http://test.com/image")
        await sut.loadImage(for: recipe)
        XCTAssertEqual(recipe.image, image)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    @MainActor func testLoadImageFailure() async {
        let expectation = expectation(description: "ImageProvider.getImage is called")
        imageProviderDouble.getImageImplementation = { url in
            expectation.fulfill()
            XCTAssertEqual(url, "http://test.com/image")
            return nil
        }
        let recipe = Recipe(uuid: "uuid", name: "recipe", cuisine: "cuisine", thumbnailPath: "http://test.com/image")
        await sut.loadImage(for: recipe)
        XCTAssertEqual(recipe.image, nil)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
