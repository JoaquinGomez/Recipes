//
//  ImageCacheDouble.swift
//  RecipesTests
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

import Foundation
@testable import Recipes

final class ImageCacheDouble: ImageCacheProtocol {
    var getImageImplementation: ((String) async -> Data?)!
    var saveImageImplementation: ((String, Data) async -> ())!
    
    func getImage(urlString: String) async -> Data? {
        await getImageImplementation(urlString)
    }
    
    func saveImage(urlString: String, data: Data) async {
        await saveImageImplementation(urlString, data)
    }
}
