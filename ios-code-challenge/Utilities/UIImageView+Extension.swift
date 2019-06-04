//
//  UIImageView+Extension.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/3/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation


private let imageCache = NSCache<NSString, UIImage>()


extension UIImageView{
    
    func loadImage(fromURL url: URL?){
        guard let url = url else{
            DispatchQueue.main.async {
                self.image = UIImage(named: "default_img")
            }
            return
        }
        
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString){
            print("getting image from cache")
            DispatchQueue.main.async {
                self.image = imageFromCache
            }
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {return}
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    print("making request")
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        strongSelf.image = image
                    }
                }
            }
        }
    }
    
}
