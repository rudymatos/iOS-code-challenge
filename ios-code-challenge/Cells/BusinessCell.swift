//
//  BusinessCell.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/3/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var ratingLBL: UILabel!
    @IBOutlet weak var priceLBL: UILabel!
    @IBOutlet weak var distanceLBL: UILabel!
    @IBOutlet weak var categoriesLBL: UILabel!
    @IBOutlet weak var businessIV: UIImageView!
    
    var business: CCYelpBusiness!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        businessIV.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureView(business: CCYelpBusiness){
        self.business = business
        nameLBL.text = business.name
        ratingLBL.text = "\(business.rating)/5"
        priceLBL.text = business.price
        distanceLBL.text = "\(String(format: "%.2f", business.distance/1000)) miles away"
        categoriesLBL.text = business.categories.compactMap({$0.title}).joined(separator: ",")
        businessIV.loadImage(fromURL: business.imageThumbnail)
    }
    
}
