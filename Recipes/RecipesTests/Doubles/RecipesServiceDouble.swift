//
//  RecipesServiceDouble.swift
//  RecipesTests
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

import Foundation
@testable import Recipes

final class RecipesServiceDouble: RecipesServiceProtocol {
    var getRecipesImplementation: (() async throws -> RecipeModel)!
    
    func getRecipes() async throws -> RecipeModel {
        try await getRecipesImplementation()
    }
}
