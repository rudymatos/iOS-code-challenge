//
//  QueryParam.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/4/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation

struct QueryParam{
    
    var limit : Int
    var offset : Int
    var sortBy : SortBy = .distance
    var term: String
    var latitude: Double
    var longitude: Double
    var location: String
    var type: QueryType
    
    enum QueryType{
        case address
        case location
    }
    
    init(type: QueryType = .address){
        self.limit = 0
        self.offset = 0
        self.type = type
        self.term = ""
        self.latitude = 0
        self.longitude = 0
        self.location = "5550 West Executive Dr. Tampa, FL 33609"
    }
    
    enum SortBy: String, CaseIterable{
         case bestMatch = "best_match"
        case rating = "rating"
        case reviewCount = "review_count"
        case distance = "distance"
    }
    
    enum PredefinedCategories: String, CaseIterable{
        case pizza = "pizza"
        case mexican = "mexican"
        case burgers = "burgers"
        case italian = "italian"
        case greek = "greek"
        case caribbean = "caribbean"
    }
    

}

extension QueryParam{
    mutating func set(sortBy: SortBy){
        self.sortBy = sortBy
    }
    
    mutating func set(limit: Int, offset: Int){
        self.limit = limit
        self.offset = offset
    }
    
    mutating func set(latitude: Double, longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
        self.type = .location
    }
    
    mutating func set(term: String){
        self.term = term
    }

}


extension QueryParam{
    func getQueryDict() -> [String:Any]{
        var dictionary : [String : Any] = ["limit": limit, "offset": offset, "term": term, "sort_by": sortBy.rawValue, "radius": 40000]
        switch type {
        case .address:
            dictionary["location"] = location
        case .location:
            dictionary["latitude"] = latitude
            dictionary["longitude"] = longitude
        }
        return dictionary
    }
}
