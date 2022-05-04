//
//  UILabel.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 12/04/22.
//

import UIKit

extension UILabel {
    func setupLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 1
        textColor = .black
        textAlignment = .center
        font = UIFont(name: "HelveticaNeue-Medium", size: 16)
    }
}
