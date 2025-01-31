//
//  ImageCache.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/27/25.
//

import Foundation
import UIKit

protocol ImageCacheProtocol {
    func getImage(urlString: String) async -> Data?
    func saveImage(urlString: String, data: Data) async
}

final class ImageCache: ImageCacheProtocol {
    private let cacheExpiration: TimeInterval
    private let imageStorage: ImageStorageProtocol
    
    init(cacheExpiration: TimeInterval, imageStorage: ImageStorageProtocol) {
        self.cacheExpiration = cacheExpiration
        self.imageStorage = imageStorage
    }
    
    func getImage(urlString: String) async -> Data? {
        do {
            guard let image = try await imageStorage.read(url: urlString), let data = image.data else {
                return nil
            }
            if let imageExpirationDate = image.timestamp?.addingTimeInterval(cacheExpiration), imageExpirationDate >= Date.now {
                return data
            } else {
                try? await imageStorage.delete(url: urlString)
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    
    func saveImage(urlString: String, data: Data) async {
        do {
            try await imageStorage.create(data, url: urlString)
        } catch {
            print(error)
        }
    }
}

