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

enum Category : String, CaseIterable {
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology
}

class TopNewsViewController: UIViewController{
    private var viewModel = NewsViewModel()
    private var cellViewData = [NewsCellViewModel]()
    private var lastFetchedCount = 0
    private let dropDown = DropDown()
    private let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    private let moreSpinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    private var fetchMoreData = false
    private var page: Int = 1
    private var pageSize: Int = 10
    private var category: Category = Category.general
    fileprivate let cellId: String = "cellID"
    private var isLoading = true
    
    private lazy var tableView: UITableView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
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
        var dataSource = [String]()
        Category.allCases.forEach {
            dataSource.append($0.rawValue)
        }
        dropDown.dataSource =  dataSource
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            dropDownButton.setTitle(item, for: UIControl.State())
            dropDown.hide()
            category = Category(rawValue: item) ?? Category.general
            fetchNews(category: category, page: page, pageSize: pageSize)
        }
    }
    
    @objc private func handleDropDownButton() {
        dropDown.show()
    }
    
    func fetchNews(category: Category, page: Int, pageSize: Int) {
        viewModel.apiToGetNewsData(category: category.rawValue, page: page, pageSize: pageSize)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offY > abs(contentHeight - scrollView.frame.height) &&
           !isLoading {
            self.isLoading = true
            self.page = self.page + 1
            fetchNews(category: category, page: page, pageSize: pageSize)
        }
    }
}


extension TopNewsViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TopNewsTableCell
        cell.cellViewModel = cellViewData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: cellViewData[indexPath.row].url) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellViewData.count
    }
}

extension TopNewsViewController: DataModelDelegate {
      func didRecieveDataUpdate(data: [NewsCellViewModel], count: Int ) {
          self.cellViewData = data
          self.lastFetchedCount = count
          var indexPaths = [IndexPath]()
          if(self.lastFetchedCount < 1) {
              return
          }
          for i in 0...self.lastFetchedCount - 1 {
              let indexPath = IndexPath(row: (self.page - 1) * self.pageSize + i, section: 0)
              indexPaths.append(indexPath)
          }
          DispatchQueue.main.async {
              self.tableView.beginUpdates()
              self.tableView.insertRows(at: indexPaths, with: .bottom)
              self.tableView.endUpdates()
              self.spinner.stopAnimating()
          }
          self.isLoading = false
      }
}
