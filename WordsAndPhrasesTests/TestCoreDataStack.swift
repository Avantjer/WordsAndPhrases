//
//  TestCoreDataStack.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/16/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation
import CoreData
//@testable import WordsAndPhrases

class TestCoreDataStack: CoreDataStack {
    
    convenience init() {
        self.init(modelName: "Phrases")
    }
    
    override init(modelName: String) {
        super.init(modelName: modelName)
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        self.storeContainer = container
    }
}
