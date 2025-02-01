//
//  ImageStorageDouble.swift
//  RecipesTests
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

import Foundation
@testable import Recipes

final class ImageStorageDouble: ImageStorageProtocol {
    var createImplementation: ((Data, String) async throws -> ())!
    var readImplementation: ((String) async throws -> StoredImage?)!
    var deleteImplementation: ((String) async throws -> ())!
    
    func create(_ image: Data, url: String) async throws {
        try await createImplementation(image, url)
    }
    
    func read(url: String) async throws -> StoredImage? {
        try await readImplementation(url)
    }
    
    func delete(url: String) async throws {
        try await deleteImplementation(url)
    }
}
