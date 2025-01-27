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
    
    private let service: RecipesServiceProtocol
    
    init(service: RecipesServiceProtocol) {
        self.service = service
    }
    
    func load() async {
        do {
            recipes = try await service.getRecipes()
        } catch {
            print(error)
        }
    }
}
