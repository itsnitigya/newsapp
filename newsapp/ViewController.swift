//
//  ViewController.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 12/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var searchContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    lazy var locationContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    lazy var topContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    private lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.setupLabel()
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.setupLabel()
        return label
    }()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.setupLabel()
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "search"
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 7
        button.setTitle("SEARCH", for: UIControl.State())
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        button.addTarget(self, action: #selector(handleSearchButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleSearchButton() {
        print(searchBar.text ?? "")
    }
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 7
        button.setTitle("VIEW MAP", for: UIControl.State())
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        button.addTarget(self, action: #selector(handleLocationButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleLocationButton() {
        let mapViewController = MapsViewController()
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    private lazy var topButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 7
        button.setTitle("VIEW TOP HEADLINES", for: UIControl.State())
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        button.addTarget(self, action: #selector(handleTopButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleTopButton() {
        let topNewsViewController = TopNewsViewController()
        self.navigationController?.pushViewController(topNewsViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupViews()
    }
    
    
    func setupNavBar(){
        navigationItem.title = "iOS News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func setupViews(){
        view.addSubview(searchContainer)
        searchContainer.anchorWithConstants(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        searchContainer.heightAnchor.constraint(equalToConstant: 120).isActive = true
        searchLabel.text = "Term Search"
        searchContainer.addSubview(searchLabel)
        searchContainer.addSubview(searchBar)
        searchLabel.centerXAnchor.constraint(equalTo: searchContainer.centerXAnchor).isActive = true
        searchLabel.topAnchor.constraint(equalTo: searchContainer.topAnchor, constant: 8).isActive = true
        searchBar.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 8).isActive = true
        searchBar.leftAnchor.constraint(equalTo: searchContainer.leftAnchor, constant: 8).isActive = true
        searchBar.rightAnchor.constraint(equalTo: searchContainer.rightAnchor, constant: -8).isActive = true
        searchContainer.addSubview(searchButton)
        searchButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: searchContainer.centerXAnchor).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: -4).isActive = true

        view.addSubview(locationContainer)
        locationContainer.anchorWithConstants(top: searchContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        locationContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        locationLabel.text = "News by Location"
        locationContainer.addSubview(locationLabel)
        locationLabel.centerXAnchor.constraint(equalTo: locationContainer.centerXAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: locationContainer.topAnchor, constant: 8).isActive = true
        locationContainer.addSubview(locationButton)
        locationButton.centerXAnchor.constraint(equalTo: locationContainer.centerXAnchor).isActive = true
        locationButton.bottomAnchor.constraint(equalTo: locationContainer.bottomAnchor, constant: -4).isActive = true
        
        view.addSubview(topContainer)
        topContainer.anchorWithConstants(top: locationContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        topContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        topLabel.text = "Top Headlines"
        topContainer.addSubview(topLabel)
        topLabel.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor).isActive = true
        topLabel.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 8).isActive = true
        topContainer.addSubview(topButton)
        topButton.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor).isActive = true
        topButton.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: -4).isActive = true
    }

}

