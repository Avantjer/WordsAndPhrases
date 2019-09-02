//
//  WordsAndPhrasesUITests.swift
//  WordsAndPhrasesUITests
//
//  Created by Jerry Barnes on 5/14/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import XCTest

let app = XCUIApplication()

struct TextEditMenu {
    static let pasteMenuItem = app.menuItems["Paste"]
    static let selectAllMenuItem = app.menuItems["Select All"]
}

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
        
        let numberOfCellsBeforeAdd = app.cells.count
        
        PhrasesScreen.addButton.tap()
        XCTAssertTrue(AddAPhraseScreen.navBarLabel.waitForExistence(timeout: 5), "Never saw 'Add a phrase' nav bar label")
        
        AddAPhraseScreen.phraseEntryTextField.tap()
        AddAPhraseScreen.phraseEntryTextField.typeText(thePhrase)
        
        AddAPhraseScreen.doneButton.tap()
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfCellsAfterAdd = app.cells.count
        XCTAssertEqual(numberOfCellsAfterAdd, numberOfCellsBeforeAdd + 1, "Expected \(numberOfCellsBeforeAdd + 1) cells, but got \(numberOfCellsAfterAdd)")
        
        app.staticTexts[thePhrase].swipeLeft()
        PhrasesScreen.deleteButton.tap()
        
        let numberOfCellsAfterDelete = app.cells.count
        XCTAssertEqual(numberOfCellsAfterDelete, numberOfCellsBeforeAdd, "Expected \(numberOfCellsBeforeAdd) cells, but got \(numberOfCellsAfterDelete)")
    }
    
    func testAddAnEmptyPhraseDoesntAdd() {
        
        let thePhrase = ""
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        let numberOfCellsBeforeAdd = app.cells.count
        PhrasesScreen.addButton.tap()
        
        AddAPhraseScreen.phraseEntryTextField.tap()
        AddAPhraseScreen.phraseEntryTextField.typeText(thePhrase)
        AddAPhraseScreen.doneButton.tap()
        
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfCellsAfterAdd = app.cells.count
        XCTAssertEqual(numberOfCellsAfterAdd, numberOfCellsBeforeAdd, "Expected \(numberOfCellsBeforeAdd) cells, but got \(numberOfCellsAfterAdd)")
    }
    
    func testAddWhitespacePhraseDoesntAdd() {
        
        let thePhrase = "  \t \n  "
        
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        let numberOfCellsBeforeAdd = app.cells.count
        PhrasesScreen.addButton.tap()
        XCTAssertTrue(AddAPhraseScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Add a phrase' nav bar label")

        AddAPhraseScreen.phraseEntryTextField.tap()
        AddAPhraseScreen.phraseEntryTextField.typeText(thePhrase)
        AddAPhraseScreen.doneButton.tap()

        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfCellsAfterAdd = app.cells.count
        XCTAssertEqual(numberOfCellsAfterAdd, numberOfCellsBeforeAdd, "Expected \(numberOfCellsBeforeAdd) cells, but got \(numberOfCellsAfterAdd)")
    }
    
    func testAddAPhraseThenCancel() {
        
        let thePhrase = "Makes no difference who you are"
        
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        let numberOfCellsBeforeAdd = app.cells.count

        PhrasesScreen.addButton.tap()
        XCTAssertTrue(AddAPhraseScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Add a phrase' nav bar label")
        
        AddAPhraseScreen.phraseEntryTextField.tap()
        AddAPhraseScreen.phraseEntryTextField.typeText(thePhrase)
        AddAPhraseScreen.cancelButton.tap()
        
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfCellsAfterCancel = app.cells.count
        XCTAssertEqual(numberOfCellsBeforeAdd, numberOfCellsAfterCancel, "Expected \(numberOfCellsBeforeAdd) cells, but got \(numberOfCellsAfterCancel)")
    }
    
    func testEditPhrase() {
        let phrase1 = "Play that funky music"
        let phrase2 = "Play that funky music right"
        
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        PhrasesScreen.addButton.tap()
        
        AddAPhraseScreen.phraseEntryTextField.tap()
        AddAPhraseScreen.phraseEntryTextField.typeText(phrase1)
        AddAPhraseScreen.doneButton.tap()

        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfCellsBeforeEdit = app.cells.count
        let phraseToEdit = app.staticTexts[phrase1]
        XCTAssertTrue(phraseToEdit.waitForExistence(timeout: 10), "Never saw \(phraseToEdit)")
        phraseToEdit.tap()

        UIPasteboard.general.string = phrase2
        AddAPhraseScreen.phraseEntryTextField.doubleTap()
        
        guard TextEditMenu.selectAllMenuItem.waitForExistence(timeout: 5) else {
            XCTFail("Never saw the \"Select All\" Menu Item")
            return
        }
        
        TextEditMenu.selectAllMenuItem.tap()

        guard TextEditMenu.pasteMenuItem.waitForExistence(timeout: 5) else {
            XCTFail("Never saw the \"Paste\" Menu Item")
            return
        }

        TextEditMenu.pasteMenuItem.tap()
        sleep(1) // Need to wait a sec after "Paste" before tapping the "Done" button

        AddAPhraseScreen.doneButton.tap()
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfCellsAfterEdit = app.cells.count
        XCTAssertEqual(numberOfCellsBeforeEdit, numberOfCellsAfterEdit, "Error: Expected \(numberOfCellsBeforeEdit) cells after edit, but got \(numberOfCellsAfterEdit)")
        
        XCTAssertTrue(app.staticTexts[phrase2].waitForExistence(timeout: 5), "Never saw phrase '\(phrase2)' view")
        
        app.staticTexts[phrase2].swipeLeft()
        PhrasesScreen.deleteButton.tap()

    }
    
    func testAccessibilityIdentifier() {
        
        XCTAssertTrue(PhrasesScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        XCTAssertTrue(PhrasesScreen.getInfoButton.waitForExistence(timeout: 5), "Never saw 'Get Info' button")
        XCTAssertTrue(PhrasesScreen.addButton.waitForExistence(timeout: 5), "Never saw '+' (Add) button")
 
        PhrasesScreen.addButton.tap()

        XCTAssertTrue(AddAPhraseScreen.navBarLabel.waitForExistence(timeout: 10), "Never saw 'Add a phrase' nav bar label")
        XCTAssertTrue(AddAPhraseScreen.cancelButton.waitForExistence(timeout: 5), "Never saw 'Cancel' button")
        XCTAssertTrue(AddAPhraseScreen.doneButton.waitForExistence(timeout: 5), "Never saw 'Done' button")
    }
    
}












