//
//  CustomContextMenuViewController.swift
//  downloader
//
//  Created by LAP14812 on 14/07/2022.
//

import UIKit

//MARK: - CusomContextMenuDelegate
protocol CustomContextMenuDelegate{
    func onItemClick(at position: Int);
}
class CustomContextMenuViewController: UIViewController {
    //MARK: - CONFIG UI
    lazy var contextParentsFolderMenu: ContentSizedTableView = {
        let tableView = ContentSizedTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 10
        tableView.sizeToFit()
        tableView.register(ContextMenuCell.self, forCellReuseIdentifier: ContextMenuCell.identifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        return tableView
    }()
    
    lazy var transparentBackground: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor(white: 0.6, alpha: 0.1)
        
        return container
    }()
    
    //MARK: CONFIG UI CONSTRAINT
    private func configTransparentBackgroundConstraint(){
        transparentBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        transparentBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        transparentBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        transparentBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func configParentsFolderContextMenuConstraint(){
        if #available(iOS 11.0, *) {
            contextParentsFolderMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: DimenResource.screenDefaultMargin.top).isActive = true
            contextParentsFolderMenu.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        } else {
            contextParentsFolderMenu.topAnchor.constraint(equalTo: view.topAnchor , constant: DimenResource.screenDefaultMargin.top).isActive = true
            contextParentsFolderMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        }
        
        let halfViewFrameWidth = view.frame.width/2
        let width = (halfViewFrameWidth > DimenResource.menuMaxWidth) ? DimenResource.menuMaxWidth : halfViewFrameWidth
        contextParentsFolderMenu.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        let halfViewFrameHeight = view.frame.height/2
        let contentHeight = contextParentsFolderMenu.intrinsicContentSize.height
        if(contentHeight > halfViewFrameHeight){
            contextParentsFolderMenu.heightAnchor.constraint(equalToConstant: halfViewFrameHeight).isActive = true
        }
    }
    
    //MARK: - SET ViewController
    public var contents: [String]?
    public var delegate: CustomContextMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(transparentBackground)
        configTransparentBackgroundConstraint()
        view.addSubview(contextParentsFolderMenu)
        configParentsFolderContextMenuConstraint()
        //
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCancelContextMenu))
        transparentBackground.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onCancelContextMenu(){
        self.dismiss(animated: false)
    }
    
    
}
//MARK: - Confirm UITableViewDelegate and UITableViewDataSource

extension CustomContextMenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contents!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContextMenuCell.identifier) as! ContextMenuCell
        cell.setTitle(title: contents![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onItemClick(at: indexPath.row)
        self.dismiss(animated: false)
    }
}

