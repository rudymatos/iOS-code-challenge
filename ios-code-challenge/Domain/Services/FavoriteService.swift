//
//  FavoriteService.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/3/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation

class FavoriteService{
    
    private let userDefaults = UserDefaults.standard
    static let main = FavoriteService()
    
    private init(){
    }

    func getAllFavorites() -> [CCYelpBusiness]{
        guard let favorites = userDefaults.object(forKey: "favorites") as? [[String:Any?]] else{
            return []
        }
        return favorites.compactMap({CCYelpBusiness(data: $0)})
    }

    func isBusinessFavorite(withId: String) -> Bool{
        return getAllFavorites().filter({$0.identifier == withId}).count > 0
    }

    func addToFavorite(business: CCYelpBusiness){
        var favorites = getAllFavorites()
        favorites.append(business)
        save(favorites: favorites)
    }
  
    private func save(favorites: [CCYelpBusiness]){
        let favoritesDict = favorites.compactMap({$0.getObjectDic()})
        userDefaults.set(favoritesDict, forKey: "favorites")
        userDefaults.synchronize()
    }
    
    func removeFromFavorites(business: CCYelpBusiness){
        let favorites = getAllFavorites().filter({$0.identifier != business.identifier})
        save(favorites: favorites)
    }
    
}

