//
//  PhraseManager.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/16/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation
import CoreData

class PhraseManager {
    
    // MARK: - Properties
    
    let managedContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    
    // MARK: - Initializers
    
    init(coreDataStack: CoreDataStack) {
        self.managedContext = coreDataStack.managedContext
        self.coreDataStack = coreDataStack
    }
    
    func addWord(_ word: String) {
        // First make sure the word isn't just whitespace
        if word.trimmingCharacters(in: .whitespaces).isEmpty {
            return
        }
        
        // Then lets check to be sure this word isn't already stored.
        // We don't want duplicate words
        if wordExists(word: word) {
            print("the word \"\(word)\" is already known.")
            return
        }
        
        let newWord = Word(context: managedContext)
        newWord.word = word
        newWord.wordsAPICalled = false
        newWord.wordsAPIHasWord = false
        saveContext()
        
        // Not sure why we should create an instance.
        let theWordsAPI = WordsAPI(phraseManager: self)

        theWordsAPI.getInfo(for: word)

        saveContext()
    }

    func setWordsAPICalled(for word: String, wordsAPIHasWord: Bool) {
        
        let wordFetch = NSFetchRequest<Word>(entityName: "Word")
        wordFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Word.word), word)
        
        let theResult = try! managedContext.fetch(wordFetch)
        if theResult.count > 0 {
            let theWord = theResult.first
            theWord?.wordsAPICalled = true
            theWord?.wordsAPIHasWord = wordsAPIHasWord
            saveContext()
        }
    }
    
    func add(syllableCount: Int, for word: String) {
        
        let wordFetch = NSFetchRequest<Word>(entityName: "Word")
        wordFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Word.word), word)
        
        let theResult = try! managedContext.fetch(wordFetch)
        if theResult.count > 0 {
            let theWord = theResult.first
            theWord?.syllableCount = Int16(syllableCount)
            saveContext()
        }
    }
    
    func add(partsOfSpeech: [String], for word: String) {

        var theWord: Word?
        
        let wordFetch = NSFetchRequest<Word>(entityName: "Word")
        wordFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Word.word), word)
        
        let theResult = try! managedContext.fetch(wordFetch)
        if theResult.count > 0 {
            theWord = theResult.first!
        } else {
            return
        }
        
        for partOfSpeech in partsOfSpeech {
            let partOfSpeechFetch = NSFetchRequest<PartOfSpeech>(entityName: "PartOfSpeech")
            partOfSpeechFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(PartOfSpeech.partOfSpeech), partOfSpeech)
            
            var thePartOfSpeech: PartOfSpeech
            let theResult = try! managedContext.fetch(partOfSpeechFetch)
            if theResult.count > 0 {
                thePartOfSpeech = theResult.first!
            } else {
                thePartOfSpeech = PartOfSpeech(context: managedContext)
                thePartOfSpeech.partOfSpeech = partOfSpeech
            }
            thePartOfSpeech.addToWords(theWord!)
            theWord?.addToPartsOfSpeech(thePartOfSpeech)
        }
        
        saveContext()
    }
    
    func deletePhrase(_ phrase: String) {
        
        let phraseFetch = NSFetchRequest<Phrase>(entityName: "Phrase")
        phraseFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Phrase.phrase), phrase)
        
        let theResult = try! managedContext.fetch(phraseFetch)
        if theResult.count > 0 {
            let thePhrase = theResult[0]
            managedContext.delete(thePhrase)
            saveContext()
        }
    }
    
    func addPhrase(_ phrase: String) {
        
        // First make sure the phrase isn't just whitespace
        if phrase.trimmingCharacters(in: .whitespaces).isEmpty {
            return
        }
        
        // Then let's check to be sure this phrase isn't already stored.
        // We don't want duplicate phrases
        if phraseExists(phrase: phrase) {
            print("the phrase \"\(phrase)\" is already known.")
            return
        }
        
        let newPhrase = Phrase(context: managedContext)
        newPhrase.phrase = phrase
        self.saveContext()
        
        // Asynchronous
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            let theWords = String(Array(phrase.lowercased()).filter { (Character) -> Bool in
                Array(" abcdefghijklmnopqrstuvwxyz'-").contains(Character)
            }).components(separatedBy: " ")
            
            for theWord in theWords {
                // First make sure the word isn't just whitespace
                if !theWord.trimmingCharacters(in: .whitespaces).isEmpty {
                    self.addWord(theWord)
                }
            }
        }
    }
    
    func saveContext() {
        do {
            try self.managedContext.save()
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func phraseExists(phrase: String) -> Bool {
        let thePhraseCount = phraseCount(phrase: phrase)
        return thePhraseCount! > 0
    }
    
    func phraseCount(phrase: String) -> Int? {

        let phraseCountFetch = NSFetchRequest<NSNumber>(entityName: "Phrase")
        phraseCountFetch.resultType = .countResultType
        phraseCountFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Phrase.phrase), phrase)

        do {
            let countResult = try managedContext.fetch(phraseCountFetch)
            let count = countResult.first!.intValue
            return count
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
    
    func wordExists(word: String) -> Bool {
        
        let theWordCount = wordCount(word: word)
        return theWordCount! > 0
    }
    
    func wordCount(word: String) -> Int? {
        
        let wordCountFetch = NSFetchRequest<NSNumber>(entityName: "Word")
        wordCountFetch.resultType = .countResultType
        wordCountFetch.predicate = NSPredicate(format: "%K like[c] %@", #keyPath(Word.word), word)
        
        do {
            let results = try managedContext.fetch(wordCountFetch)
            let count = results.first!.intValue
            return count
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
    
    func getAllWords() {
        print("\nGet all words")
        let wordFetch = NSFetchRequest<Word>(entityName: "Word")
        
        do {
            let theWords = try managedContext.fetch(wordFetch)
            for theWord in theWords {
                print("\nWord:", theWord.word!)
                print("Syllable Count:", theWord.syllableCount)
                print("Words API Called:", theWord.wordsAPICalled)
                print("Words API Has Word:", theWord.wordsAPIHasWord)
                
                for partOfSpeech in theWord.partsOfSpeech! {
                    print("Part Of Speech:", (partOfSpeech as! PartOfSpeech).partOfSpeech!)
                }
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func getAllPhrases() {
        print("\nGet all phrases")
        let phraseFetch = NSFetchRequest<Phrase>(entityName: "Phrase")
        
        do {
            let thePhrases = try managedContext.fetch(phraseFetch)
            print()
            for thePhrase in thePhrases {
                print("Phrase:", thePhrase.phrase!)
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func getAllPartsOfSpeech() {
        print("\nGet all parts of speech")
        let partsOfSpeechFetch = NSFetchRequest<PartOfSpeech>(entityName: "PartOfSpeech")
        
        do {
            let thePartsOfSpeech = try managedContext.fetch(partsOfSpeechFetch)
            for thePartOfSpeech in thePartsOfSpeech {
                print("\nPart Of Speech:", thePartOfSpeech.partOfSpeech!)
                for theWord in thePartOfSpeech.words! {
                    print("Word:", (theWord as! Word).word!)
                }
                
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}
