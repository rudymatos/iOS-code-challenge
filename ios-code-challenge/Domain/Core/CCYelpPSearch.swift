//
//  YLPSearch.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/3/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation

struct CCYelpPSearch{
    var businesses : [CCYelpBusiness]
    var total: Int
    
    init(data: [String:Any?]){
        businesses = []
        if let businessesData = data["businesses"] as? [[String:Any]]{
            businesses = businessesData.compactMap({CCYelpBusiness(data: $0)}).sorted(by: {$0.distance < $1.distance})
        }
        total = data["total"] as? Int ?? 0
    }
    
}
