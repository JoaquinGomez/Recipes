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
    func getRecipes() async throws -> [RecipeModel] {
        [
            RecipeModel(
                id: UUID(),
                name: "Recipe's name",
                cuisine: "Recipe's type of cuisine",
                thumbnailPath: ""
            )
        ]
    }
}
