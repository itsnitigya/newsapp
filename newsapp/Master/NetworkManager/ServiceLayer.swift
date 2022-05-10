//
//  ServiceLayer.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 28/04/22.
//

import Alamofire

class ServiceLayer: NetworkRequestDelegate {
    weak var delegate: NetworkResponseDelegate?
    
    func getData(router: Router) {
        self.request(router: router)
    }
     
    func request(router: Router) {
        var components = URLComponents()
        components.scheme = router.routerSettings.scheme
        components.host = router.routerSettings.host
        components.path = router.routerSettings.path
        components.queryItems = router.queryItems
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.routerSettings.scheme
        let request = AF.request(url)
        request.responseDecodable(of: ArticleResponse.self) { [weak self] (response) in
            print(response)
            if response.error != nil && response.value == nil {
                self?.delegate?.handleError()
            } else {
                self?.delegate?.parseResponse(data: response.value!)
            }
        }
    }
}

protocol NetworkRequestDelegate: AnyObject {
    func getData(router: Router)
}

protocol NetworkResponseDelegate: AnyObject {
    func parseResponse(data: ArticleResponse)
    func handleError()
}
