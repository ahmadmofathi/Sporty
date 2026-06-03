//
//  CoreData.swift
//  sporty
//
//  Created by Shady Ramadan on 02/06/2026.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "sporty")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
    
    func saveLeague(_ league: League, sport: String) {
        guard let key = league.leagueKey else { return }
        if isLeagueFavorite(byKey: key) { return }
        
        let favorite = NSEntityDescription.insertNewObject(forEntityName: "FavoriteLeague", into: context)
        favorite.setValue(Int64(key), forKey: "leagueKey")
        favorite.setValue(league.leagueName, forKey: "leagueName")
        favorite.setValue(league.countryKey != nil ? Int64(league.countryKey!) : 0, forKey: "countryKey")
        favorite.setValue(league.countryName, forKey: "countryName")
        favorite.setValue(league.leagueLogo, forKey: "leagueLogo")
        favorite.setValue(league.countryLogo, forKey: "countryLogo")
        favorite.setValue(sport, forKey: "sportType")
        
        saveContext()
    }
    
    func deleteLeague(byKey key: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteLeague")
        fetchRequest.predicate = NSPredicate(format: "leagueKey == %d", Int64(key))
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("Failed to delete league: \(error.localizedDescription)")
        }
    }
    
    func isLeagueFavorite(byKey key: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteLeague")
        fetchRequest.predicate = NSPredicate(format: "leagueKey == %d", Int64(key))
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
    
    func fetchAllFavorites() -> [League] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteLeague")
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { obj in
                League(
                    leagueKey: Int(obj.value(forKey: "leagueKey") as? Int64 ?? 0),
                    leagueName: obj.value(forKey: "leagueName") as? String,
                    countryKey: Int(obj.value(forKey: "countryKey") as? Int64 ?? 0),
                    countryName: obj.value(forKey: "countryName") as? String,
                    leagueLogo: obj.value(forKey: "leagueLogo") as? String,
                    countryLogo: obj.value(forKey: "countryLogo") as? String
                )
            }
        } catch {
            print("Failed to fetch favorites: \(error.localizedDescription)")
            return []
        }
    }
}
