//
//  RecipesService.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import Foundation

protocol RecipesServiceProtocol {
    func getRecipes() async throws -> [RecipeModel]
}

final class RecipesService: RecipesServiceProtocol {
    private var featureFlagsProvider: FeatureFlagsProviderProtocol
    
    init(featureFlagsProvider: FeatureFlagsProviderProtocol) {
        self.featureFlagsProvider = featureFlagsProvider
    }
    
    func getRecipes() async throws -> [RecipeModel] {
        try await Task.sleep(for: .seconds(2.0))
        switch featureFlagsProvider.expectedServiceResponse {
        case .empty:
            featureFlagsProvider.expectedServiceResponse = .error
            return []
        case .success:
            featureFlagsProvider.expectedServiceResponse = .empty
            return [
                RecipeModel(
                    id: UUID(),
                    name: "Recipe's name",
                    cuisine: "Recipe's type of cuisine",
                    thumbnailPath: ""
                )
            ]
        case .error:
            featureFlagsProvider.expectedServiceResponse = .success
            throw NSError(domain: "123", code: 1)
        }
    }
}
