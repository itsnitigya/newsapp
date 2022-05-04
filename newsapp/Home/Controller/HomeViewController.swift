//
//  ViewController.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 12/04/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var viewedArticles = false
    private var data = [HomeSettings.searchNews, HomeSettings.locationNews,
                        HomeSettings.topNews, HomeSettings.viewedNews]
    private var cellViewData = [NewsCellModel]()
    
    private lazy var tableView: UITableView = {
        let tView = UITableView()
        tView.delegate = self
        tView.dataSource = self
        tView.clipsToBounds = true
        tView.layer.masksToBounds = true
        tView.register(HomeViewTableCell.self, forCellReuseIdentifier: "cellId")
        tView.backgroundColor = .clear
        tView.separatorStyle = .none
        tView.layer.cornerRadius = 10
        tView.allowsSelection = false
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.rowHeight = UITableView.automaticDimension
        tView.separatorInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        return tView
    }()
    
    lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(viewArticles),
                                               name: NSNotification.Name("com.user.view.article"),
                                               object: nil)
    }
    
    @objc func viewArticles(_ notification: Notification) {
        if viewedArticles == false {
            let indexSet = IndexSet(integer: 3)
            DispatchQueue.main.async {
                self.tableView.performBatchUpdates({
                    self.tableView.insertSections(indexSet, with: .none)
                })
            }
        }
        let cellViewModel = notification.userInfo?["content"] as! NewsCellModel
        cellViewData.append(cellViewModel)
        viewedArticles = true
    }
    
    func setupTableView() {
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: tableView.frame.width,
                                              height: 35))
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: tableView.frame.width,
                                              height: 35))
        headerView.addSubview(headingLabel)
        headingLabel.text = String(localized: "home_screen_title")
        footerView.addSubview(bottomLabel)
        bottomLabel.text = "Made with ❤️"
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
    }
    
    func setupViews() {
        view.addSubview(tableView)
        tableView.anchorWithConstants(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                      bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                                      topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
           view.backgroundColor =  .white
             
           let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 20))
           lbl.font = UIFont.systemFont(ofSize: 20)
           lbl.text = data[section].heading
           view.addSubview(lbl)
           return view
         }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! HomeViewTableCell
        let row = indexPath.section
        cell.label.setTitle(data[row].label, for: .normal)
        cell.searchBar.isHidden = data[row].searchBarHidden
        cell.label.tag = row
        cell.label.addTarget(self, action: #selector(subscribeTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func subscribeTapped(_ sender: UIButton) {
        var viewController = data[sender.tag].router as! UIViewController
        if sender.tag == 3 {
            viewController = NewsViewController(cellViewData: cellViewData,
                                                pageType: .display, title: "Viewed Headlines")
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewedArticles ? 4 : 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
