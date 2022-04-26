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
    var newsCellViewModel = [NewsCellViewModel]()

    func apiToGetNewsData(category: String, page: Int, pageSize: Int) {
        var baseUrl = URL(string: "https://newsapi.org/v2/top-headlines?country=us")!
        baseUrl.appendQueryItem(name: "category", value: category)
        baseUrl.appendQueryItem(name: "page", value: String(page))
        baseUrl.appendQueryItem(name: "pageSize", value: String(pageSize))
        baseUrl.appendQueryItem(name: "apiKey", value: apiKey)
        let request = AF.request(baseUrl)
        request.responseDecodable(of: ArticleResponse.self) { [weak self] (response) in
            guard let self = self else { return }
            guard let news = response.value else { return }
            self.createCellModel(newsData: news.articles)
            self.delegate?.didRecieveDataUpdate(data: self.newsCellViewModel, count: news.articles.count)
          }
    }
    
    func createCellModel(newsData: [Article]) {
        var newsCellViewModel = [NewsCellViewModel]()
        for news in newsData {
            let url = news.url ?? ""
            let imageUrl = news.urlToImage ?? ""
            let heading = news.title
            let author = news.source.name
            let content = news.content
            newsCellViewModel.append(NewsCellViewModel(url: url, imageURL: imageUrl, heading: heading, author: author, content: content))
        }
        self.newsCellViewModel.append(contentsOf: newsCellViewModel)
    }
}


protocol DataModelDelegate: AnyObject {
    func didRecieveDataUpdate(data: [NewsCellViewModel], count: Int)
}
