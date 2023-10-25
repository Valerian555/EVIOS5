//
//  DataManager.swift
//  EVALIOS5
//
//  Created by Student08 on 25/10/2023.
//

import Foundation
import CoreData

class DataManager {
    //Créer une instance partagée qui pourra être appelée dans toute mon app (Singleton)
    static let shared = DataManager()
    
    //permet d'accéder à ma db et de faire des opérations de lecture et d'écriture.
    let context: NSManagedObjectContext
    
    init() {
        //contient les modèles de ma db.
        let container = NSPersistentContainer(name: "Favorites")
        
        //définis l'emplacement où la base de données SQLite sera stockée.
        let dbFileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathExtension("db.sqlite")
        
        let storeDescription = NSPersistentStoreDescription(url: dbFileURL)
        container.persistentStoreDescriptions = [storeDescription]
        
        //Chargement de la base de données
        container.loadPersistentStores {description, error in
            if let error = error {
                print("Error loading persistent store:", error)
            }
        }
        context = container.viewContext
        
    }
    
    //utiliser pour enregistrer les modifications apportées à la base de données
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Error saving context", error)
        }
    }
    
    
    //ajout d'un film
    func addFavorite(id: Int, name: String, addedDate: Date) {
        let favorite = Favorite(context: context)
        
        favorite.id = Int64(id)
        favorite.name = name
        favorite.addedDate = addedDate
        
        saveContext()
    }
    
    //suppression d'un film de la db
    func deleteFavorite(_ favorite: Favorite) {
        context.delete(favorite)
        
        saveContext()
    }
    
    func deleteFavoriteById(id: Int) {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
    
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let favoriteToDelete = try context.fetch(fetchRequest).first {
                context.delete(favoriteToDelete)
                saveContext()
            }
        } catch {
            print("Error deleting movie: \(error)")
        }
    }
    
    func isInFavorite(favoriteId: Int) -> Bool {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %d", favoriteId)

        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking if movie is in favorites: \(error)")
            return false
        }
    }
}
