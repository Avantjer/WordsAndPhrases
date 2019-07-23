//
//  PhraseViewController.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/14/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import UIKit
import CoreData

class PhraseViewController: UITableViewController {
    
    var phraseManager: PhraseManager!
    var phraseToEdit: String?

    @IBOutlet var phrase: UITextField!
    
    @IBAction func done(_ sender: Any) {
        if phraseToEdit != nil {
            phraseManager.deletePhrase(phraseToEdit!)
        }
        
        // addPhrase won't add a phrase that contains only whitespace
        phraseManager.addPhrase(phrase.text!)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        if (phraseToEdit != nil) {
            phrase.text = phraseToEdit
        }
    }
}
