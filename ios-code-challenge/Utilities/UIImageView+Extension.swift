//
//  UIImageView+Extension.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/3/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation

private let imageCache = NSCache<NSString, NSData>()

extension UIImageView{
    
    func loadImage(fromURL url: URL?){
        guard let url = url else{
            DispatchQueue.main.async {
                self.image = UIImage(named: "default_img")
            }
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString){
            DispatchQueue.main.async {
                let image = UIImage(data: imageFromCache as! Data)
                self.image = image
            }
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    imageCache.setObject(data as! NSData, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        strongSelf.image = image
                    }
                }
            }
        }
    }
    
}
