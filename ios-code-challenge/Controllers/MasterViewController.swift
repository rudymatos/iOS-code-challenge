//
//  MasterViewControllerS.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController?
    
    lazy private var dataSource : YelpDataSource? = {
       let dataSource = YelpDataSource(businesses: [])
        dataSource.setObjectsCompletion = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.tableView.reloadData()
        }
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        let query = YLPSearchQuery(location: "5550 West Executive Dr. Tampa, FL 33609")
        AFYelpAPIClient.shared().search(with: query, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            switch result{
            case .success(let searchResults):
                strongSelf.dataSource?.setObjects(businesses: searchResults.businesses)
            case .failure(let error):
                print(error)
            }
        })
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
//            guard let indexPath = tableView.indexPathForSelectedRow,
//                let controller = segue.destination as? DetailViewController else {
//                return
//            }
//            let object = objects[indexPath.row]
//            controller.setDetailItem(newDetailItem: object)
//            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
//            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }

}
