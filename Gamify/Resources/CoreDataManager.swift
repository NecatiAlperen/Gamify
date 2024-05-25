//
//  CoreDataManager.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 26.05.2024.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Gamify")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetchFavoriteGame(withName name: String) -> FavoriteGame? {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch favorite status: \(error)")
            return nil
        }
    }
    
    func fetchFavorites() throws -> [FavoriteGame] {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        return try context.fetch(fetchRequest)
    }
    
    func saveFavoriteGame(gameDetail: GameDetailResponse) {
        let favoriteGame = FavoriteGame(context: context)
        favoriteGame.name = gameDetail.name
        favoriteGame.backgroundImageURL = gameDetail.backgroundImage
        favoriteGame.rating = Double(gameDetail.metacritic ?? 0)
        favoriteGame.releaseDate = gameDetail.released
        
        saveContext()
    }
    
    func deleteFavoriteGame(_ favoriteGame: FavoriteGame) {
        context.delete(favoriteGame)
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
