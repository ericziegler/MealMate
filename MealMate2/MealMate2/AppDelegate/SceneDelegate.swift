//
//  SceneDelegate.swift
//  MealMate2
//
//  Created by Eric Ziegler on 8/30/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties
    
    var window: UIWindow?

    // MARK: - UIWindowSceneDelegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

}

