//
//  RecipesViewModelFactory.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

import Foundation

struct RecipesViewModelFactory {
    @MainActor static func makeRecipesViewModel() -> RecipesViewModel {
        RecipesViewModel(
            service: RecipesService(
                featureFlagsProvider: FeatureFlagsProvider.shared,
                dataFetcher: URLSession.shared
            ),
            imageProvider: ImageProvider(
                cache: ImageCache(
                    cacheExpiration: 1000000,
                    imageStorage: ImageStorageFactory.makeImageStorage()
                ),
                dataFetcher: URLSession.shared
            )
        )
    }
}
