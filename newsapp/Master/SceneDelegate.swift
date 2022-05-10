//
//  SceneDelegate.swift
//  newsapp
//
//  Created by Nitigya Kapoor on 12/04/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let orientationLock = UIInterfaceOrientationMask.portrait

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let view = UINavigationController(rootViewController: HomeViewController())
        window.rootViewController = view
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
}
