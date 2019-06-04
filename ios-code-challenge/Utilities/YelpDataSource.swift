//
//  YelpDataSource.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/3/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation
import UIKit

class YelpDataSource: NSObject, UITableViewDelegate, UITableViewDataSource{
    
    let itemPerBatch = 50
    var currentCount = 0
    var totalCount = 0
    
    var businesses : [CCYelpBusiness]
    
    var loadNextBatch: ((Int,Int) -> Void)?
    var showBusinessInfoCompletion : ((CCYelpBusiness) -> Void)?
    
    init(businesses: [CCYelpBusiness]){
        self.businesses = businesses
    }
    
    func set(yelpSearchResult: CCYelpSearch){
        self.businesses = yelpSearchResult.businesses
        self.totalCount = yelpSearchResult.total
        self.currentCount = itemPerBatch
    }
    
    func append(yelpSearchResult:CCYelpSearch){
        self.businesses.append(contentsOf:  yelpSearchResult.businesses)
        self.totalCount = yelpSearchResult.total
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if totalCount == 0 || (businesses.count < totalCount){
            return businesses.count + 1
        }else{
            return businesses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == businesses.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            loadNextBatch?(currentCount, itemPerBatch)
            currentCount += itemPerBatch
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as? BusinessCell else{
                return UITableViewCell()
            }
            let business = businesses[indexPath.row]
            cell.configureView(business: business)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBusiness = businesses[indexPath.row]
        showBusinessInfoCompletion?(selectedBusiness)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
