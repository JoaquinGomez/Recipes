//
//  ContentView.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import SwiftUI
import CoreData

struct RecipesView: View {
    @StateObject private var recipesList = RecipesViewModel(service: RecipesService())
    
    @ScaledMetric var scale: CGFloat = 1
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recipesList.recipes) { recipe in
                    HStack(alignment: .center, spacing: 5) {
                        Image(recipe.thumbnailPath)
                            .resizable()
                            .frame(width: 50 * scale, height: 50 * scale)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(recipe.name)
                                .font(.headline)
                            
                            Text(recipe.cuisine)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .task {
            recipesList.load()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}
