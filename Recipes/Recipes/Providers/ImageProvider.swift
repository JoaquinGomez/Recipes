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
    private let dataFetcher: DataFetcherProtocol
    
    init(cache: ImageCacheProtocol?, dataFetcher: DataFetcherProtocol) {
        self.cache = cache
        self.dataFetcher = dataFetcher
    }
    
    func getImage(urlString: String) async -> UIImage? {
        do {
            let result: UIImage?
            if let cachedData = await cache?.getImage(urlString: urlString), let cachedImage = UIImage(data: cachedData) {
                result = cachedImage
                print("image cached")
            } else {
                guard let url = URL(string: urlString) else {
                    return nil
                }
                
                var request = URLRequest(url: url)
                request.cachePolicy = .reloadIgnoringLocalCacheData
                let (data, _) = try await dataFetcher.data(for: request)
                guard let image = UIImage(data: data) else {
                    return nil
                }
                Task {
                    await cache?.saveImage(urlString: urlString, data: data)
                }
                result = image
                print("image fetched")
            }
            return result
        } catch {
            return nil
        }
    }
}

