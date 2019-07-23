//
//  Functions.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/14/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation

let applicationDocumentsDirectoryURL: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()

func applicationSupportDirectoryURL() -> URL {
    let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
    return urls[0]
}

// This doesn't work
func deleteDatabaseFiles() {
    
    let hardPath = "/Users/jerrybarnes/Library/Developer/CoreSimulator/Devices/DA85AE33-21E6-4F72-909A-B197EB2315BB/data/Containers/Data/Application/B487741D-D3A4-4455-9F2C-80D7691EE958/Library/Application Support"
    
    print("\nNSNSHomeDirectory:", NSHomeDirectory())
    
    let appSupportDirectory = applicationSupportDirectoryURL()
    print("\nappSupportDirectory:", appSupportDirectory)

    let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
    print("\npath:", path)

    print(path + "/Phrases.sqlite")
    print(path + "/Phrases.sqlite-shm")
    print(path + "/Phrases.sqlite-wal")

    try? FileManager.default.removeItem(atPath: hardPath + "/Phrases.sqlite")
    try? FileManager.default.removeItem(atPath: hardPath + "/Phrases.sqlite-shm")
    try? FileManager.default.removeItem(atPath: hardPath + "/Phrases.sqlite-wal")

}
