//
//  NewsDataViewModel.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 21/04/22.
//

import Foundation
import Alamofire

class NewsViewModel {
    
    var newsData : ArticleResponse?
    private var baseUrl = URL(string: "https://newsapi.org/v2/top-headlines?country=us")!
    
    var newsCellViewModel = [NewsCellViewModel]()

    func apiToGetNewsData(category: String, page: Int, pageSize: Int, completion : @escaping () -> ()) {
        baseUrl.appendQueryItem(name: "category", value: category)
        baseUrl.appendQueryItem(name: "page", value: String(page))
        baseUrl.appendQueryItem(name: "pageSize", value: String(pageSize))
        baseUrl.appendQueryItem(name: "apiKey", value: apiKey)
        let request = AF.request(baseUrl)
        request.responseDecodable(of: ArticleResponse.self) { [weak self] (response) in
            guard let self = self else { return }
            guard let news = response.value else { return }
            if(self.newsData == nil) {
                self.newsData = news
            } else {
                self.newsData?.articles.append(contentsOf: news.articles)
            }
            self.createCellModel(newsData: self.newsData!)
            completion()
          }
    }
    
    func createCellModel(newsData: ArticleResponse) {
        var newsCellViewModel = [NewsCellViewModel]()
        for news in newsData.articles {
            let url = news.url ?? ""
            let imageUrl = news.urlToImage ?? ""
            let heading = news.title
            let author = news.source.name
            let content = news.content
            newsCellViewModel.append(NewsCellViewModel(url: url, imageURL: imageUrl, heading: heading, author: author, content: content))
        }
        self.newsCellViewModel = newsCellViewModel
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> NewsCellViewModel {
           return newsCellViewModel[indexPath.row]
    }
}
