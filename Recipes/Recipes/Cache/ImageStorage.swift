//
//  Persistence.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 1/26/25.
//

import CoreData

protocol ImageStorageProtocol {
    func create(_ image: Data, url: String) async throws
    func read(url: String) async throws -> Item?
    func delete(url: String) async throws
}

struct ImageStorage: ImageStorageProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func create(_ image: Data, url: String) async throws {
        await context.perform {
            let newItem = Item(context: context)
            newItem.timestamp = Date()
            newItem.url = url
            newItem.data = image
            do {
                try context.save()
            } catch {
                print("Failed to save image: \(error)")
            }
        }
    }
    
    func read(url: String) async throws -> Item? {
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
    
    func delete(url: String) async throws {
        do {
            let item = try await read(url: url)
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
}
