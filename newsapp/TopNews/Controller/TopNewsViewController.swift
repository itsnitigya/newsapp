//
//  TopNewsViewController.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 13/04/22.
//

import UIKit
import Alamofire
import DropDown

class TopNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var articles : ArticleResponse?
    let dropDown = DropDown()
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    var page: Int = 0
    var category: String = "general"
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.clipsToBounds = true
        tv.layer.masksToBounds = true
        tv.register(TopNewsTableCell.self, forCellReuseIdentifier: "cellId")
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.layer.cornerRadius = 10
        tv.allowsSelection = true
        tv.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = .white
        navigationItem.title = "Top Headlines"
        view.addSubview(tableView)
        view.addSubview(dropDownButton)
        dropDownButton.anchorWithConstants(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0)
        tableView.anchorWithConstants(top: dropDownButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        setupDropDown()
        fetchNews(category: category, page: page, pageSize: 10)
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
        spinner.startAnimating()
        tableView.backgroundView = spinner
        let url = "https://newsapi.org/v2/top-headlines?country=us&category=\(category)&apiKey=\(apiKey)&page=\(page)&pageSize=\(pageSize)"
        let request = AF.request(url)
        request.responseDecodable(of: ArticleResponse.self) { (response) in
            guard let news = response.value else { return }
            print(news.totalResults)
            if(self.articles == nil) {
                self.articles = news
            } else {
                self.articles?.articles.append(contentsOf: news.articles)
            }
            self.tableView.reloadData()
            self.spinner.stopAnimating()
          }
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TopNewsTableCell
        cell.headingLabel.text = articles?.articles[indexPath.item].title
        cell.authorLabel.text = articles?.articles[indexPath.item].source.name
        cell.contentLabel.text = articles?.articles[indexPath.item].content
        guard let url = self.articles?.articles[indexPath.item].urlToImage else {
            return cell
        }
        let URL = URL(string: url)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL!) //make sure your image in this url does exist, otherwise unwrap in a if let check /
            DispatchQueue.main.async {
                cell.image.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if(indexPath.item >= 9) {
//            page = page + 1
//            fetchNews(category: category, page: page, pageSize: 10)
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        guard let url = self.articles?.articles[indexPath.item].url else {
            return
        }
        if let URL = URL(string: url) {
            UIApplication.shared.open(URL)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
