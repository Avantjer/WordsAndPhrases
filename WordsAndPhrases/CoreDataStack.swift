//
//  CoreDataStack.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/14/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    public lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError?  {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    public func derivedContext() -> NSManagedObjectContext {
        let context = storeContainer.newBackgroundContext()
        return context
    }
    
    public func saveContext() {
        saveContext(managedContext)
    }
    
    public func saveContext(_ context: NSManagedObjectContext) {
        if context !== managedContext {
            saveDerivedContext(context)
            return
        }
        
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
        
    public func saveDerivedContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            self.saveContext(self.managedContext)
        }
    }
 }
