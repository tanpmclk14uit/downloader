//
//  AppDelegate.swift
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        let navController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navController
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("become active")
    }

}

