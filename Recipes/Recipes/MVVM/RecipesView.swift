//
//  ContentView.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import SwiftUI
import CoreData

struct RecipesView: View {
    @StateObject private var viewModel = RecipesViewModelFactory.makeRecipesViewModel()
    
    @ScaledMetric var scale: CGFloat = 1
    
    var body: some View {
        NavigationView {
            if viewModel.error == nil && viewModel.model == nil {
                ProgressView()
            } else {
                List {
                    if let error = viewModel.error {
                        Text(error)
                    } else if let recipes = viewModel.model?.recipes {
                        if recipes.count == 0 {
                            Text("There are no recipes to show, please try again")
                        } else {
                            ForEach(recipes) { recipe in
                                HStack(alignment: .center, spacing: 15) {
                                    Image(uiImage: recipe.image ?? UIImage(systemName: "fork.knife")!)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50 * scale, height: 50 * scale)
                                        .onAppear {
                                            Task {
                                                if recipe.image == nil {
                                                    await viewModel.loadImage(for: recipe)
                                                }
                                            }
                                        }
                                    
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
                }
                .refreshable {
                    await viewModel.load()
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}
