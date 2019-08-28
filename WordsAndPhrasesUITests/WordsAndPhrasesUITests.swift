//
//  WordsAndPhrasesUITests.swift
//  WordsAndPhrasesUITests
//
//  Created by Jerry Barnes on 5/14/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import XCTest

class WordsAndPhrasesUITests: XCTestCase {
    
    // MARK: - Properties
    let app = XCUIApplication()
    
    var doneButton: XCUIElement!
    var addButton: XCUIElement!
    var getInfoButton: XCUIElement!
    var cancelButton: XCUIElement!
    var deleteButton: XCUIElement!
    var pasteMenuItem: XCUIElement!
    var selectAllMenuItem: XCUIElement!
    var navigationBar: XCUIElement!
    var phrasesNavBarLabel: XCUIElement!
    var addAPhraseNavBarLabel: XCUIElement!
    var phraseEntryTextField: XCUIElement!

    // MARK: - setUp
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        doneButton = app.buttons["ai_Done"]
        addButton = app.buttons["ai_Add"]
        getInfoButton = app.buttons["ai_GetInfo"]
        cancelButton = app.buttons["ai_Cancel"]
        deleteButton = app.buttons["Delete"]
        pasteMenuItem = app.menuItems["Paste"]
        selectAllMenuItem = app.menuItems["Select All"]
        phraseEntryTextField = app.textFields["ai_Phrase"]

        navigationBar = app.navigationBars["ai_NavigationBar"]
        
