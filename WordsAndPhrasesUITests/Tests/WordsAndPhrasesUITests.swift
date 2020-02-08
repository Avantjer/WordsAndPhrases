//
//  WordsAndPhrasesUITests.swift
//  WordsAndPhrasesUITests
//
//  Created by Jerry Barnes on 5/14/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import XCTest

let app = XCUIApplication()

class WordsAndPhrasesUITests: XCTestCase {
    
    // MARK: - Properties

    // MARK: - setUp
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app.launch()
    }
    
    // MARK: - tearDown
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test Methods
    func testAddAPhraseThenDeleteIt() {
        
        let thePhrase = "When you wish upon a star"
        
        PhrasesScreen.assertScreenIsPresented()
        
        let numberOfPhrasesBeforeAdd = PhrasesScreen.phraseCount

        PhrasesScreen.tapAddButton()
        
        AddAPhraseScreen.assertScreenIsPresented()
        AddAPhraseScreen.typePhrase(thePhrase)
        AddAPhraseScreen.tapDoneButton()
        
        PhrasesScreen.assertScreenIsPresented()
        PhrasesScreen.assertPhraseCount(numberOfPhrasesBeforeAdd + 1)
        PhrasesScreen.deletePhrase(thePhrase)
        PhrasesScreen.assertPhraseCount(numberOfPhrasesBeforeAdd)
    }
    
    func testAddAnEmptyPhraseDoesntAdd() {
        
        let thePhrase = ""
        
        PhrasesScreen.assertScreenIsPresented()

        let numberOfPhrasesBeforeAdd = PhrasesScreen.phraseCount
        PhrasesScreen.tapAddButton()
        
        AddAPhraseScreen.assertScreenIsPresented()
        AddAPhraseScreen.typePhrase(thePhrase)
        AddAPhraseScreen.tapDoneButton()
        
        PhrasesScreen.assertScreenIsPresented()
        PhrasesScreen.assertPhraseCount(numberOfPhrasesBeforeAdd)
    }
    
    func testAddWhitespacePhraseDoesntAdd() {
        
        let thePhrase = "  \t \n  "
        
        PhrasesScreen.assertScreenIsPresented()
        let numberOfPhrasesBeforeAdd = PhrasesScreen.phraseCount
        PhrasesScreen.tapAddButton()
        
        AddAPhraseScreen.assertScreenIsPresented()
        AddAPhraseScreen.typePhrase(thePhrase)
        AddAPhraseScreen.tapDoneButton()

        PhrasesScreen.assertScreenIsPresented()
        PhrasesScreen.assertPhraseCount(numberOfPhrasesBeforeAdd)
    }
    
    func testAddAPhraseThenCancel() {
        
        let thePhrase = "Makes no difference who you are"
        
        PhrasesScreen.assertScreenIsPresented()
        let numberOfPhrasesBeforeAdd = PhrasesScreen.phraseCount

        PhrasesScreen.tapAddButton()
        
        AddAPhraseScreen.assertScreenIsPresented()
        AddAPhraseScreen.typePhrase(thePhrase)
        AddAPhraseScreen.tapCancelButton()

        PhrasesScreen.assertScreenIsPresented()
        PhrasesScreen.assertPhraseCount(numberOfPhrasesBeforeAdd)
    }
    
    func testEditPhrase() {
        
        let phrase1 = "Play that funky music"
        let phrase2 = "Play that funky music right"
        
        PhrasesScreen.assertScreenIsPresented()
        PhrasesScreen.tapAddButton()
        
        AddAPhraseScreen.assertScreenIsPresented()
        AddAPhraseScreen.typePhrase(phrase1)
        AddAPhraseScreen.tapDoneButton()
        
        PhrasesScreen.assertScreenIsPresented()
        PhrasesScreen.assertPhrase(phrase1, exists: true)

        let numberOfPhrasesBeforeEdit = PhrasesScreen.phraseCount
        PhrasesScreen.tapPhrase(phrase1)
        
        AddAPhraseScreen.assertScreenIsPresented()

        TextEditMenu.tapTwiceToEditTextField(AddAPhraseScreen.phraseEntryTextField)
        TextEditMenu.selectAll()
        TextEditMenu.pasteString(phrase2)

        AddAPhraseScreen.tapDoneButton()
        
        PhrasesScreen.assertScreenIsPresented()
        PhrasesScreen.assertPhrase(phrase2, exists: true)
        PhrasesScreen.assertPhraseCount(numberOfPhrasesBeforeEdit)
        PhrasesScreen.deletePhrase(phrase2)
        PhrasesScreen.assertPhrase(phrase2, exists: false)
        PhrasesScreen.assertPhraseCount(numberOfPhrasesBeforeEdit - 1)
    }
    
    func testForUIElements() {
        
        PhrasesScreen.assertScreenIsPresented()
        PhrasesScreen.assertXCUIElement(PhrasesScreen.getInfoButton, exists: true)
        PhrasesScreen.assertXCUIElement(PhrasesScreen.addButton, exists: true)
 
        PhrasesScreen.tapAddButton()

        AddAPhraseScreen.assertScreenIsPresented()
        AddAPhraseScreen.assertXCUIElement(AddAPhraseScreen.cancelButton, exists: true)
        AddAPhraseScreen.assertXCUIElement(AddAPhraseScreen.doneButton, exists: true)
        AddAPhraseScreen.assertXCUIElement(AddAPhraseScreen.phraseLabel, exists: true)
        AddAPhraseScreen.assertXCUIElement(AddAPhraseScreen.phraseEntryTextField, exists: true)
    }
    
}












