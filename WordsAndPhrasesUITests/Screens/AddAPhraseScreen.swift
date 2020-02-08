//
//  AddAPhraseScreen.swift
//  WordsAndPhrasesUITests
//
//  Created by Jerry Barnes on 9/2/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation
import XCTest

struct AddAPhraseScreen {
    static let navBarLabel = app.navigationBars["aiNavigationBar"].staticTexts["Add a phrase"]
    static let cancelButton = app.buttons["aiCancel"]
    static let doneButton = app.buttons["aiDone"]
    static let phraseEntryTextField = app.textFields["aiPhrase"]
    static let phraseLabel = app.otherElements["PHRASE"]

    static func typePhrase(_ text: String) {
        phraseEntryTextField.tap()
        phraseEntryTextField.typeText(text)
    }
    
    static func tapDoneButton() {
        doneButton.tap()
    }

    static func tapCancelButton() {
        cancelButton.tap()
    }
    
    static func assertScreenIsPresented() {
        XCTAssertTrue(navBarLabel.waitForExistence(timeout: 10), "Never saw 'Add a phrase' nav bar label")
    }

    static func assertXCUIElement(_ xcuiElement: XCUIElement, exists: Bool) {
        
        if exists == true {
            XCTAssertTrue(xcuiElement.waitForExistence(timeout: 10), "Never saw XCUIElement")
        } else {
            XCTAssertFalse(xcuiElement.exists, "Expected XCUIElement to not exist")
        }
    }
    
}
