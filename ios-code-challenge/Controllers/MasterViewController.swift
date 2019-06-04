//
//  MasterViewControllerS.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    private var searchController : UISearchController!
    private var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView(){
        registerCells()
        addSearchController()
        configureViewModelCompletion()
        viewModel.getUserLocation { [weak self] in
            self?.tableView.dataSource = self?.viewModel.dataSource
            self?.tableView.delegate = self?.viewModel.dataSource
        }
    }
    
    @IBAction func sortBy(_ sender: UIBarButtonItem) {
        let sortByList = viewModel.getSortBy()
        let completion : ((String) -> Void) = { [weak self] element in
            guard let strongSelf = self else {return}
            strongSelf.viewModel.set(sortByValue: element)
        }
        let view : UIView? = navigationItem.leftBarButtonItem?.value(forKey: "view") as? UIView
        generateAlertVC(withTitle: "Sort By", message: "Select an Item", elements: sortByList, completion: completion, displayOnView: view)
    }
    
    @IBAction func showCategories(_ sender: UIBarButtonItem) {
        let categories = viewModel.getCategories()
        let completion : ((String) -> Void) = { [weak self] element in
            guard let strongSelf = self else {return}
            strongSelf.viewModel.filterResults(byValue: element)
        }
        let view : UIView? = navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView
        generateAlertVC(withTitle: "Categories", message: "Select a Category", elements: categories, completion: completion, displayOnView: view)
    }
    
    private func generateAlertVC(withTitle title: String, message: String, elements: [String], completion : @escaping ((String) -> Void), displayOnView: UIView?){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for element in elements{
            let action = UIAlertAction(title: element, style: .default) { _ in
                completion(element)
            }
            alertVC.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        
        if let popOverController = alertVC.popoverPresentationController, let displayOnView = displayOnView{
            popOverController.sourceRect = displayOnView.frame
            popOverController.sourceView = displayOnView
        }
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func configureViewModelCompletion(){
        viewModel.loadDataCompletion = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.showBusinessInfoCompletion = { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.performSegue(withIdentifier: "showDetail", sender: nil)
        }
    }
    
    private func addSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
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
            let business = viewModel.getBusiness(byRow: indexPath.row)
            controller.set(business: business)
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}

extension MasterViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else{
            return
        }
        filterBy(value: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterBy(value: "")
    }
    
    private func filterBy(value: String){
        viewModel.filterResults(byValue: value)
    }
}