        // Can't assign Accessibility Identifiers to Nav Bar Labels
        // phrasesNavBarLabel = navigationBar.otherElements["ai_Phrases"]
        // addAPhraseNavBarLabel = navigationBar.otherElements["ai_AddAPhrase"]
        phrasesNavBarLabel = navigationBar.otherElements["Phrases"]
        addAPhraseNavBarLabel = navigationBar.otherElements["Add a phrase"]
        
//        deleteDatabaseFiles()
        app.launch()
    }
    
    // MARK: - tearDown
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test Methods
    func testAddAPhraseThenDeleteIt() {
        
        let thePhrase = "When you wish upon a star"
        
        XCTAssertTrue(phrasesNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        
        let numberOfCellsBeforeAdd = app.cells.count
        
        addButton.tap()
        XCTAssertTrue(addAPhraseNavBarLabel.waitForExistence(timeout: 5), "Never saw 'Add a phrase' nav bar label")
        
        phraseEntryTextField.tap()
        phraseEntryTextField.typeText(thePhrase)
        
        doneButton.tap()
        XCTAssertTrue(phrasesNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfCellsAfterAdd = app.cells.count
        XCTAssertEqual(numberOfCellsAfterAdd, numberOfCellsBeforeAdd + 1, "Expected \(numberOfCellsBeforeAdd + 1) cells, but got \(numberOfCellsAfterAdd)")
        
        app.staticTexts[thePhrase].swipeLeft()
        deleteButton.tap()
        
        let numberOfCellsAfterDelete = app.cells.count
        XCTAssertEqual(numberOfCellsAfterDelete, numberOfCellsBeforeAdd, "Expected \(numberOfCellsBeforeAdd) cells, but got \(numberOfCellsAfterDelete)")
    }
    
    func testAddAnEmptyPhraseDoesntAdd() {
        
        let thePhrase = ""
        XCTAssertTrue(phrasesNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        let numberOfCellsBeforeAdd = app.cells.count
        addButton.tap()
        
        phraseEntryTextField.tap()
        phraseEntryTextField.typeText(thePhrase)
        doneButton.tap()
        
        XCTAssertTrue(phrasesNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfCellsAfterAdd = app.cells.count
        XCTAssertEqual(numberOfCellsAfterAdd, numberOfCellsBeforeAdd, "Expected \(numberOfCellsBeforeAdd) cells, but got \(numberOfCellsAfterAdd)")
    }
    
    func testAddWhitespacePhraseDoesntAdd() {
        
        let thePhrase = "  \t \n  "
        
        XCTAssertTrue(phrasesNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        let numberOfCellsBeforeAdd = app.cells.count
        addButton.tap()
        XCTAssertTrue(addAPhraseNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Add a phrase' nav bar label")

        phraseEntryTextField.tap()
        phraseEntryTextField.typeText(thePhrase)
        doneButton.tap()

        XCTAssertTrue(phrasesNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfCellsAfterAdd = app.cells.count
        XCTAssertEqual(numberOfCellsAfterAdd, numberOfCellsBeforeAdd, "Expected \(numberOfCellsBeforeAdd) cells, but got \(numberOfCellsAfterAdd)")
    }
    
    func testAddAPhraseThenCancel() {
        
        let thePhrase = "Makes no difference who you are"
        
        XCTAssertTrue(phrasesNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        let numberOfCellsBeforeAdd = app.cells.count

        addButton.tap()
        XCTAssertTrue(addAPhraseNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Add a phrase' nav bar label")
        
        phraseEntryTextField.tap()
        phraseEntryTextField.typeText(thePhrase)
        cancelButton.tap()
        
        XCTAssertTrue(phrasesNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfCellsAfterCancel = app.cells.count
        XCTAssertEqual(numberOfCellsBeforeAdd, numberOfCellsAfterCancel, "Expected \(numberOfCellsBeforeAdd) cells, but got \(numberOfCellsAfterCancel)")
    }
    
    func testEditPhrase() {
        let phrase1 = "Play that funky music"
        let phrase2 = "Play that funky music right"
        
        XCTAssertTrue(phrasesNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        addButton.tap()
        
        phraseEntryTextField.tap()
        phraseEntryTextField.typeText(phrase1)
        doneButton.tap()

        XCTAssertTrue(phrasesNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfCellsBeforeEdit = app.cells.count
        let phraseToEdit = app.staticTexts[phrase1]
        XCTAssertTrue(phraseToEdit.waitForExistence(timeout: 10), "Never saw \(phraseToEdit)")
        phraseToEdit.tap()

        UIPasteboard.general.string = phrase2
        phraseEntryTextField.doubleTap()
        
        guard selectAllMenuItem.waitForExistence(timeout: 5) else {
            XCTFail("Never saw the \"Select All\" Menu Item")
            return
        }
        
        selectAllMenuItem.tap()

        guard pasteMenuItem.waitForExistence(timeout: 5) else {
            XCTFail("Never saw the \"Paste\" Menu Item")
            return
        }

        pasteMenuItem.tap()
        sleep(1) // Need to wait a sec after "Paste" before tapping the "Done" button

        doneButton.tap()
        XCTAssertTrue(phrasesNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")

        let numberOfCellsAfterEdit = app.cells.count
        XCTAssertEqual(numberOfCellsBeforeEdit, numberOfCellsAfterEdit, "Error: Expected \(numberOfCellsBeforeEdit) cells after edit, but got \(numberOfCellsAfterEdit)")
        
        XCTAssertTrue(app.staticTexts[phrase2].waitForExistence(timeout: 5), "Never saw phrase '\(phrase2)' view")
        
        app.staticTexts[phrase2].swipeLeft()
        deleteButton.tap()

    }
    
    func testAccessibilityIdentifier() {
        
        XCTAssertTrue(phrasesNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
        XCTAssertTrue(getInfoButton.waitForExistence(timeout: 5), "Never saw 'Get Info' button")
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Never saw '+' (Add) button")
 
        addButton.tap()

        XCTAssertTrue(addAPhraseNavBarLabel.waitForExistence(timeout: 10), "Never saw 'Add a phrase' nav bar label")
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5), "Never saw 'Cancel' button")
        XCTAssertTrue(doneButton.waitForExistence(timeout: 5), "Never saw 'Done' button")
    }
    
}












