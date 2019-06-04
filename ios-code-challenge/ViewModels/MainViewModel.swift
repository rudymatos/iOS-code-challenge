//
//  MainViewModel.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/4/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation
import CoreLocation

class MainViewModel{
    
    private var location: (latitude:CLLocationDegrees, longitude:CLLocationDegrees)?
    var query = QueryParam()
    
    var loadDataCompletion : (()->Void)?
    var showBusinessInfoCompletion : ((CCYelpBusiness) -> Void)?

    lazy var dataSource : YelpDataSource = {
        let dataSource = YelpDataSource(businesses: [])

        dataSource.showBusinessInfoCompletion = { [weak self] selectedBusiness in
            guard let strongSelf = self else {return}
            strongSelf.showBusinessInfoCompletion?(selectedBusiness)
        }
        
        dataSource.loadNextBatch = { [weak self] currentCount, limit in
            guard let strongSelf = self else {return}
            strongSelf.query.set(limit: limit, offset: currentCount)
            if let location = strongSelf.location{
                strongSelf.query.set(latitude: location.latitude, longitude: location.longitude)
            }
            AFYelpAPIClient.shared()?.search(withParams: strongSelf.query.getQueryDict(), completion: { result in
                strongSelf.process(result: result)
            })
        }
        return dataSource
    }()
    
    func getUserLocation(completion: @escaping(()->Void)){
        LocationService.main.getCurrentLocationCompletion = { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let location):
                strongSelf.location = location
                completion()
            case .failure:
                print("location not available")
            }
            strongSelf.loadDataCompletion?()
        }
        LocationService.main.getCurrentLocation()
    }
    
    func getBusiness(byRow: Int) -> CCYelpBusiness{
        return dataSource.businesses[byRow]
    }
    
    func getSortBy() -> [String]{
        return QueryParam.SortBy.allCases.compactMap({$0.rawValue})
    }
    
    func getCategories() -> [String]{
        return QueryParam.PredefinedCategories.allCases.compactMap({$0.rawValue})
    }
    
    func set(sortByValue: String){
        guard let sortBy = QueryParam.SortBy(rawValue: sortByValue) else{
            return
        }
        query.set(sortBy: sortBy)
        AFYelpAPIClient.shared()?.search(withParams: query.getQueryDict(), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            strongSelf.process(result: result, isFiltering: true)
        })
    }
    
    func filterResults(byValue: String){
        query.set(term: byValue)
        query.set(limit: dataSource.itemPerBatch, offset: 0)
        AFYelpAPIClient.shared()?.search(withParams: query.getQueryDict(), completion: {[weak self] result in
            guard let strongSelf = self else {return}
            strongSelf.process(result: result, isFiltering: true)
        })
    }
    
    private func process(result: Result<CCYelpSearch,CCError>, isFiltering: Bool = false){
        switch result{
        case .success(let searchResults):
            isFiltering ? dataSource.set(yelpSearchResult: searchResults) : dataSource.append(yelpSearchResult: searchResults)
            loadDataCompletion?()
        case .failure(let error):
            print(error)
        }
    }
    
}
