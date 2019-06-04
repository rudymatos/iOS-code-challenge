//
//  YLPBusiness.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/3/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation

class CCYelpBusiness: NSObject{
    
    var name: String
    var identifier: String
    var categories: [CCYelpCategory]
    var rating: Double
    var reviewCount: Int
    var price: String
    var distance: Double
    var imageThumbnail : URL?
    var website: URL?
    var phone : String?
    var displayPhone: String?
    var location: CCYelpLocation?
    
    struct CCYelpLocation{
        var latitude: Double
        var longitude: Double
        
        func getObjectDict() -> [String:Any?]{
            return [
                "coordinates": ["latitude" : latitude, "longitude": longitude]
            ]
        }
    }
    
    struct CCYelpCategory{
        var alias: String
        var title: String
        init(data: [String:Any]){
            self.alias = data["alias"] as? String ?? ""
            self.title = data["title"] as? String ?? ""
        }
        
        func getObjectDic() -> [String:Any?]{
            return [
                "alias":alias,
                "title":title
            ]
        }
    }
    
    init(data: [String:Any?]){
        self.name = data["name"] as? String ?? ""
        self.identifier = data["id"] as? String ?? ""
        self.categories = []
        if let categories = data["categories"] as? [[String:Any]] {
            self.categories = categories.compactMap({CCYelpCategory.init(data: $0)})
        }
        if let website = data["url"] as? String{
            self.website = URL(string: website)
        }
        self.rating = data["rating"] as? Double ?? 0
        self.phone = data["phone"] as? String
        self.displayPhone = data["display_phone"] as? String
        self.reviewCount = data["review_count"] as? Int  ?? 0
        if let imageThumbnailURL = data["image_url"] as? String{
                self.imageThumbnail = URL(string: imageThumbnailURL)
        }
        self.distance = data["distance"] as? Double ?? 0
        self.price = data["price"] as? String ?? "NA"
        if let coordinates = data["coordinates"] as? [String: Double], let latitude = coordinates["latitude"], let longitude = coordinates["longitude"]{
            self.location = CCYelpLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    
    func getObjectDic() -> [String:Any?]{
        return [
            "name":name,
            "id":identifier,
            "categories":categories.compactMap({$0.getObjectDic()}),
            "rating":rating,
            "review_count":reviewCount,
            "image_url": imageThumbnail?.absoluteString,
            "distance":distance,
            "price":price,
            "coordinates": location?.getObjectDict()
        ]
    }
    
}
