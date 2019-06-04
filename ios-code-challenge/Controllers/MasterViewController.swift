//
//  MasterViewControllerS.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit
import CoreLocation

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var location: (latitude:CLLocationDegrees, longitude:CLLocationDegrees)?
    
    lazy private var dataSource : YelpDataSource? = {
       let dataSource = YelpDataSource(businesses: [])
        
        dataSource.setObjectsCompletion = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.tableView.reloadData()
        }
        
        dataSource.showBusinessInfoCompletion = { [weak self] selectedBusiness in
            guard let strongSelf = self else {return}
            strongSelf.performSegue(withIdentifier: "showDetail", sender: nil)
        }
        
        dataSource.loadNextBatch = { [weak self] currentCount, limit in
            guard let strongSelf = self else {return}
            var queryDict : [String:Any] = ["limit": limit, "offset": currentCount, "sort_by" : "distance", "term":""]
            if let location = strongSelf.location{
                queryDict["latitude"] = location.latitude
                queryDict["longitude"] = location.longitude
            }else{
                queryDict["location"] = "5550 West Executive Dr. Tampa, FL 33609"
            }
            AFYelpAPIClient.shared()?.search(location: queryDict, completion: { result in
                strongSelf.process(result: result)
            })
        }
        
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        addSearchController()
        LocationService.main.getCurrentLocationCompletion = { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let location):
                strongSelf.location = location
            case .failure:
                print("location not available")
            }
            strongSelf.tableView.dataSource = strongSelf.dataSource
            strongSelf.tableView.delegate = strongSelf.dataSource
        }
        LocationService.main.getCurrentLocation()
    }
    
    private func addSearchController(){
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchBar.tintColor = UIColor(named: SpeedParkConstants.Color.main)
        searchController.searchBar.delegate = self
    }
    
    private func process(result: Result<CCYelpSearch,CCError>){
        switch result{
        case .success(let searchResults):
            print("total: \(searchResults.total)")
            dataSource?.setObjects(businesses: searchResults.businesses, withTotalCount: searchResults.total)
        case .failure(let error):
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? false
        super.viewDidAppear(animated)
    }
    
    func registerCells(){
        tableView.register(UINib(nibName: "BusinessCell", bundle: Bundle.main), forCellReuseIdentifier: "businessCell")
        tableView.register(UINib(nibName: "LoadingCell", bundle: Bundle.main), forCellReuseIdentifier: "loadingCell")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let controller = (segue.destination as? UINavigationController)?.viewControllers.first as? DetailViewController else {
                return
            }
            guard let business = self.dataSource?.businesses[indexPath.row] else{
                return
            }
            controller.set(business: business)
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}


extension MasterViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterBy(value: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterBy(value: "")
    }
    
    private func filterBy(value: String){
        print("filtering by \(value)")
        var queryDict : [String: Any] = [:]
        if let location = location{
            queryDict = ["latitude": location.latitude, "longitude": location.longitude, "term" : value]
        }else{
            queryDict = ["term": "5550 West Executive Dr. Tampa, FL 33609", "term" : value]
        }
        AFYelpAPIClient.shared()?.search(location: queryDict, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            strongSelf.process(result: result)
        })
    }
    
}
