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
        
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        
        let numberOfPhrasesBeforeAdd = PhrasesScreen.phraseCount
        print("numberOfPhrasesBeforeAdd: \(numberOfPhrasesBeforeAdd)")

        PhrasesScreen.tapAddButton()
        XCTAssertTrue(AddAPhraseScreen.navBarLabel.waitForExistence(timeout: 5), "Never saw 'Add a phrase' nav bar label")
        
        AddAPhraseScreen.typePhrase(thePhrase)
        AddAPhraseScreen.tapDoneButton()
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfPhrasesAfterAdd = PhrasesScreen.phraseCount
        print("numberOfPhrasesAfterAdd: \(numberOfPhrasesAfterAdd)")
        
        XCTAssertEqual(numberOfPhrasesAfterAdd, numberOfPhrasesBeforeAdd + 1, "Expected \(numberOfPhrasesBeforeAdd + 1) cells, but got \(numberOfPhrasesAfterAdd)")
        
        PhrasesScreen.deletePhrase(thePhrase)

        let numberOfPhrasesAfterDelete = PhrasesScreen.phraseCount
        XCTAssertEqual(numberOfPhrasesAfterDelete, numberOfPhrasesBeforeAdd, "Expected \(numberOfPhrasesBeforeAdd) cells, but got \(numberOfPhrasesAfterDelete)")
    }
    
    func testAddAnEmptyPhraseDoesntAdd() {
        
        let thePhrase = ""
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        let numberOfPhrasesBeforeAdd = PhrasesScreen.phraseCount
        PhrasesScreen.tapAddButton()
        
        AddAPhraseScreen.typePhrase(thePhrase)
        AddAPhraseScreen.tapDoneButton()
        
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfPhrasesAfterAdd = PhrasesScreen.phraseCount
        XCTAssertEqual(numberOfPhrasesAfterAdd, numberOfPhrasesBeforeAdd, "Expected \(numberOfPhrasesBeforeAdd) cells, but got \(numberOfPhrasesAfterAdd)")
    }
    
    func testAddWhitespacePhraseDoesntAdd() {
        
        let thePhrase = "  \t \n  "
        
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        let numberOfPhrasesBeforeAdd = PhrasesScreen.phraseCount
        PhrasesScreen.tapAddButton()
        XCTAssertTrue(AddAPhraseScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Add a phrase' nav bar label")

        AddAPhraseScreen.typePhrase(thePhrase)
        AddAPhraseScreen.tapDoneButton()

        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfPhrasesAfterAdd = PhrasesScreen.phraseCount
        XCTAssertEqual(numberOfPhrasesAfterAdd, numberOfPhrasesBeforeAdd, "Expected \(numberOfPhrasesBeforeAdd) cells, but got \(numberOfPhrasesAfterAdd)")
    }
    
    func testAddAPhraseThenCancel() {
        
        let thePhrase = "Makes no difference who you are"
        
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        let numberOfPhrasesBeforeAdd = PhrasesScreen.phraseCount

        PhrasesScreen.tapAddButton()
        XCTAssertTrue(AddAPhraseScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Add a phrase' nav bar label")
        
        AddAPhraseScreen.typePhrase(thePhrase)
        AddAPhraseScreen.tapCancelButton()

        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfPhrasesAfterCancel = PhrasesScreen.phraseCount
        XCTAssertEqual(numberOfPhrasesBeforeAdd, numberOfPhrasesAfterCancel, "Expected \(numberOfPhrasesBeforeAdd) cells, but got \(numberOfPhrasesAfterCancel)")
    }
    
    func testEditPhrase() {
        let phrase1 = "Play that funky music"
        let phrase2 = "Play that funky music right"
        
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        PhrasesScreen.tapAddButton()
        
        AddAPhraseScreen.typePhrase(phrase1)

        AddAPhraseScreen.tapDoneButton()

        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfPhrasesBeforeEdit = PhrasesScreen.phraseCount
        var phraseToEdit = PhrasesScreen.phrase(phrase1)
        XCTAssertTrue(phraseToEdit.waitForExistence(timeout: 10), "Never saw \(phraseToEdit)")
        PhrasesScreen.tapPhrase(phrase1)

        UIPasteboard.general.string = phrase2
        AddAPhraseScreen.phraseEntryTextField.doubleTap()
        
        guard TextEditMenu.selectAllMenuItem.waitForExistence(timeout: 5) else {
            XCTFail("Never saw the \"Select All\" Menu Item")
            return
        }
        
        TextEditMenu.tapSelectAll()

        guard TextEditMenu.pasteMenuItem.waitForExistence(timeout: 5) else {
            XCTFail("Never saw the \"Paste\" Menu Item")
            return
        }

        TextEditMenu.tapPaste()
        sleep(1) // Need to wait a sec after "Paste" before tapping the "Done" button

        AddAPhraseScreen.tapDoneButton()
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfPhrasesAfterEdit = PhrasesScreen.phraseCount
        XCTAssertEqual(numberOfPhrasesBeforeEdit, numberOfPhrasesAfterEdit, "Error: Expected \(numberOfPhrasesBeforeEdit) cells after edit, but got \(numberOfPhrasesAfterEdit)")
        
        phraseToEdit = PhrasesScreen.phrase(phrase2)
        XCTAssertTrue(phraseToEdit.waitForExistence(timeout: 5), "Never saw phrase '\(phrase2)' view")
        
        PhrasesScreen.deletePhrase(phrase2)
    }
    
    func testAccessibilityIdentifier() {
        
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        XCTAssertTrue(PhrasesScreen.getInfoButton.waitForExistence(timeout: 5), "Never saw 'Get Info' button")
        XCTAssertTrue(PhrasesScreen.addButton.waitForExistence(timeout: 5), "Never saw '+' (Add) button")
 
        PhrasesScreen.tapAddButton()

        XCTAssertTrue(AddAPhraseScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Add a phrase' nav bar label")
        XCTAssertTrue(AddAPhraseScreen.cancelButton.waitForExistence(timeout: 5), "Never saw 'Cancel' button")
        XCTAssertTrue(AddAPhraseScreen.doneButton.waitForExistence(timeout: 5), "Never saw 'Done' button")
    }
    
}












