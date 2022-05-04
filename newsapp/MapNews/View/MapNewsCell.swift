//
//  MapNewsCell.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 15/04/22.
//

import UIKit

class MapNewsCell: UICollectionViewCell {
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        backgroundColor = .white
        layer.cornerRadius = 12
        
        addSubview(image)
        addSubview(headingLabel)
        addSubview(authorLabel)
        addSubview(contentLabel)
        
        layoutMargins = UIEdgeInsets.init(top: 8, left: 0, bottom: 0, right: 0)
       
        image.heightAnchor.constraint(equalToConstant: 80).isActive = true
        image.widthAnchor.constraint(equalToConstant: 80).isActive = true
        image.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        headingLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 16).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                               constant: -16).isActive = true

        authorLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 4).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 16).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                              constant: -16).isActive = true
       
        contentLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 16).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                               constant: -16).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
