//
//  AddNewFolderAlert.swift
//  downloader
//
//  Created by LAP14812 on 14/07/2022.
//

import UIKit

extension UIAlertController{
    public class func notificationAlert(type: NotificationAlertType, message: String) -> UIAlertController{
        let alert = UIAlertController(title: "\(type)", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        return alert;
    }
}
