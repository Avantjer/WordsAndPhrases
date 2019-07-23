//
//  ViewController.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/14/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    var managedContext: NSManagedObjectContext!
    var phraseManager: PhraseManager!
    var fetchedResultsController: NSFetchedResultsController<Phrase>!
    
    @IBAction func getInfo(_ sender: Any) {
        phraseManager.getAllPhrases()
        phraseManager.getAllWords()
        phraseManager.getAllPartsOfSpeech()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Phrase> = Phrase.fetchRequest()
        
        // The 1st sort descriptor below sorts upper-case ahead of lower-case
        // The 2nd sort descriptor below sorts case-insensitive
        // let sort = NSSortDescriptor(key: #keyPath(Phrase.phrase), ascending: true)
        let sort = NSSortDescriptor(key: #keyPath(Phrase.phrase), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        fetchRequest.sortDescriptors = [sort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
       
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "phraseCell")!
        let thePhrase = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = thePhrase.phrase
        cell.detailTextLabel?.text = "0"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard case(.delete) = editingStyle else { return }
        
        let context = fetchedResultsController.managedObjectContext
        context.delete(fetchedResultsController.object(at: indexPath))
        
        do {
            try context.save()
        } catch let nserror as NSError {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    // Pass the PhraseManager over to the PhraseViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let thePhraseViewController = segue.destination as! PhraseViewController
        thePhraseViewController.phraseManager = phraseManager

        if segue.identifier == "EditSegue" {
            let theCellToEdit = sender as! UITableViewCell
            thePhraseViewController.phraseToEdit = theCellToEdit.textLabel!.text!
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
