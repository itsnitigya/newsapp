//
//  HomeSettings.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 30/04/22.
//

import Foundation

public enum HomeSettings {
    case searchNews
    case locationNews
    case topNews
    case viewedNews
    
    
    var label: String {
        switch self {
            case .searchNews:
                return "SEARCH"
            case .locationNews:
                return "VIEW MAP"
            case .topNews:
                return "VIEW TOP HEADLINES"
            case .viewedNews:
                return "VISITED HEADLINES"
        }
    }
    
    var heading: String {
        switch self {
            case .searchNews:
                return "Term Search"
            case .locationNews:
                return "News by Location"
            case .topNews:
                return "Top Headlines"
            case .viewedNews:
                return "Viewed News"
        }
    }
    
    var searchBarHidden: Bool {
        switch self {
            case .searchNews:
                return false
            case .locationNews:
                return true
            case .topNews:
                return true
            case .viewedNews:
                return true
        }
    }
    
    var router: Any {
        switch self {
            case .searchNews:
                return NewsViewController(cellViewData: [NewsCellModel](), pageType: .search, title: "Search Headlines")
            case .locationNews:
                return MapsViewController()
            case .topNews:
            return NewsViewController(cellViewData: [NewsCellModel](), pageType: .top, title: "Top Headlines")
            case .viewedNews:
            return NewsViewController(cellViewData: [NewsCellModel](), pageType: .display, title: "Viewed Headlines")
        }
    }
}
