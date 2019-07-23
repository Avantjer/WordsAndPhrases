//
//  FakeTests.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/15/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import XCTest
@testable import WordsAndPhrases

class FakeTests: XCTestCase {
    
    // MARK: - setUp
    override func setUp() {
        super.setUp()

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "humorous", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        print("Data:", data ?? "No data")
    }
    
    // MARK: - tearDown
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test Methods
    func testAPICallGetsExpectedJson() {
        
        let sut = APIClient()
        let jsonData = "{\"word\":\"humorous\",\"syllables\":{\"count\":3,\"list\":[\"hu\",\"mor\",\"ous\"]}}".data(using: .utf8)
        let mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        sut.session = mockURLSession
//        let syllableCountExpectation = expectation(description: "3")
//        var syllableCount: Int? = nil
        
        do {
            if let jsonData = jsonData,
                let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                let syllables = jsonDict["syllables"] as? [String: Any],
                let syllableCount = syllables["count"] as? Int {
                
                print("Number of syllables:", syllableCount)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

extension FakeTests {
    // MARK: - MockURLSession Class
    class MockURLSession: SessionProtocol {
        
        // MARK: - Properties
        var url: URL?
        private let dataTask: MockTask
        
        // MARK: - Methods
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            dataTask = MockTask(data: data, urlResponse: urlResponse, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            
            self.url = url
            dataTask.completionHandler = completionHandler
            return dataTask
        }
    }
    
    // MARK: - MockTask Class
    class MockTask: URLSessionDataTask {
 
        // MARK: - Properties
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        // MARK: - Methods
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = error
        }
        
        override func resume() {
            // Dispatch to the main queue to make completion handler
            // asynchronous to surrounding code
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlResponse, self.responseError)
            }
        }
    }
}





