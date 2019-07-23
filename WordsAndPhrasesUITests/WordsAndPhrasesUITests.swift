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
    var phrasesHeading: XCUIElement!
    var addAPhraseHeading: XCUIElement!

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
        navigationBar = app.navigationBars["ai_NavigationBar"]
//        phrasesHeading = navigationBar.otherElements["ai_Phrases"]
        phrasesHeading = navigationBar.otherElements["Phrases"]
//        addAPhraseHeading = navigationBar.otherElements["ai_AddAPhrase"]
        addAPhraseHeading = navigationBar.otherElements["Add a phrase"]
        
        
        deleteDatabaseFiles()
        app.launch()
    }
    
    // MARK: - tearDown
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test Methods
    func testAddAPhraseThenDeleteIt() {
        
        let thePhrase = "When you wish upon a star"
        
        XCTAssertTrue(phrasesHeading.waitForExistence(timeout: 10), "Never saw 'Phrases' view")
        let numberOfCellsBeforeAdd = app.cells.count
        addButton.tap()
        XCTAssertTrue(addAPhraseHeading.waitForExistence(timeout: 5), "Never saw 'Add a phrase' view")
        
        let textField = app.cells.children(matching: .textField).element
        
        // typeText is flakey and causes tests to fail
        // ...so using "Paste" from the UIPasteboard as a workaround
        //textField.tap()
        //textField.typeText(thePhrase)
        
        UIPasteboard.general.string = thePhrase
        textField.doubleTap()
        pasteMenuItem.tap()
        sleep(5)

        doneButton.tap()
        XCTAssertTrue(phrasesHeading.waitForExistence(timeout: 10), "Never saw 'Phrases' view")

        let numberOfCellsAfterAdd = app.cells.count
        XCTAssertEqual(numberOfCellsAfterAdd, numberOfCellsBeforeAdd + 1, "Expected \(numberOfCellsBeforeAdd + 1) cells, but got \(numberOfCellsAfterAdd)")
        
        app.staticTexts[thePhrase].swipeLeft()
        deleteButton.tap()
        
        let numberOfCellsAfterDelete = app.cells.count
        XCTAssertEqual(numberOfCellsAfterDelete, numberOfCellsBeforeAdd, "Expected \(numberOfCellsBeforeAdd) cells, but got \(numberOfCellsAfterDelete)")
    }
    
    func testAddAnEmptyPhraseDoesntAdd() {
        
        let thePhrase = ""
        XCTAssertTrue(phrasesHeading.waitForExistence(timeout: 10), "Never saw 'Phrases' view")
        let numberOfCellsBeforeAdd = app.cells.count
        addButton.tap()
        
        let textField = app.cells.children(matching: .textField).element
        UIPasteboard.general.string = thePhrase
        textField.doubleTap()
        pasteMenuItem.tap()
        sleep(1)

        doneButton.tap()
        XCTAssertTrue(phrasesHeading.waitForExistence(timeout: 10), "Never saw 'Phrases' view")

        let numberOfCellsAfterAdd = app.cells.count
        XCTAssertEqual(numberOfCellsAfterAdd, numberOfCellsBeforeAdd, "Expected \(numberOfCellsBeforeAdd) cells, but got \(numberOfCellsAfterAdd)")
    }
    
    func testAddWhitespacePhraseDoesntAdd() {
        
        let thePhrase = "  \t \n  "
        
        XCTAssertTrue(phrasesHeading.waitForExistence(timeout: 10), "Never saw 'Phrases' view")
        let numberOfCellsBeforeAdd = app.cells.count
        addButton.tap()
        XCTAssertTrue(addAPhraseHeading.waitForExistence(timeout: 10), "Never saw 'Add a phrase' view")

        let textField = app.cells.children(matching: .textField).element
        UIPasteboard.general.string = thePhrase
        textField.doubleTap()
        pasteMenuItem.tap()
        sleep(1)
        doneButton.tap()

        XCTAssertTrue(phrasesHeading.waitForExistence(timeout: 10), "Never saw 'Phrases' view")

        let numberOfCellsAfterAdd = app.cells.count
        XCTAssertEqual(numberOfCellsAfterAdd, numberOfCellsBeforeAdd, "Expected \(numberOfCellsBeforeAdd) cells, but got \(numberOfCellsAfterAdd)")
    }
    
    func testAddAPhraseThenCancel() {
        
        let thePhrase = "Makes no difference who you are"
        
        XCTAssertTrue(phrasesHeading.waitForExistence(timeout: 10), "Never saw 'Phrases' view")
        let numberOfCellsBeforeAdd = app.cells.count

        addButton.tap()
        XCTAssertTrue(addAPhraseHeading.waitForExistence(timeout: 10), "Never saw 'Add a phrase' view")
        
        let textField = app.cells.children(matching: .textField).element
        
        // typeText is flakey and causes tests to fail
        // ...so using "Paste" from the UIPasteboard as a workaround
        //textField.tap()
        //textField.typeText(thePhrase)
        
        UIPasteboard.general.string = thePhrase
        textField.doubleTap()
        pasteMenuItem.tap()
        sleep(1)
        
        cancelButton.tap()
        XCTAssertTrue(phrasesHeading.waitForExistence(timeout: 10), "Never saw 'Phrases' view")

        let numberOfCellsAfterCancel = app.cells.count
        XCTAssertEqual(numberOfCellsBeforeAdd, numberOfCellsAfterCancel, "Expected \(numberOfCellsBeforeAdd) cells, but got \(numberOfCellsAfterCancel)")
    }
    
    func testEditPhrase() {
        let phrase1 = "Play that funky music"
        let phrase2 = "Play that funky music right"
        
        XCTAssertTrue(phrasesHeading.waitForExistence(timeout: 10), "Never saw 'Phrases' view")
        addButton.tap()
        let textField = app.cells.children(matching: .textField).element
      
        UIPasteboard.general.string = phrase1
        textField.doubleTap()
        pasteMenuItem.tap()
        sleep(1)
        doneButton.tap()

        XCTAssertTrue(phrasesHeading.waitForExistence(timeout: 10), "Never saw 'Phrases' view")

        let numberOfCellsBeforeEdit = app.cells.count
        let phraseToEdit = app.staticTexts[phrase1]
        XCTAssertTrue(phraseToEdit.waitForExistence(timeout: 10), "Never saw \(phraseToEdit)")
        phraseToEdit.tap()

        UIPasteboard.general.string = phrase2
        textField.doubleTap()
        selectAllMenuItem.tap()
        sleep(1)
        pasteMenuItem.tap()
        sleep(1)
        doneButton.tap()
        XCTAssertTrue(phrasesHeading.waitForExistence(timeout: 10), "Never saw 'Phrases' view")

        let numberOfCellsAfterEdit = app.cells.count
        XCTAssertEqual(numberOfCellsBeforeEdit, numberOfCellsAfterEdit, "Error: Expected \(numberOfCellsBeforeEdit) cells after edit, but got \(numberOfCellsAfterEdit)")
        
        XCTAssertTrue(app.staticTexts[phrase2].waitForExistence(timeout: 5), "Never saw phrase '\(phrase2)' view")
        
        app.staticTexts[phrase2].swipeLeft()
        deleteButton.tap()

    }
    
    func testAccessibilityIdentifier() {
        
        XCTAssertTrue(phrasesHeading.waitForExistence(timeout: 10), "Never saw 'Phrases' heading")
        XCTAssertTrue(getInfoButton.waitForExistence(timeout: 5), "Never saw 'Get Info' button")
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Never saw '+' (Add) button")
 
        addButton.tap()

        XCTAssertTrue(addAPhraseHeading.waitForExistence(timeout: 10), "Never saw 'Add a phrase' heading")
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5), "Never saw 'Cancel' button")
        XCTAssertTrue(doneButton.waitForExistence(timeout: 5), "Never saw 'Done' button")
    }
    
    func testNestedFailure() {
        
        XCTContext.runActivity(named: "Level 1") { _ in
            print()
            XCTContext.runActivity(named: "Level 2") { _ in
                print()
                XCTContext.runActivity(named: "Level 3") { _ in
                    XCTAssertNotNil(nil)
                }
            }
        }
    }
    
}












