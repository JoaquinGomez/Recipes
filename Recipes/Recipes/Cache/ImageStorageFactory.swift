//
//  ImageStorageFactory.swift
//  Recipes
//
//  Created by JOAQUIN ENRIQUE GOMEZ LOPEZ on 2/1/25.
//

import CoreData

struct ImageStorageFactory {
    static func makeImageStorage() -> ImageStorageProtocol {
        let container = NSPersistentContainer(name: "Recipes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return ImageStorage(context: context)
    }
}
