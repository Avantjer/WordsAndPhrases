//
//  WordsAPI.swift
//  URLSessionJSON
//
//  Created by Jerry Barnes on 5/13/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation
import CoreData

struct WordInfo: Decodable {
    var syllables: Syllables?
    var results: [Result]?
}

struct Syllables: Decodable {
    var count: Int
}

struct Result: Decodable {
    var partOfSpeech: String?
}

class WordsAPI {
    
    // MARK: - Properties
    
    let phraseManager: PhraseManager
    
    // MARK: - Initializers
    
    init(phraseManager: PhraseManager) {
        self.phraseManager = phraseManager
    }
    
    // MARK: - Methods
    
    func getInfo(for word: String) {
        
        let theURL = URL(string: "https://wordsapiv1.p.mashape.com/words/\(word)")
        
        var request = URLRequest(url: theURL!)
        request.setValue("Ask Jerry For Authentication Key", forHTTPHeaderField: "X-Mashape-Key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        print("__________________________________________")
        print("Request:", request)
        print("__________________________________________")
        
        let sharedSession = URLSession.shared
        let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in
            
            // Check response
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode != 200 {
                    print("\(word) - statusCode:", statusCode)
                    self.phraseManager.setWordsAPICalled(for: word, wordsAPIHasWord: false)
                    return
                }
                self.phraseManager.setWordsAPICalled(for: word, wordsAPIHasWord: true)
            }
            
            // Check error
            if let responseError = error {
                print("responseError:", responseError)
            }
            
            // Check data
            if let jsonData = data {
                let wordInfo = try! JSONDecoder().decode(WordInfo.self, from: jsonData)
                if let syllableCount = self.syllableCount(wordInfo: wordInfo) {
                    print("\(word) - syllableCount:", syllableCount)
                    self.phraseManager.add(syllableCount: syllableCount, for: word)
                } else {
                    print("\(word) - No syllableCount")
                }
                
                if let partsOfSpeech = self.partsOfSpeech(wordInfo: wordInfo) {
                    print("\(word) - partsOfSpeech:", partsOfSpeech)
                    self.phraseManager.add(partsOfSpeech: partsOfSpeech, for: word)
                } else {
                    print("\(word) - No partsOfSpeech")
                }
            }
        }
        dataTask.resume()
    }
    
    func partsOfSpeech(wordInfo: WordInfo) -> [String]? {
        
        if let results = wordInfo.results {
            var partsOfSpeech = Set<String>()
            results.forEach() { result in
                if let partOfSpeech = result.partOfSpeech {
                    partsOfSpeech.insert(partOfSpeech)
                }
            }
            return Array(partsOfSpeech)
        }
        return nil
    }
    
    func syllableCount(wordInfo: WordInfo) -> Int? {
        
        if let syllables = wordInfo.syllables {
            let syllableCount = syllables.count
            return syllableCount
        }
        return nil
    }
}
