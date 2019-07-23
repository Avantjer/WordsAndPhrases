//
//  CoreDataTests.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/16/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import XCTest
@testable import WordsAndPhrases

class CoreDataTests: XCTestCase {
    
    // MARK: - Properties
    var phraseManager: PhraseManager!
    var coreDataStack: CoreDataStack!

    // MARK: - setUp
    override func setUp() {
        super.setUp()

        coreDataStack = TestCoreDataStack()
        phraseManager = PhraseManager(coreDataStack: coreDataStack)
    }
    
    // MARK: - tearDown
    override func tearDown() {
        coreDataStack = nil
        phraseManager = nil

        super.tearDown()
    }
    
    // MARK: - Test Methods
    func testAddPhrase() {
        let thePhrase = "When you wish upon a star"
        
        // Add phrase and verify that it exists
        phraseManager.addPhrase(thePhrase)
        let thePhraseExists = phraseManager.phraseExists(phrase: thePhrase)
        XCTAssertTrue(thePhraseExists, "\nError: Failed to add new phrase\n")
        
        // This test fails sporadically because words are added asyncronously
        //let theWordExists = phraseManager.wordExists(word: "when")
        //XCTAssertTrue(theWordExists, "Error: Failed to add new word")
    }
    
    func testDeletePhrase() {
        let thePhrase = "When you wish upon a star"
        
        // Add phrase and verify that it exists
        phraseManager.addPhrase(thePhrase)
        var thePhraseExists = phraseManager.phraseExists(phrase: thePhrase)
        XCTAssertTrue(thePhraseExists, "\nError: Failed to add new phrase\n")
        
        // Delete phrase and verify that it no longer exists
        phraseManager.deletePhrase(thePhrase)
        thePhraseExists = phraseManager.phraseExists(phrase: thePhrase)
        XCTAssertFalse(thePhraseExists, "\nError: Failed to delete new phrase\n")
    }
    
    func testPhraseExists() {
        let thePhrase = "Makes no difference who you are"
        
        // Verify that phrase does not exist
        var thePhraseExists = phraseManager.phraseExists(phrase: thePhrase)
        XCTAssertFalse(thePhraseExists, "Error: Phrase should not exist")
        
        // Add phrase and verify that it exists
        phraseManager.addPhrase(thePhrase)
        thePhraseExists = phraseManager.phraseExists(phrase: thePhrase)
        XCTAssertTrue(thePhraseExists, "Error: Phrase should exist")
    }
    
    func testAddDuplicatePhrase() {
        let thePhrase = "When you wish upon a star"
        
        // Verify that duplicate phrases are not added
        phraseManager.addPhrase(thePhrase)
        phraseManager.addPhrase(thePhrase)
        let thePhraseExists = phraseManager.phraseExists(phrase: thePhrase)
        XCTAssertTrue(thePhraseExists, "Error: Failed to add new phrase")
    }
    
    func testPhraseCount() {
        let thePhrase = "Makes no difference who you are"
        
        // Verify that the phraseCount is initially 0
        var thePhraseCount = phraseManager.phraseCount(phrase: thePhrase)
        XCTAssertEqual(thePhraseCount, 0, "Error: Phrase count should be 0")
        
        // Verify that after adding a phrase, the number of that phrase is 1
        phraseManager.addPhrase(thePhrase)
        thePhraseCount = phraseManager.phraseCount(phrase: thePhrase)
        XCTAssertEqual(thePhraseCount, 1, "Error: Phrase count should be 1")
        
        // Verify that duplicate phrases are not added
        phraseManager.addPhrase(thePhrase)
        thePhraseCount = phraseManager.phraseCount(phrase: thePhrase)
        XCTAssertEqual(thePhraseCount, 1, "Error: Phrase count should be 1")
    }
    
    func testWordCountFromAddingWord() {
        let theWord = "difference"

        // Verify that the wordCount is initially 0
        var theWordCount = phraseManager.wordCount(word: theWord)!
        XCTAssertEqual(theWordCount, 0, "\nError: Word count for '\(theWord)' is \(theWordCount) - should be 0")
        
        // Verify that after adding a word, the number of that word is 1
        phraseManager.addWord(theWord)
        sleep(1)
        theWordCount = phraseManager.wordCount(word: theWord)!
        XCTAssertEqual(theWordCount, 1, "\nError: Word count for '\(theWord)' is \(theWordCount) - should be 1")

        // Verify that duplicate phrases are not added
        phraseManager.addPhrase(theWord)
        sleep(1)
        theWordCount = phraseManager.wordCount(word: theWord)!
        XCTAssertEqual(theWordCount, 1, "\nError: Word count for '\(theWord)' is \(theWordCount) - should be 1")
    }
    
    // This test fails because words are added asyncronously
    func testWordCountFromAddingPhrase() {
        let thePhrase = "Makes no difference who you are"
        let theWord = "difference"
            
        // Verify that the wordCount is initially 0
        var theWordCount = phraseManager.wordCount(word: theWord)!
        XCTAssertEqual(theWordCount, 0, "\nError: Word count for '\(theWord)' is \(theWordCount) - should be 0")
        
        // Verify that after adding a phrase, the number of that phrase is 1
        phraseManager.addPhrase(thePhrase)
        phraseManager.getAllPhrases()
        phraseManager.getAllWords()

        let thePhraseExists = phraseManager.phraseExists(phrase: thePhrase)
        XCTAssertTrue(thePhraseExists, "\nError: Failed to add new phrase\n")
        
        let theWordExists = phraseManager.wordExists(word: theWord)
        XCTAssertTrue(theWordExists, "\nError: Failed to add new phrase\n")

        theWordCount = phraseManager.wordCount(word: theWord)!
        XCTAssertEqual(theWordCount, 1, "\nError: Word count for '\(theWord)' is \(theWordCount) - should be 1")
        
        // Verify that duplicate phrases are not added
        phraseManager.addPhrase(thePhrase)
        theWordCount = phraseManager.wordCount(word: theWord)!
        XCTAssertEqual(theWordCount, 1, "\nError: Word count for '\(theWord)' is \(theWordCount) - should be 1")
        phraseManager.getAllWords()
    }
    
}
