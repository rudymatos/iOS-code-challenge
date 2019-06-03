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
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        addSearchController()
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        LocationService.main.getCurrentLocationCompletion = { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let location):
                strongSelf.location = location
                let queryDict = ["latitude": location.latitude, "longitude": location.longitude]
                AFYelpAPIClient.shared()?.search(location: queryDict, completion: { result in
                    strongSelf.process(result: result)
                })
            case .failure:
                let query = YLPSearchQuery(location: "5550 West Executive Dr. Tampa, FL 33609")
                AFYelpAPIClient.shared().search(with: query, completion: {  result in
                    strongSelf.process(result: result)
                })
            }
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
    
    private func process(result: Result<CCYelpPSearch,CCError>){
        switch result{
        case .success(let searchResults):
            dataSource?.setObjects(businesses: searchResults.businesses)
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
