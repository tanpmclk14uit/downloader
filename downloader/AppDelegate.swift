//
//  AppDelegate.swift
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - View setup
    var window: UIWindow?
    
    let folderViewController: UINavigationController = {
        let folderViewController = UINavigationController(rootViewController: FolderViewController())
        folderViewController.title = "Folders"
        return folderViewController
    }()
    
    let downloadViewController: UINavigationController = {
        let downloadViewController = UINavigationController(rootViewController: DownloadViewController())
        downloadViewController.title = "Downloads"
        return downloadViewController
    }()
    
    lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([folderViewController, downloadViewController], animated: false)
        
        if let items = tabBarController.tabBar.items{
            // set up folder tab image
            items[0].image = UIImage(named: "folder.fill")?.withRenderingMode(.alwaysOriginal)
            items[0].selectedImage = UIImage(named: "folder.fill.selected")?.withRenderingMode(.alwaysOriginal)
            // set up download tab image
            items[1].image = UIImage(named: "download.fill")?.withRenderingMode(.alwaysOriginal)
            items[1].selectedImage = UIImage(named: "download.fill.selected")?.withRenderingMode(.alwaysOriginal)
        }
        tabBarController.tabBar.backgroundColor = .white
        return tabBarController
    }()
    
    // MARK: - application
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        window?.rootViewController = tabBarController
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("become active")
    }

}

