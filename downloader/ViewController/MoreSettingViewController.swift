//
//  MoreSettingViewController.swift
//  downloader
//
//  Created by LAP14812 on 19/07/2022.
//

import UIKit

class MoreSettingViewController: UIViewController {
    //MARK: - CONFIG UI
    lazy var titleName: UILabel = {
        let titleName = UILabel()
        titleName.translatesAutoresizingMaskIntoConstraints = false
        titleName.text = "More"
        titleName.textAlignment = .center
        titleName.textColor = .black
        titleName.font = UIFont.boldSystemFont(ofSize: Dimen.screenTitleTextSize)
        return titleName
    }()
    
    lazy var topBarContrainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(titleName)
        titleName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleName.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 15).isActive = true
        titleName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        titleName.heightAnchor.constraint(equalToConstant: Dimen.getFontHeight(font: titleName.font)).isActive = true
        
        return view
    }()
    
    lazy var appIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "appicon")
        return imageView
    }()
    
    lazy var version: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Version 1.0"
        lable.textColor = UIColor.systemBlue
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: Dimen.screenAdditionalInformationTextSize)
        return lable
    }()
    

    
    
    lazy var passCodeCell: MoreSettingActionItem = {
        let item = MoreSettingActionItem()
        item.setContent(content: "Passcode Lock")
        item.setHasTrailingIcon(true)
        item.setLeadingImage(leading: UIImage(named: "password"))
        return item
    }()
    
    lazy var notificationCell: MoreSettingActionItem = {
        let item = MoreSettingActionItem()
        item.setContent(content: "Notification")
        item.setHasTrailingIcon(true)
        item.setLeadingImage(leading: UIImage(named: "notification"))
        return item
    }()
    
    
    //MARK: - CONFIG UI CONSTRAINT
    
    private func configTopBarConstraint(){
        topBarContrainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topBarContrainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topBarContrainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topBarContrainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    private func configAppIconViewConstraint(){
        appIconView.topAnchor.constraint(equalTo: topBarContrainer.bottomAnchor, constant: Dimen.screenDefaultMargin.top).isActive = true
        appIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appIconView.widthAnchor.constraint(equalToConstant: Dimen.appIconSize.width).isActive = true
        appIconView.heightAnchor.constraint(equalToConstant: Dimen.appIconSize.height).isActive = true
    }
    
    private func configAppVersionConstraint(){
        version.topAnchor.constraint(equalTo: appIconView.bottomAnchor, constant: Dimen.screenDefaultMargin.top).isActive = true
        version.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        version.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        version.heightAnchor.constraint(equalToConstant: Dimen.getFontHeight(font: version.font)).isActive = true
    }
    
    
    
    
    
    //MARK: - CONTROLLER SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.05)
        view.addSubview(topBarContrainer)
        configTopBarConstraint()
        
        view.addSubview(appIconView)
        configAppIconViewConstraint()
        
        view.addSubview(version)
        configAppVersionConstraint()
        
        view.addSubview(passCodeCell)
        passCodeCell.configAutoConstraint(parent: view, top: version)
        
        view.addSubview(notificationCell)
        notificationCell.configAutoConstraint(parent: view, top: passCodeCell)
        // Do any additional setup after loading the view.
    }
}
