//
//  RecipesList.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import Foundation

@MainActor
final class RecipesViewModel: ObservableObject {
    @Published var recipes: [RecipeModel] = []
    @Published var error: String? = nil
    @Published var isEmpty: Bool = true
    
    private let service: RecipesServiceProtocol
    
    init(service: RecipesServiceProtocol) {
        self.service = service
    }
    
    func load() async {
        do {
            recipes = try await service.getRecipes()
            isEmpty = recipes.count < 1
        } catch {
            self.error = error.localizedDescription
        }
    }
}
