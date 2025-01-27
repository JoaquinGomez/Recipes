//
//  Recipe.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import Foundation

struct RecipeModel: Identifiable {
    var id: UUID
    let name: String
    let cuisine: String
    let thumbnailPath: String
}
