//
//  Recipe.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

import UIKit

final class Recipe: Identifiable, Decodable {
    enum CodingKeys: String, CodingKey {
        case name, cuisine
        case uuid = "uuid"
        case thumbnailPath = "photo_url_small"
    }
    
    let uuid: String
    let name: String
    let cuisine: String
    let thumbnailPath: String
    
    var image: UIImage?
    
    var id: UUID {
        UUID(uuidString: uuid) ?? .init()
    }
}

