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
        let folderVC = FolderViewController()
        let currentFolder = FolderItem.rootFolder()
        folderVC.currentFolder = currentFolder
        let folderViewController = UINavigationController(rootViewController: folderVC)
        folderViewController.title = "Folders"
        
        return folderViewController
    }()
    
    let downloadViewController: UINavigationController = {
        let downloadViewController = UINavigationController(rootViewController: DownloadViewController())
        downloadViewController.title = "Downloads"
        DownloadManager.sharedInstance().fetchAllDownloadItemsWith {

        }
        return downloadViewController
    }()
    
    let moreSettingViewController: UINavigationController = {
        let moreSettingViewController = UINavigationController(rootViewController: MoreSettingViewController())
        moreSettingViewController.title = "More"
        
        return moreSettingViewController
    }()
    
    lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([folderViewController, downloadViewController, moreSettingViewController], animated: false)
        
        if let items = tabBarController.tabBar.items{
            items[0].image = UIImage(named: "folder.fill")
            items[1].image = UIImage(named: "download.fill")
            items[2].image = UIImage(named: "menu")
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

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        DownloadManager.sharedInstance().pauseAllCurrentlyDownloadingItem()
        while(DownloadManager.sharedInstance().pauseAllDownloadingProcessComplete() == false){}
        DownloadFileManager.sharedInstance().removeTempFolder(fromFolder: FolderItem.rootFolder())
    }
}

