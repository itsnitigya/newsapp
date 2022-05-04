//
//  UIImageView.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 19/04/22.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(urlString: String) {
        sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "NoImage"))
    }
}
