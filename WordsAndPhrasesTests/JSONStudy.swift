//
//  JSONStudy.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/24/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import XCTest

struct WordInfo: Decodable {
    var word: String
    var syllables: Syllables?
    var results: [Result]?
    var frequency: Double
}

struct Syllables: Decodable {
    var count: Int
}

struct Result: Decodable {
    var partOfSpeech: String?
}

class JSONStudy: XCTestCase {
    
    // MARK: - Properties
    var wordInfo: WordInfo!
    
    // MARK: - setUp
    override func setUp() {
        super.setUp()
        
        let testBundle = Bundle(for: type(of: self))
        guard let jsonFileURL = testBundle.url(forResource: "difference", withExtension: "json") else {
            print("File does not exist")
            return
        }
        
        do {
            let data = try Data(contentsOf: jsonFileURL)
            wordInfo = try! JSONDecoder().decode(WordInfo.self, from: data)
            
        } catch {
            print("Error:", error)
        }
    }
    
    // MARK: - tearDown
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test Methods
    func testGetWord() {
        let expectedWord = "difference"
        let word = wordInfo.word
        print("\nword: \(word)\n")
        XCTAssertEqual(word, expectedWord, "Expected word: \(expectedWord), but got \(word)")
    }
    
    func testGetSyllableCount() {
        let expectedSyllableCount = 3
        if let syllables = wordInfo.syllables {
            let syllableCount = syllables.count
            print("\nSyllable count: \(syllableCount)\n")
            XCTAssertEqual(syllableCount, expectedSyllableCount, "Expected Syllable count: \(expectedSyllableCount), but got \(syllableCount)")
        }
    }
    
    func testGetFrequency() {
        let expectedFrequency = 4.83
        let frequency = wordInfo.frequency
        print("\nfrequency: \(frequency)\n")
        XCTAssertEqual(frequency, expectedFrequency, "Expected frequency: \(expectedFrequency), but got \(frequency)")
    }
    
    func testGetPartsOfSpeech() {
        
        if let results = wordInfo.results {
            let expectedPOS: Set<String> = ["noun"]
            var partsOfSpeech = Set<String>()
            results.forEach() { result in
                if let partOfSpeech = result.partOfSpeech {
                    partsOfSpeech.insert(partOfSpeech)
                }
            }
            print("\npartsOfSpeech: \(partsOfSpeech)\n")
            XCTAssertEqual(partsOfSpeech, expectedPOS, "Expected parts of speech: \(expectedPOS), but got \(partsOfSpeech)")
        }
    }
    
}
