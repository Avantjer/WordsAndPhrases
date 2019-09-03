//
//  AppleUI.swift
//  WordsAndPhrasesUITests
//
//  Created by Jerry Barnes on 9/2/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation

struct TextEditMenu {
    static let pasteMenuItem = app.menuItems["Paste"]
    static let selectAllMenuItem = app.menuItems["Select All"]
    
    static func tapPaste() {
        pasteMenuItem.tap()
    }

    static func tapSelectAll() {
        selectAllMenuItem.tap()
    }
}

