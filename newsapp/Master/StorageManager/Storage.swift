//
//  Storage.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 02/05/22.
//

import CoreData
import UIKit

class DataManager: NSObject {
    public static let shared = DataManager()
    private override init() {}
    
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    func createData(data: [NewsCellModel]) {
        let managedContext = getContext()!
        let entity = NSEntityDescription.entity(forEntityName: "News", in: managedContext)!
        data.forEach { ele in
            let news = NSManagedObject(entity: entity, insertInto: managedContext)
            news.setValue(ele.heading, forKey: "heading")
            news.setValue(ele.content, forKey: "content")
            news.setValue(ele.author, forKey: "author")
            news.setValue(ele.url, forKey: "url")
            news.setValue(ele.imageURL, forKey: "imageUrl")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
          print(error)
        }
    }
    
    func retrieveData() -> [NewsCellModel]? {
        let managedContext = getContext()!
        let fetchRequst = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
        do {
            let result = try managedContext.fetch(fetchRequst) as! [News]
            let data = result.map({ (ele: News) -> NewsCellModel in
                return NewsCellModel(url: ele.url ?? "", imageURL: ele.imageUrl ?? "",
                                     heading: ele.heading ?? "", author: ele.author ?? "", content: ele.content ?? "")
            })
            return data
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}
