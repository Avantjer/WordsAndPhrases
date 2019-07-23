//
//  Phrase+CoreDataProperties.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/26/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation
import CoreData


extension Phrase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Phrase> {
        return NSFetchRequest<Phrase>(entityName: "Phrase")
    }

    @NSManaged public var phrase: String?

}
