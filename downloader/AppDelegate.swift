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
            items[0].image = UIImage(named: "folder.fill")
            items[1].image = UIImage(named: "download.fill")
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
        DownloadItemPersistenceManager.sharedInstance().loadAllDownloadItemDTO()
        DownloadManager.sharedInstance().allDownloadItems = DownloadItemPersistenceManager.sharedInstance().getAllDownloadItems()
    }
    

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        DownloadManager.sharedInstance().pauseAllDownload()
        let downloadItems = DownloadManager.sharedInstance().allDownloadItems
        DownloadItemPersistenceManager.sharedInstance().saveAllDownloadItems(downloadItems as! [DownloadItem])
    }
}

