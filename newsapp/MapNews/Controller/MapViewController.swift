//
//  File.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 14/04/22.
//

import UIKit
import GoogleMaps
import Alamofire
import GooglePlaces

class MapsViewController : UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 5.5))
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    var articles : ArticleResponse?
    
    lazy var newsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 240, height: 120)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(MapNewsCell.self, forCellWithReuseIdentifier: "cellId")
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.map = mapView
      
        view.backgroundColor = .white
        navigationItem.title = "News By Map"
        view.addSubview(mapView)
        mapView.anchorWithConstants(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        view.addSubview(newsCollectionView)
//        view.bringSubviewToFront(newsCollectionView)
        newsCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        newsCollectionView.anchorWithConstants(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 60, rightConstant: 24)
        fetchNews(page: 0, pageSize: 10)
    }
    
    func fetchNews(page: Int, pageSize: Int) {
        spinner.startAnimating()
        newsCollectionView.backgroundView = spinner
        let url = "https://newsapi.org/v2/everything?q=sydney&apiKey=\(apiKey)"
        let request = AF.request(url)
        request.responseDecodable(of: ArticleResponse.self) { (response) in
            print(response)
            guard let news = response.value else { return }
            print(news.totalResults)
            if(self.articles == nil) {
                self.articles = news
            } else {
                self.articles?.articles.append(contentsOf: news.articles)
            }
            print(news)
            self.newsCollectionView.reloadData()
            self.spinner.stopAnimating()
          }
      }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MapNewsCell
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 120)
    }
     
}
