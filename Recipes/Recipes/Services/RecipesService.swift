//
//  RecipesService.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import Foundation

protocol RecipesServiceProtocol {
    func getRecipes() async throws -> RecipeModel
}

final class RecipesService: RecipesServiceProtocol {
    private var featureFlagsProvider: FeatureFlagsProviderProtocol
    
    init(featureFlagsProvider: FeatureFlagsProviderProtocol) {
        self.featureFlagsProvider = featureFlagsProvider
    }
    
    func getRecipes() async throws -> RecipeModel {
        let url: URL?
        switch featureFlagsProvider.expectedServiceResponse {
        case .empty:
            featureFlagsProvider.expectedServiceResponse = .error
            url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
        case .success:
            featureFlagsProvider.expectedServiceResponse = .empty
            url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
        case .error:
            featureFlagsProvider.expectedServiceResponse = .success
            url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
        }
        guard let url = url else {
            throw RecipesServiceError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(RecipeModel.self, from: data)
        } catch {
            throw error
        }
    }
}
