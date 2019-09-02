//
//  PhrasesScreen.swift
//  WordsAndPhrasesUITests
//
//  Created by Jerry Barnes on 9/2/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation

struct PhrasesScreen {
    static let navBar = app.navigationBars["aiNavigationBar"]
    static let navBarLabel = navBar.otherElements["Phrases"]

    static let addButton = app.buttons["aiAdd"]
    static let getInfoButton = app.buttons["aiGetInfo"]
    static let deleteButton = app.buttons["Delete"]
}
