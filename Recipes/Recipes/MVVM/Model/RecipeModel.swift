//
//  Recipe.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import Foundation

struct RecipeModel: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Identifiable, Decodable {
    enum CodingKeys: String, CodingKey {
        case name, cuisine
        case uuid = "uuid"
        case thumbnailPath = "photo_url_small"
    }
    
    let uuid: String
    let name: String
    let cuisine: String
    let thumbnailPath: String
    
    var id: UUID {
        UUID(uuidString: uuid) ?? .init()
    }
}
