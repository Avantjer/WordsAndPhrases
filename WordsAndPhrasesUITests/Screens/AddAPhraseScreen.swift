//
//  AddAPhraseScreen.swift
//  WordsAndPhrasesUITests
//
//  Created by Jerry Barnes on 9/2/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation

struct AddAPhraseScreen {
    static let navBar = app.navigationBars["aiNavigationBar"]
    static let navBarLabel = navBar.otherElements["Add a phrase"]

    static let cancelButton = app.buttons["aiCancel"]
    static let doneButton = app.buttons["aiDone"]
    static let phraseEntryTextField = app.textFields["aiPhrase"]
}
