//
//  YelpAPIClient.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/3/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation

extension AFYelpAPIClient{
    func search(location: [String:Any], completion: @escaping ((Result<CCYelpSearch,CCError>) -> Void)){
        get("businesses/search", parameters: location, progress: nil, success: { (task, responseObject) in
            self.processResult(task: task, responseObject: responseObject, completion: completion)
        }) { (task, responseObject) in
            let error = CCError(message: "Invalid Results", type: .errorGettingBusinesses)
            completion(.failure(error))
        }
    }
    
    private func processResult(task: URLSessionDataTask, responseObject: Any?, completion: @escaping ((Result<CCYelpSearch,CCError>) -> Void)){
        guard let data = responseObject as? [String:Any] else{
            let error = CCError(message: "Invalid Results", type: .errorGettingBusinesses)
            completion(.failure(error))
            return
        }
        let yelpSearch = CCYelpSearch(data: data)
        completion(.success(yelpSearch))
    }
}
