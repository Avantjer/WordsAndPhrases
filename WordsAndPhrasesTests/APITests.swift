//
//  APITests.swift
//  APITests
//
//  Created by Jerry Barnes on 5/14/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import XCTest
@testable import WordsAndPhrases

class APITests: XCTestCase {
    
    // MARK: - Properties
    var sessionUnderTest: URLSession!
    
    // MARK: - setUp
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession.shared
    }
    
    // MARK: - tearDown
   override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    // MARK: - Test Methods
   func testGetPhraseSyllableCount() {
        let thePhrase = "When you wish upon a star"
        let thePhraseWords = thePhrase.split(separator: " ")

        for theWord in thePhraseWords {
            print("\nWord-> \"\(theWord)\"")
            let theData = dataForWord(String(theWord))
            print("JSON data: \(theData?.count ?? 0) bytes")
        }
        print()
    }
    
    func testCallToWordsAPISucceeds() {
        let theWord = "beautiful"
        let theData = dataForWord(theWord)
        print("\nJSON data: \(theData?.count ?? 0) bytes\n")
    }
    
    // MARK: - Private Methods
    private func dataForWord(_ theWord: String) -> Data? {

        // Create URL of endpoint
        guard let theURL = URL(string: "https://wordsapiv1.p.mashape.com/words/\(theWord)/syllables") else {
            print("Invalid URL string")
            fatalError()
        }
        
        // Create request with URL and include the API Key in the header
        var theURLRequest = URLRequest(url: theURL)
        theURLRequest.setValue("Ask Jerry For Authentication Key", forHTTPHeaderField: "X-Mashape-Key")
        theURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let theExpectation = expectation(description: "Completion handler invoked")
        
        var theData: Data?
        var theURLResponse: URLResponse?
        var theError: Error?
        
        let theDataTask = sessionUnderTest.dataTask(with: theURLRequest) { (data, response, error) in
            theData = data
            theURLResponse = response
            theError = error
            
            theExpectation.fulfill()
        }
        
        theDataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        if let theError = theError {
            XCTFail("An error was returned: \(theError)")
        }
        
        if let theStatusCode = (theURLResponse as? HTTPURLResponse)?.statusCode {
            XCTAssertEqual(theStatusCode, 200, "The status code was \(theStatusCode)")
        }
        
        if let theDataCount = theData?.count {
            XCTAssertGreaterThan(theDataCount, 0, "There was no data returned")
        }
        return theData
    }
}
