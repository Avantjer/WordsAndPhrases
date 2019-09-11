//
//  AppleUI.swift
//  WordsAndPhrasesUITests
//
//  Created by Jerry Barnes on 9/2/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation
import XCTest

struct TextEditMenu {
    static let pasteMenuItem = app.menuItems["Paste"]
    static let selectAllMenuItem = app.menuItems["Select All"]
    
    static func doubleTapToEditTextField(_ textField: XCUIElement) {
        textField.doubleTap()
    }
    
    static func pasteString(_ string: String) {
        UIPasteboard.general.string = string
        pasteMenuItem.tap()
        sleep(1) // Need to wait a sec after "Paste" before tapping the "Done" button
    }
    
    static func selectAll() {
        selectAllMenuItem.tap()
    }
}

