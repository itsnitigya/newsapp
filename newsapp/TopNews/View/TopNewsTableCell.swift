//
//  TopNewsTableCell.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 13/04/22.
//

import UIKit

class TopNewsTableCell: UITableViewCell {
    
    lazy var contentImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 15
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var headingLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var authorLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cellViewModel: NewsCellViewModel? {
        didSet {
            headingLabel.text = cellViewModel?.heading
            authorLabel.text = cellViewModel?.author
            contentLabel.text = cellViewModel?.content
            contentImage.setImage(urlString: cellViewModel?.imageURL ?? "")
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        backgroundColor = .clear
        
        addSubview(contentImage)
        addSubview(headingLabel)
        addSubview(authorLabel)
        addSubview(contentLabel)
        
        layoutMargins = UIEdgeInsets.init(top: 8, left: 0, bottom: 0, right: 0)
       
        contentImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        contentImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        contentImage.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        contentImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        headingLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: contentImage.trailingAnchor, constant: 16).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true

        authorLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 4).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: contentImage.trailingAnchor, constant: 16).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
       
        contentLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: contentImage.trailingAnchor, constant: 16).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
