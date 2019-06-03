//
//  UIImageView+Extension.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/3/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation

extension UIImageView{
    
    func loadImage(withURL: URL){
        print("working with url :\(withURL)")
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            if let data = try? Data(contentsOf: withURL){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        strongSelf.image = image
                    }
                }
            }
        }
    }
    
}
