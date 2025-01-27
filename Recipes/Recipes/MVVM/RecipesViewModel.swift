//
//  RecipesList.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import Foundation

@MainActor
final class RecipesViewModel: ObservableObject {
    @Published var model: RecipeModel?
    @Published var error: String? = nil
    @Published var isFirstLoad: Bool = true
    
    private let service: RecipesServiceProtocol
    
    init(service: RecipesServiceProtocol) {
        self.service = service
    }
    
    func load() async {
        do {
            model = try await service.getRecipes()
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
        isFirstLoad = false
    }
}
