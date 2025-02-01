//
//  Recipe.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

import UIKit

final class Recipe: Identifiable, Decodable, Equatable {
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
    
    internal init(uuid: String, name: String, cuisine: String, thumbnailPath: String, image: UIImage? = nil) {
        self.uuid = uuid
        self.name = name
        self.cuisine = cuisine
        self.thumbnailPath = thumbnailPath
        self.image = image
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.uuid == rhs.uuid &&
        lhs.name == rhs.name &&
        lhs.cuisine == rhs.cuisine &&
        lhs.thumbnailPath == rhs.thumbnailPath &&
        lhs.image == rhs.image
    }
}

