//
//  SceneDelegate.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/12.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        NetworkMonitor.shared.startMonitoring()
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        NetworkMonitor.shared.stopMonitoring()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        NotificationCenter.default.post(name: .sceneWillEnterForeground , object: nil)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        NotificationCenter.default.post(name: .sceneDidEnterBackground , object: nil)
    }
}

