//
//  AppDelegate.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/14/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "Phrases")
    var managedContext: NSManagedObjectContext! = nil
    let phraseManager: PhraseManager! = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print("\nApp Library Folder -> \(applicationDocumentsDirectoryURL)\n")
        print("\nApplication Support Directory -> \(applicationSupportDirectoryURL())\n")
        
        guard let navController = window?.rootViewController as? UINavigationController, let viewController = navController.topViewController as? ViewController else {
            return true
        }
        
        // This is when the entire Core Data Stack gets initialized
        // Pass managedContext and phraseManager to viewController
        viewController.managedContext =  coreDataStack.managedContext
        viewController.phraseManager = PhraseManager(coreDataStack: coreDataStack)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Save pending changes before app is sent to the background
        coreDataStack.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Save pending changes before app is terminated
        coreDataStack.saveContext()
    }


}

