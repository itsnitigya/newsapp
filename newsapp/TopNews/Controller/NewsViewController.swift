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
import Combine

enum Category: String, CaseIterable {
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology
    case error
}

enum State {
    case noData
    case loaded
    case loading
    case noMoreData
    case noInternet
}

enum PageType {
    case display
    case top
    case search
}

class NewsViewController: UIViewController {
    private var cellViewData: [NewsCellModel]
    private let pageType: PageType
    private let navigationTitle: String
    
    private var viewModel = NewsViewModel()
    private let dropDown = DropDown()
    private let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    private let moreSpinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    private var fetchMoreData = false
    private var page = 1
    private var pageSize = 10
    private var category = Category(rawValue: AppData.category) ?? Category.general
    private let cellId = "cellID"
    private var cancellable = [AnyCancellable]()
    private var searchedText = ""
    
    var state: State = .loading {
        didSet {
            switch state {
            case .noData:
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.moreSpinner.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.noDataView.text = "Data not available :("
                    self.noDataView.isHidden = false
                    self.tableView.isHidden = true
                    self.footerView.isHidden = true
                }
            case .loaded:
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.moreSpinner.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.tableView.isHidden = false
                    self.footerView.isHidden = true
                }
            case .loading:
                DispatchQueue.main.async {
                    if self.page > 1 {
                        self.moreSpinner.startAnimating()
                    } else {
                        self.spinner.startAnimating()
                    }
                    self.footerView.isHidden = true
                    self.noDataView.isHidden = true
                }
            case .noMoreData:
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.moreSpinner.stopAnimating()
                    self.moreSpinner.isHidden = true
                    self.footerView.isHidden = false
                }
            case .noInternet:
                let data = DataManager.shared.retrieveData()
                if data != nil {
                    let cellViewData = data ?? [NewsCellModel]()
                    updateTableView(data: cellViewData, count: cellViewData.count)
                } else {
                    DispatchQueue.main.async {
                        self.noDataView.text = "Data not available :("
                        self.noDataView.isHidden = false
                        self.tableView.isHidden = true
                        self.footerView.isHidden = true
                    }
                }
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.moreSpinner.stopAnimating()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tView = UITableView()
        tView.delegate = self
        tView.dataSource = self
        tView.clipsToBounds = true
        tView.layer.masksToBounds = true
        tView.register(TopNewsTableViewCell.self, forCellReuseIdentifier: cellId)
        tView.backgroundColor = .clear
        tView.separatorStyle = .none
        tView.layer.cornerRadius = 10
        tView.allowsSelection = true
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.rowHeight = UITableView.automaticDimension
        tView.separatorInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        return tView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        return refresh
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "search"
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private lazy var dropDownButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 7
        button.setTitle(category.rawValue, for: UIControl.State())
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
        button.addTarget(self, action: #selector(handleDropDownButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var noDataView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var footerView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Powered by newsapi.org"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    init(cellViewData: [NewsCellModel], pageType: PageType, title: String) {
        self.cellViewData = cellViewData
        self.pageType = pageType
        self.navigationTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupNavBar()
        setupView(pageType: self.pageType)
        
    }
    
    func setupView(pageType: PageType) {
        switch pageType {
        case .display:
            setupTableView()
        case .top:
            setupCategory()
            fetchNews(category: category, page: page, pageSize: 10, search: nil)
        case .search:
            setupSearch()
            applyCombineSearch()
        }
    }
    
    func setupNavBar() {
        view.backgroundColor = .white
        navigationItem.title = self.navigationTitle
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundView = spinner
        tableView.anchorWithConstants(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                      bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                                      topConstant: 16, leftConstant: 16, bottomConstant: 4, rightConstant: 16)
    }
    
