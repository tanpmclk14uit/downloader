//
//  MoreSettingViewController.swift
//  downloader
//
//  Created by LAP14812 on 19/07/2022.
//

import UIKit

class MoreSettingViewController: UIViewController {
    //MARK: - CONFIG UI
    
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
        lable.font = UIFont.systemFont(ofSize: DimenResource.screenAdditionalInformationTextSize)
        return lable
    }()
    
    lazy var passCodeCell: MoreSettingActionItem = {
        let item = MoreSettingActionItem().buildAsActionButton()
        item.setContent(content: "Passcode Lock")
        item.setLeadingImage(leading: UIImage(named: "password"))
        return item
    }()
    
    lazy var notificationCell: MoreSettingActionItem = {
        let item = MoreSettingActionItem().buildAsActionButton()
        item.setContent(content: "Notification")
        item.setLeadingImage(leading: UIImage(named: "notification"))
        return item
    }()
    
    lazy var topBarContainer: TopBarContainer = {
        return TopBarContainer();
    }()
    
    
    //MARK: - CONFIG UI CONSTRAINT
    
    
    private func configAppIconViewConstraint(){
        appIconView.topAnchor.constraint(equalTo: topBarContainer.bottomAnchor, constant: DimenResource.screenDefaultMargin.top).isActive = true
        appIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appIconView.widthAnchor.constraint(equalToConstant: DimenResource.appIconSize.width).isActive = true
        appIconView.heightAnchor.constraint(equalToConstant: DimenResource.appIconSize.height).isActive = true
    }
    
    private func configAppVersionConstraint(){
        version.topAnchor.constraint(equalTo: appIconView.bottomAnchor, constant: DimenResource.screenDefaultMargin.top).isActive = true
        version.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        version.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        version.heightAnchor.constraint(equalToConstant: DimenResource.getFontHeight(font: version.font)).isActive = true
    }

    //MARK: - CONTROLLER SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorResource.backGroundColor
        view.addSubview(topBarContainer)
        topBarContainer.configAutoLayoutConstraint(parent: view)
        
        view.addSubview(appIconView)
        configAppIconViewConstraint()
        
        view.addSubview(version)
        configAppVersionConstraint()
        
        view.addSubview(passCodeCell)
        passCodeCell.configAutoConstraint(parent: view, top: version)
        passCodeCell.setOnClickListener { [weak self] in
            let passCodeVC = PassCodeLockViewController()
            passCodeVC.modalPresentationStyle = .fullScreen
            self?.present(passCodeVC, animated: true)
        }
        
        view.addSubview(notificationCell)
        notificationCell.configAutoConstraint(parent: view, top: passCodeCell)
    }
}
