//
//  HomeViewTableCell.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 30/04/22.
//

import UIKit

class HomeViewTableCell: UITableViewCell {
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "search"
        search.text = "Term Search"
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    lazy var label: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        contentView.isUserInteractionEnabled = true
        backgroundColor = .clear
        addSubview(label)
        addSubview(searchBar)
        
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
