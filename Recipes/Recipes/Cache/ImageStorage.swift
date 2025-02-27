//
//  Persistence.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import CoreData

struct StoredImage {
    let timestamp: Date?
    let data: Data?
}

protocol ImageStorageProtocol {
    func create(_ image: Data, url: String, timestamp: Date) async throws
    func read(url: String) async throws -> StoredImage?
    func delete(url: String) async throws
}

struct ImageStorage: ImageStorageProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func create(_ image: Data, url: String, timestamp: Date) async throws {
        await context.perform {
            let newItem = Item(context: context)
            newItem.timestamp = timestamp
            newItem.url = url
            newItem.data = image
            do {
                try context.save()
            } catch {
                print("Failed to save image: \(error)")
            }
        }
    }

    func read(url: String) async throws -> StoredImage? {
        guard let item = try await readItem(url: url) else {
            return nil
        }
        return StoredImage(timestamp: item.timestamp, data: item.data)
    }
    
    func delete(url: String) async throws {
        do {
            let item = try await readItem(url: url)
            if let item {
                try await context.perform {
                    context.delete(item)
                    try context.save()
                }
            }
        } catch {
            throw error
        }
    }
    
    private func readItem(url: String) async throws -> Item? {
        var result: Item?
        do {
            try await context.perform {
                let fetchRequest = Item.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "url = %@", url)
                result = try context.fetch(fetchRequest).first
            }
        } catch {
            throw error
        }
        return result
    }
}
