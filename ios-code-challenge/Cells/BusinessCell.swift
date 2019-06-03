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
    @IBOutlet weak var reviewCountLBL: UILabel!
    @IBOutlet weak var distanceLBL: UILabel!
    @IBOutlet weak var categoriesLBL: UILabel!
    @IBOutlet weak var businessIV: UIImageView!
    
    var business: CCYelpBusiness!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureView(business: CCYelpBusiness){
        self.business = business
        nameLBL.text = business.name
        ratingLBL.text = "\(business.rating)"
        reviewCountLBL.text = "\(business.reviewCount)"
        distanceLBL.text = "\(business.distance)"
        categoriesLBL.text = business.categories.compactMap({$0.title}).joined(separator: ",")
        if let imageURL = business.imageThumbnail{
            loadImage(withURL: imageURL)
        }
    }
    
    private func loadImage(withURL: URL){
        print("working with url :\(withURL)")
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            if let data = try? Data(contentsOf: withURL){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        strongSelf.businessIV.image = image
                    }
                }
            }
        }
    }
    
}
