//
//  DetailViewController.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var businessIV: UIImageView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var categoriesLBL: UILabel!
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
        businessIV.loadImage(fromURL: business.imageThumbnail)
        nameLBL.text = business.name
        ratingLBL.text = "\(business.rating)"
        priceLBL.text = "\(business.price.count)"
        categoriesLBL.text = business.categories.compactMap({$0.title}).joined(separator: ",")
        _favorite = FavoriteService.main.isBusinessFavorite(withId: business.identifier)
        updateFavoriteBarButtonState()
        visualEffect.isHidden = true
    }
    
    func set(business: CCYelpBusiness) {
        self.business = business
    }
    
    private func updateFavoriteBarButtonState() {
        favoriteBarButtonItem.image = isFavorite ? UIImage(named: "Star-Filled") : UIImage(named: "Star-Outline")
    }
    
    @objc private func onFavoriteBarButtonSelected(_ sender: Any) {
        guard let business = business else {
            return
        }
        _favorite.toggle()
        if isFavorite{
            FavoriteService.main.addToFavorite(business: business)
        }else{
            FavoriteService.main.removeFromFavorites(business: business)
        }
        NotificationCenter.default.post(name: Notification.Name("favoriteModified"), object: nil, userInfo: nil)
        updateFavoriteBarButtonState()
    }
    
    @IBAction func goToWebsite(_ sender: UIButton) {
        open(url: business?.website)
    }
    
    @IBAction func callPlace(_ sender: UIButton) {
        guard var phone = business?.phone else {return}
        let invalidCharacters = ["-"," ","(",")","+"]
        invalidCharacters.forEach({phone = phone.replacingOccurrences(of: $0, with: "")})
        open(url: URL(string: "tel://\(phone)"))
    }
    
    
    @IBAction func showInMaps(_ sender: UIButton) {
        
        guard let placeLocation = business?.location else{
            return
        }
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: placeLocation.latitude, longitude: placeLocation.longitude)))
        destination.name = business?.name ?? "Destination"
        destination.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        
    }
    
    private func open(url: URL?){
        guard let url = url else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
