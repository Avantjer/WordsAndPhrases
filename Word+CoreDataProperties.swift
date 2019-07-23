//
//  Word+CoreDataProperties.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/26/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var syllableCount: Int16
    @NSManaged public var word: String?
    @NSManaged public var wordsAPICalled: Bool
    @NSManaged public var wordsAPIHasWord: Bool
    @NSManaged public var partsOfSpeech: NSSet?

}

// MARK: - Generated accessors for partsOfSpeech
extension Word {

    @objc(addPartsOfSpeechObject:)
    @NSManaged public func addToPartsOfSpeech(_ value: PartOfSpeech)

    @objc(removePartsOfSpeechObject:)
    @NSManaged public func removeFromPartsOfSpeech(_ value: PartOfSpeech)

    @objc(addPartsOfSpeech:)
    @NSManaged public func addToPartsOfSpeech(_ values: NSSet)

    @objc(removePartsOfSpeech:)
    @NSManaged public func removeFromPartsOfSpeech(_ values: NSSet)

}
