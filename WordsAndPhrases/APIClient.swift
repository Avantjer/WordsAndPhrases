//
//  APIClient.swift
//  WordsAndPhrases
//
//  Created by Jerry Barnes on 5/15/19.
//  Copyright © 2019 Purple Village. All rights reserved.
//

import Foundation

class APIClient {
    lazy var session: SessionProtocol = URLSession.shared
}

protocol SessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: SessionProtocol {}
