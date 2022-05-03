//
//  NewsDataViewModel.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 21/04/22.
//

import Foundation
import Alamofire

class NewsViewModel {
    
    weak var delegate: DataModelDelegate?
    var newsCellModel = [NewsCellModel]()
    
    func apiToGetNewsData(category: String?, page: Int, pageSize: Int, search: String?) {
        if(category == "error") {
            self.delegate?.didRecieveError()
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
        ServiceLayer.request(router: router) { [weak self] (result: DataResponse<ArticleResponse, AFError>) in
            guard let self = self else { return }
            if result.error != nil || result.value == nil {
                self.delegate?.didRecieveError()
                return
            }
            self.createCellModel(newsData: result.value!.articles)
            self.delegate?.didRecieveDataUpdate(data: self.newsCellModel, count: result.value!.articles.count)
        }
    }
    
    func createCellModel(newsData: [Article]) {
        var newsCellModel = [NewsCellModel]()
        for news in newsData {
            let url = news.url ?? ""
            let imageUrl = news.urlToImage ?? ""
            let heading = news.title
            let author = news.source.name
            let content = news.content
            newsCellModel.append(NewsCellModel(url: url, imageURL: imageUrl, heading: heading, author: author, content: content))
        }
        self.newsCellModel.append(contentsOf: newsCellModel)
    }
}


protocol DataModelDelegate: AnyObject {
    func didRecieveDataUpdate(data: [NewsCellModel], count: Int)
    func didRecieveError()
}
