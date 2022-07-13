//
//  MoveFileViewController.swift
//  downloader
//
//  Created by LAP14812 on 13/07/2022.
//

import UIKit

class MoveFileViewController: UIViewController {

    //MARK: - CONFIG UI
    lazy var titleName: UILabel = {
        let titleName = UILabel()
        titleName.translatesAutoresizingMaskIntoConstraints = false
        titleName.text = "Downloads"
        titleName.textColor = .black
        titleName.textAlignment = .center
        titleName.font = UIFont.boldSystemFont(ofSize: Dimen.screenTitleTextSize)
        return titleName
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Dimen.screenNormalTextSize)
        button.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
        return button
    }()
    
    lazy var moveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Move", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Dimen.screenNormalTextSize)
        button.addTarget(self, action: #selector(onMoveClick), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonAddFolder: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New folder", for: .normal)
        button.sizeToFit()
        button.titleEdgeInsets.left = 10
        button.contentHorizontalAlignment = .left
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: Dimen.screenNormalTextSize)
        button.setImage(UIImage(named: "add-folder"), for: .normal)
        return button
    }()
    
    lazy var textGuide: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textAlignment = .center
        lable.text = "Pick destination folder"
        lable.textColor = .gray
        lable.font = UIFont.systemFont(ofSize: Dimen.screenAdditionalInformationTextSize)
        return lable
    }()
    
    //MARK: - CONFIG UI CONSTRAINT
    private func configTextGuideConstraint(){
        
        if #available(iOS 11.0, *) {
            textGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            textGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Dimen.screenDefaultMargin.left).isActive = true
            textGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        } else {
            textGuide.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            textGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimen.screenDefaultMargin.left).isActive = true
            textGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        }
        textGuide.heightAnchor.constraint(equalToConstant: Dimen.getFontHeight(font: titleName.font)).isActive = true
    }
    
    //MARK: - SET VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.titleView = titleName
        // set up tool bar
        navigationController?.isToolbarHidden = false
        toolbarItems = [UIBarButtonItem(customView: buttonAddFolder),UIBarButtonItem(customView: moveButton)]
        
        view.addSubview(textGuide)
        configTextGuideConstraint()
    }
    
    @objc private func onCancelClick(){
        self.dismiss(animated: true)
    }
    
    @objc private func onMoveClick(){
        print("move")
    }
    
}
