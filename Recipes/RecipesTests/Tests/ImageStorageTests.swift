//
//  ImageStorageTests.swift
//  RecipesTests
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

import XCTest
import CoreData
@testable import Recipes

final class ImageStorageTests: XCTestCase {
    var sut: ImageStorage!
    var container: NSPersistentContainer!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        container = NSPersistentContainer(name: "Recipes")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error =  error {
                XCTFail()
            }
        }
        context = container.viewContext
        sut = ImageStorage(context: context)
    }

    override func tearDownWithError() throws {
        container = nil
        context = nil
        sut = nil
    }
    
    func testCreateAndReadSuccess() async {
        let image = UIImage(systemName: "fork.knife")!
        let imageData = image.pngData()!
        let date = Date()
        do {
            try await sut.create(imageData, url: "http://test.com/image", timestamp: date)
            let storedImage = try await sut.read(url: "http://test.com/image")
            XCTAssertNotNil(storedImage)
            XCTAssertEqual(storedImage?.data, imageData)
            XCTAssertEqual(storedImage?.timestamp, date)
        } catch {
            XCTFail()
        }
    }

    func testDeleteSuccess() async {
        let image = UIImage(systemName: "fork.knife")!
        let imageData = image.pngData()!
        do {
            try await sut.create(imageData, url: "http://test.com/image", timestamp: Date())
            try await sut.delete(url: "http://test.com/image")
            let storedImage = try await sut.read(url: "http://test.com/image")
            XCTAssertNil(storedImage)
        } catch {
            XCTFail()
        }
    }
    
    func testReadEmpty() async {
        do {
            let storedImage = try await sut.read(url: "http://test.com/image")
            XCTAssertNil(storedImage)
        } catch {
            XCTFail()
        }
    }
    
    func testDeleteEmpty() async {
        do {
            try await sut.delete(url: "http://test.com/image")
        } catch {
            XCTFail()
        }
    }
}
