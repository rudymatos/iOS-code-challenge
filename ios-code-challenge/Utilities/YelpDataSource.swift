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
    var businesses : [CCYelpBusiness]
    
    var setObjectsCompletion: (() -> Void)?
    
    init(businesses: [CCYelpBusiness]){
        self.businesses = businesses
    }
    
    func setObjects(businesses: [CCYelpBusiness]){
        self.businesses = businesses
        setObjectsCompletion?()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as? BusinessCell else{
            return UITableViewCell()
        }
        let business = businesses[indexPath.row]
        cell.configureView(business: business)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("working with \(businesses[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
