//
//  SceneDelegate.swift
//  iCloudExample
//
//  Created by Seokho on 2019/11/27.
//  Copyright © 2019 Seokho. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow()
        window.windowScene = scene
        self.window = window
        let mainViewController = UINavigationController(rootViewController: MainViewController())
        self.window?.rootViewController = mainViewController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}

