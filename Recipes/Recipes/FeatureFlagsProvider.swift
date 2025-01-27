//
//  FeatureFlagsProvider.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import Foundation

enum ServiceResponse {
    case error
    case empty
    case success
}

protocol FeatureFlagsProviderProtocol {
    var expectedServiceResponse: ServiceResponse { get set }
}

final class FeatureFlagsProvider: FeatureFlagsProviderProtocol {
    var expectedServiceResponse: ServiceResponse = .error
    
    static let shared = FeatureFlagsProvider.init()
}