    func setupIndicators() {
        view.addSubview(moreSpinner)
        view.addSubview(noDataView)
        view.addSubview(footerView)
        view.addSubview(dropDownButton)
        moreSpinner.translatesAutoresizingMaskIntoConstraints = false
        moreSpinner.anchorWithConstants(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                        right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 16,
                                        rightConstant: 0)
        moreSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dropDownButton.anchorWithConstants(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                           bottom: nil, right: nil, topConstant: 16, leftConstant: 16,
                                           bottomConstant: 0, rightConstant: 0)
        noDataView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noDataView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        footerView.anchorWithConstants(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                       right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 16,
                                       rightConstant: 0)
        footerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupSearch() {
        setupIndicators()
        view.addSubview(tableView)
        view.addSubview(searchBar)
        searchBar.anchorWithConstants(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                      bottom: nil, right: view.rightAnchor, topConstant: 16,
                                      leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        tableView.anchorWithConstants(top: searchBar.bottomAnchor, left: view.leftAnchor,
                                      bottom: moreSpinner.topAnchor, right: view.rightAnchor,
                                      topConstant: 16, leftConstant: 16, bottomConstant: 4, rightConstant: 16)
        tableView.backgroundView = spinner
    }
    
    func setupCategory() {
        setupIndicators()
        view.addSubview(tableView)
        tableView.anchorWithConstants(top: dropDownButton.bottomAnchor, left: view.leftAnchor,
                                      bottom: moreSpinner.topAnchor, right: view.rightAnchor,
                                      topConstant: 16, leftConstant: 16, bottomConstant: 4, rightConstant: 16)
        tableView.backgroundView = spinner
        tableView.addSubview(refreshControl)
        setupDropDown()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        fetchNews(category: category, page: page, pageSize: pageSize, search: nil)
    }
    
    func setupDropDown() {
        dropDown.anchorView = dropDownButton
        let dataSource = Category.allCases.map({ (ele: Category) -> String in
            return ele.rawValue
        })
        dropDown.dataSource = dataSource
        dropDown.selectionAction = { [unowned self] (_: Int, item: String) in
            dropDownButton.setTitle(item, for: UIControl.State())
            dropDown.hide()
            category = Category(rawValue: item) ?? Category.general
            AppData.category = category.rawValue
            fetchNews(category: category, page: page, pageSize: pageSize, search: nil)
        }
    }
    
    @objc private func handleDropDownButton() {
        dropDown.show()
    }
    
    func fetchNews(category: Category?, page: Int, pageSize: Int, search: String?) {
        state = State.loading
        viewModel.apiToGetNewsData(category: category?.rawValue, page: page, pageSize: pageSize, search: search)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offY > abs(contentHeight - scrollView.frame.height) &&
            state.self != .loading &&
            state.self != .noMoreData &&
            pageType.self != .display &&
            state.self != .noInternet {
            state = State.loading
            self.page += 1
            fetchNews(category: category, page: page, pageSize: pageSize, search: searchedText)
        }
    }
    
    func updateTableView(data: [NewsCellModel], count: Int) {
        var indexPaths = [IndexPath]()
        if count < 1 {
            state = State.noMoreData
            return
        }
        for index in 0...count - 1 {
            let indexPath = IndexPath(row: (self.page - 1) * self.pageSize + index, section: 0)
            indexPaths.append(indexPath)
        }
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.cellViewData = data
            self.tableView.insertRows(at: indexPaths, with: .bottom)
            self.tableView.endUpdates()
        }
        state = State.loaded
    }
    
    func applyCombineSearch() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification,
                                                                object: searchBar.searchTextField)
        publisher
            .map {
                ($0.object as! UISearchTextField).text
            }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue: { (value) in
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    guard let self = self else { return }
                    self.fetchNews(category: self.category, page: self.page, pageSize: self.pageSize, search: value)
                    self.searchedText = value ?? ""
                }
            })
            .store(in: &cancellable)
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TopNewsTableViewCell
        cell.cellViewModel = cellViewData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: cellViewData[indexPath.row].url) else {
            return
        }
        if pageType.self != .display {
            let dataDict: [AnyHashable: Any] = [
                "content": cellViewData[indexPath.row]
            ]
            NotificationCenter.default.post(name: Notification.Name("com.user.view.article"),
                                            object: nil, userInfo: dataDict)
        }
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellViewData.count
    }
}

extension NewsViewController: DataModelDelegate {
    func didRecieveError() {
        if Reachability.isConnectedToNetwork() {
            state = State.noData
        } else {
            state = State.noInternet
        }
    }
    
    func didRecieveDataUpdate(data: [NewsCellModel], count: Int ) {
        updateTableView(data: data, count: count)
        DataManager.shared.createData(data: data)
    }
}
