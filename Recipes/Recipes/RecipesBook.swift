//
//  RecipesList.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import Foundation

class RecipesBook: ObservableObject {
    @Published var recipes: [Recipe] = [
        Recipe(
            id: UUID(),
            name: "Recipe's name",
            cuisine: "Recipe's type of cuisine",
            thumbnailPath: ""
        )
    ]
}
