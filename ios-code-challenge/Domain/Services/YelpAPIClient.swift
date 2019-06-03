//
//  YelpAPIClient.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/3/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation

extension AFYelpAPIClient{
    func search(with query: YLPSearchQuery, completion: @escaping ((Result<CCYelpPSearch,CCError>) -> Void)){
        get("businesses/search", parameters: query.parameters(), progress: nil, success: { (task, responseObject) in
            guard let data = responseObject as? [String:Any] else{
                let error = CCError(message: "Invalid Results", type: .errorGettingBusinesses)
                completion(.failure(error))
                return
            }
            let yelpSearch = CCYelpPSearch(data: data)
            completion(.success(yelpSearch))
        }) { (task, responseObject) in
            let error = CCError(message: "Invalid Results", type: .errorGettingBusinesses)
            completion(.failure(error))
        }
    }
}
