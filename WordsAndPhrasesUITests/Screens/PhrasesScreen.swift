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
        addButton.tap()
    }

}
