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
        titleName.text = "More"
        titleName.textColor = .black
        titleName.font = UIFont.boldSystemFont(ofSize: Dimen.screenTitleTextSize)
        return titleName
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = titleName
        // Do any additional setup after loading the view.
    }
}
