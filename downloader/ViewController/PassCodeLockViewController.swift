//
//  PassCodeLockViewController.swift
//  downloader
//
//  Created by LAP14812 on 20/07/2022.
//

import UIKit

class PassCodeLockViewController: UIViewController {
    
    private lazy var topBarContainer: TopBarContainer = {
        let topBar = TopBarContainer()
        topBar.setTitleName(name: "Passcode Lock")
        return topBar
    }()
    
    private lazy var passCodeEnable: MoreSettingActionItem = {
        let item = MoreSettingActionItem().buildAsSwitchButton()
        item.setLeadingImage(leading: nil)
        item.setContent(content: "Enable")
        return item
    }()
    
    private lazy var changePassCode: MoreSettingActionItem = {
        let item = MoreSettingActionItem().buildAsActionButton()
        item.setLeadingImage(leading: nil)
        item.setContent(content: "Change password")
        return item
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorResource.backGroundColor
        
        view.addSubview(topBarContainer)
        topBarContainer.configAutoLayoutConstraint(parent: view)
        topBarContainer.enableBackButton { [weak self] in
            self?.dismiss(animated: true)
        }
        
        view.addSubview(passCodeEnable)
        passCodeEnable.configAutoConstraint(parent: view, top: topBarContainer)
        
        view.addSubview(changePassCode)
        changePassCode.configAutoConstraint(parent: view, top: passCodeEnable)
        
    }

}
