//
//  Router.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 28/04/22.
//

import Foundation

struct Router {
    let routerSettings: RouterSettings
    let queryItems: [URLQueryItem]
}

enum RouterSettings {
    case getNews
    
    var scheme: String {
        switch self {
        case .getNews:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case .getNews:
            return "newsapi.org"
        }
    }
    
    var path: String {
        switch self {
        case .getNews:
            return "/v2/top-headlines"
        }
    }
    
    var method: String {
        switch self {
        case .getNews:
            return "GET"
        }
    }
}
