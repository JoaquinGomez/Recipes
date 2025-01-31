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
    static let shared = ImageStorage()
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "Recipes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
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
