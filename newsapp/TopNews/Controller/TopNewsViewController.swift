//
//  TopNewsViewController.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 13/04/22.
//

import UIKit
import Alamofire
import DropDown
import SafariServices

class TopNewsViewController: UIViewController{
    var viewModel = NewsViewModel()
    var articles : ArticleResponse? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.spinner.stopAnimating()
            }
        }
    }
    let dropDown = DropDown()
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    let moreSpinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    var fetchMoreData = false
    var page: Int = 0
    var category: String = "general"
    fileprivate let cellId: String = "cellID"
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.clipsToBounds = true
        tv.layer.masksToBounds = true
        tv.register(TopNewsTableCell.self, forCellReuseIdentifier: cellId)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.layer.cornerRadius = 10
        tv.allowsSelection = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.separatorInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        return tv
    }()
    
    private lazy var dropDownButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 7
        button.setTitle("general", for: UIControl.State())
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
        button.addTarget(self, action: #selector(handleDropDownButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleDropDownButton() {
        dropDown.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
        setupDropDown()
        spinner.startAnimating()
        fetchNews(category: category, page: page, pageSize: 10)
    }
    
    func setupNavBar(){
        view.backgroundColor = .white
        navigationItem.title = "Top Headlines"
    }
    
    func setupViews(){
        view.addSubview(tableView)
        view.addSubview(dropDownButton)
        view.addSubview(moreSpinner)
        moreSpinner.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundView = spinner
        dropDownButton.anchorWithConstants(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0)
        moreSpinner.anchorWithConstants(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 16, rightConstant: 0)
        moreSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.anchorWithConstants(top: dropDownButton.bottomAnchor, left: view.leftAnchor, bottom: moreSpinner.topAnchor, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 4, rightConstant: 16)
    }
        
    func setupDropDown(){
        dropDown.anchorView = dropDownButton
        dropDown.dataSource =  ["general", "business", "entertainment", "health", "science", "sports", "technology"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            dropDownButton.setTitle(item, for: UIControl.State())
            dropDown.hide()
            category = item
            fetchNews(category: item, page: page, pageSize: 10)
        }
    }
    
    func fetchNews(category: String, page: Int, pageSize: Int) {
        viewModel.apiToGetNewsData(category: category, page: page, pageSize: pageSize) { [weak self] in
             self?.articles = self?.viewModel.newsData
        }
    }
}


extension TopNewsViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TopNewsTableCell
        cell.cellViewModel = self.viewModel.getCellViewModel(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: self.viewModel.newsData?.articles[indexPath.row].url ?? "") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == self.articles?.articles.count {
            DispatchQueue.main.async {
                self.moreSpinner.startAnimating()
            }
            self.page = self.page + 1
            fetchNews(category: self.category, page: page, pageSize: 10)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.newsData?.articles.count ?? 0
    }
}
