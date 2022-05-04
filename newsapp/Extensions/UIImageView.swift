//
//  UIImageView.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 19/04/22.
//

import UIKit
import Alamofire

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func setImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        AF.request(url).response { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data!) else { return }
                imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                self.image = UIImage(data: data!)
            case .failure:
                self.image = UIImage(named: "noImage")
            }
        }
    }
}
