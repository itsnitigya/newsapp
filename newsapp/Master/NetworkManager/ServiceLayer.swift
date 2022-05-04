//
//  ServiceLayer.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 28/04/22.
//

import Alamofire

class ServiceLayer {
    class func request<T: Codable>(router: Router, completion: @escaping (DataResponse<T, AFError>) -> Void) {
        var components = URLComponents()
        components.scheme = router.routerSettings.scheme
        components.host = router.routerSettings.host
        components.path = router.routerSettings.path
        components.queryItems = router.queryItems
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.routerSettings.scheme
        let request = AF.request(url)
        request.responseDecodable(of: T.self) {  (response) in
            completion(response)
        }
    }
}
