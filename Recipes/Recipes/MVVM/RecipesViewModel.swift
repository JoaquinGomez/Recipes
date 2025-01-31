//
//  RecipesList.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import Foundation

@MainActor
final class RecipesViewModel: ObservableObject {
    @Published private(set) var model: RecipeModel?
    @Published private(set) var error: String? = nil
    
    private let service: RecipesServiceProtocol
    private let imageProvider: ImageProviderProtocol
    
    init(service: RecipesServiceProtocol, imageProvider: ImageProviderProtocol) {
        self.service = service
        self.imageProvider = imageProvider
    }
    
    func load() async {
        do {
            model = try await service.getRecipes()
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func loadImage(for recipe: Recipe) async {
        if let index = model?.recipes.firstIndex(where: { $0.uuid == recipe.uuid }) {
            print("loading image for recipe at index \(index)")
        }
        if let image = await imageProvider.getImage(urlString: recipe.thumbnailPath) {
            await MainActor.run {
                recipe.image = image
                objectWillChange.send()
            }
        }
    }
}
