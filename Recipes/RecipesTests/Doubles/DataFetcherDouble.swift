//
//  DataFetcherDouble.swift
//  RecipesTests
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

@testable import Recipes
import Foundation

final class DataFetcherDouble: DataFetcherProtocol {
    var dataFromURLImplementation: ((URL) async throws -> (Data, URLResponse))!
    var dataForRequestImplementation: ((URLRequest) async throws -> (Data, URLResponse))!
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await dataFromURLImplementation(url)
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await dataForRequestImplementation(request)
    }
}
