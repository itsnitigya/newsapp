//
//  TopNewsData.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 13/04/22.
//

import Foundation

struct ArticleResponse: Codable {
    let status: String
    let totalResults: Int
    var articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String?
    let articleDescription: String?
    let url: String?
    let content: String?
    let urlToImage: String?

    enum CodingKeys: String, CodingKey {
        case source, title
        case articleDescription = "description"
        case url, content, urlToImage
    }
}

struct Source: Codable {
    let id: String?
    let name: String
}
