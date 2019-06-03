//
//  DetailViewController.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var businessIV: UIImageView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var categoriesLBL: UILabel!
    @IBOutlet weak var reviewCountLBL: UILabel!
    @IBOutlet weak var distanceLBL: UILabel!
    @IBOutlet weak var priceLBL: UILabel!
    @IBOutlet weak var ratingLBL: UILabel!
    
    lazy private var favoriteBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Star-Outline"), style: .plain, target: self, action: #selector(onFavoriteBarButtonSelected(_:)))

    @objc var business: CCYelpBusiness?
    
    private var _favorite: Bool = false
    private var isFavorite: Bool {
        get {
            return _favorite
        } 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        navigationItem.rightBarButtonItems = [favoriteBarButtonItem]
    }
    
    private func configureView() {
        guard let business = business else { return }
        if let imageURL =  business.imageThumbnail{
            businessIV.loadImage(withURL: imageURL)
        }
        nameLBL.text = business.name
        ratingLBL.text = "\(business.rating)"
        reviewCountLBL.text = "\(business.reviewCount)"
        distanceLBL.text = "\(business.distance)"
        priceLBL.text = business.price
        categoriesLBL.text = business.categories.compactMap({$0.title}).joined(separator: ",")
    }
    
    func set(business: CCYelpBusiness) {
        self.business = business
    }
    
    private func updateFavoriteBarButtonState() {
        favoriteBarButtonItem.image = isFavorite ? UIImage(named: "Star-Filled") : UIImage(named: "Star-Outline")
    }
    
    @objc private func onFavoriteBarButtonSelected(_ sender: Any) {
        _favorite.toggle()
        updateFavoriteBarButtonState()
    }
}
