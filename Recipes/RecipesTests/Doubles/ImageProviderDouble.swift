//
//  ImageProviderDouble.swift
//  RecipesTests
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

import UIKit
@testable import Recipes

final class ImageProviderDouble: ImageProviderProtocol {
    var getImageImplementation: ((String) async -> UIImage?)!
    
    func getImage(urlString: String) async -> UIImage? {
        await getImageImplementation(urlString)
    }
}
