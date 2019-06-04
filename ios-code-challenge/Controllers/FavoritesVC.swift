//
//  FavoritesVC.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/3/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit

class FavoritesVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        registerNotifications()
    }
    
    private var selectedFavBusiness: CCYelpBusiness?
    
    private func registerCells(){
        tableView.register(UINib(nibName: "BusinessCell", bundle: Bundle.main), forCellReuseIdentifier: "businessCell")
    }
    
    private func registerNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(FavoritesVC.reloadData), name: Notification.Name("favoriteModified"), object: nil)
    }
    
    @objc private func reloadData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFavBusiness = FavoriteService.main.getAllFavorites()[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let controller = (segue.destination as? UINavigationController)?.viewControllers.first as? DetailViewController else {
                return
            }
            guard let business = self.selectedFavBusiness else{
                return
            }
            controller.set(business: business)
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteService.main.getAllFavorites().count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as? BusinessCell else{
            return UITableViewCell()
        }
        
        let business = FavoriteService.main.getAllFavorites()[indexPath.row]
        cell.configureView(business: business)
        return cell
    }
    
}
