//
//  AppLifeCycleOserverable.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/31.
//

import Foundation

@objc protocol AppLifeCycleOserverable {
    func receiveForegoundNotification()
    func receiveBackgroundNotification()
}

extension AppLifeCycleOserverable {
    func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveForegoundNotification), name: .sceneWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveBackgroundNotification), name: .sceneDidEnterBackground, object: nil)
    }
    
   func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}
