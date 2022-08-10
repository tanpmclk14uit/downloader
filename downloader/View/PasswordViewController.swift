//
//  PasswordViewController.swift
//  downloader
//
//  Created by LAP14812 on 29/07/2022.
//

import UIKit

class PasswordViewController: UIViewController {

    private lazy var topBarContainer: TopBarContainer = {
        let topBar = TopBarContainer()
        topBar.titleName.font = UIFont.systemFont(ofSize: DimenResource.screenNormalTextSize)
        return topBar
    }()
    
    private lazy var passwordKeyBoard: PasswordKeyBoard = {
        let keyBoard = PasswordKeyBoard(frame: view.frame)
        return keyBoard
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(topBarContainer)
        view.backgroundColor = .white
        
        topBarContainer.configAutoLayoutConstraint(parent: view)
        topBarContainer.enableBackButton { [weak self] in
            self?.dismiss(animated: true)
        }
        topBarContainer.setTitleName(name: title ?? "")
        
        view.addSubview(passwordKeyBoard)
        passwordKeyBoard.configAutoConstraint(parent: view)
    }
}
