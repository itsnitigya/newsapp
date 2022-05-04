//
//  Cache.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 30/04/22.
//

import Foundation

@propertyWrapper
struct Storage<T> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct AppData {
    @Storage(key: "category", defaultValue: "general")
    static var category: String
    
    @Storage(key: "viewed", defaultValue: false)
    static var viewed: Bool
}
