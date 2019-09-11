//
//  PhrasesScreen.swift
//  WordsAndPhrasesUITests
//
//  Created by Jerry Barnes on 9/2/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation
import XCTest

struct PhrasesScreen {
    static let navBarLabel = app.navigationBars["aiNavigationBar"].otherElements["Phrases"]
    static let addButton = app.buttons["aiAdd"]
    static let getInfoButton = app.buttons["aiGetInfo"]
    static let deleteButton = app.buttons["Delete"]
    
    static var phraseCount: Int {
        return app.tables["aiPhraseTable"].cells.count
    }
    
    static func phrase(_ phrase: String) -> XCUIElement {
        return app.staticTexts[phrase]
    }
    
    static func deletePhrase(_ phrase: String) {
        app.staticTexts[phrase].swipeLeft()
        deleteButton.tap()
    }
    
    static func tapAddButton() {
        addButton.tap()
    }

    static func tapPhrase(_ phrase: String) {
        app.staticTexts[phrase].tap()
    }
    
    static func assertNavBarLabel() {
        XCTAssertTrue(navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
    }
    
    static func assertScreenIsPresented() {
        XCTAssertTrue(navBarLabel.waitForExistence(timeout: 10), "Never saw 'Phrases' nav bar label")
    }
    
    static func assertPhrase(_ phrase: String, exists: Bool) {
        
        if exists == true {
            XCTAssertTrue(app.staticTexts[phrase].waitForExistence(timeout: 5), "Never saw phrase '\(phrase)'")
        } else {
            XCTAssertFalse(app.staticTexts[phrase].exists, "Expected phrase '\(phrase)' to not be present.")
        }
    }
    
    static func assertPhraseCount(_ expectedCount: Int) {
        XCTAssertEqual(phraseCount, expectedCount, "Error: Expected \(expectedCount) phrases, but got \(phraseCount)")
    }
    
    static func assertXCUIElement(_ xcuiElement: XCUIElement, exists: Bool) {
        
        if exists == true {
            XCTAssertTrue(xcuiElement.waitForExistence(timeout: 10), "Never saw XCUIElement")
        } else {
            XCTAssertFalse(xcuiElement.exists, "Expected XCUIElement to not exist")
        }
    }

}
