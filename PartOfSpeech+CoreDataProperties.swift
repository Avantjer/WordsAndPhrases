//
//  PartOfSpeech+CoreDataProperties.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/26/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation
import CoreData


extension PartOfSpeech {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PartOfSpeech> {
        return NSFetchRequest<PartOfSpeech>(entityName: "PartOfSpeech")
    }

    @NSManaged public var partOfSpeech: String?
    @NSManaged public var words: NSSet?

}

// MARK: - Generated accessors for words
extension PartOfSpeech {

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: Word)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: Word)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSSet)

}
