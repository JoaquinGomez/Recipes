//
//  FeatureFlagsProviderDouble.swift
//  RecipesTests
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

import Foundation
@testable import Recipes

final class FeatureFlagsProviderDouble: FeatureFlagsProviderProtocol {
    var expectedServiceResponse: Recipes.ServiceResponse
    
    init(expectedServiceResponse: Recipes.ServiceResponse) {
        self.expectedServiceResponse = expectedServiceResponse
    }
}
