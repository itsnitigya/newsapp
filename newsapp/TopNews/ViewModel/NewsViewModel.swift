//
//  NewsDataViewModel.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 21/04/22.
//

import Alamofire

class NewsViewModel {
    weak var delegate: DataModelDelegate?
    let network = ServiceLayer()
    var newsCellModel = [NewsCellModel]()
    
    init() {
        network.delegate = self
    }
    
    func apiToGetNewsData(category: String?, page: Int, pageSize: Int, search: String?) {
        if category == "error" {
            delegate?.didRecieveError()
            return
        }
        var queryItems = [URLQueryItem(name: "country", value: "us"),
                          URLQueryItem(name: "page", value: String(page)),
                          URLQueryItem(name: "pageSize", value: String(pageSize)),
                          URLQueryItem(name: "apiKey", value: apiKey)]
        if search != nil {
            queryItems.append(URLQueryItem(name: "q", value: search))
        } else {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        let router = Router(routerSettings: .getNews, queryItems: queryItems)
        network.getData(router: router)
    }
    
    func createCellModel(newsData: [Article]) {
        var newsCellModel = [NewsCellModel]()
        for news in newsData {
            let url = news.url ?? ""
            let imageUrl = news.urlToImage ?? ""
            let heading = news.title
            let author = news.source.name
            let content = news.content
            newsCellModel.append(NewsCellModel(url: url, imageURL: imageUrl, heading: heading,
                                               author: author, content: content))
        }
        self.newsCellModel.append(contentsOf: newsCellModel)
    }
}

extension NewsViewModel: NetworkResponseDelegate {
    func parseResponse(data: ArticleResponse) {
        createCellModel(newsData: data.articles)
        self.delegate?.didRecieveDataUpdate(data: self.newsCellModel, count: data.articles.count)
    }
    
    func handleError() {
        delegate?.didRecieveError()
    }
}

protocol DataModelDelegate: AnyObject {
    func didRecieveDataUpdate(data: [NewsCellModel], count: Int)
    func didRecieveError()
}
