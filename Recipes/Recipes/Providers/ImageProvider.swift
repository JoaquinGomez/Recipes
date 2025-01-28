//
//  ImageProvider.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/27/25.
//

import Foundation
import UIKit

protocol ImageProviderProtocol {
    func getImage(urlString: String) async -> UIImage?
}

final class ImageProvider: ImageProviderProtocol {
    private let cache: ImageCacheProtocol?
    
    init(cache: ImageCacheProtocol?) {
        self.cache = cache
    }
    
    func getImage(urlString: String) async -> UIImage? {
        do {
            let result: UIImage?
            if let cachedData = await cache?.getImage(urlString: urlString), let cachedImage = UIImage(data: cachedData) {
                result = cachedImage
            } else {
                guard let url = URL(string: urlString) else {
                    return nil
                }
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else {
                    return nil
                }
                cache?.saveImage(urlString: urlString, data: data)
                result = image
            }
            return result
        } catch {
            return nil
        }
    }
}

