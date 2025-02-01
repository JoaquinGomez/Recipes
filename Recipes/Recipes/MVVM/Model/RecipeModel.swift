//
//  Recipe.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import Foundation

struct RecipeModel: Decodable, Equatable {
    var recipes: [Recipe]
    
    static func == (lhs: RecipeModel, rhs: RecipeModel) -> Bool {
        lhs.recipes == rhs.recipes
    }
}
