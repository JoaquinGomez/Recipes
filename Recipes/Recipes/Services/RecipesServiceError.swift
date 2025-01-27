//
//  RecipesServiceError.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/27/25.
//

import Foundation

enum RecipesServiceError: Error {
    case invalidURL
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        }
    }
}
