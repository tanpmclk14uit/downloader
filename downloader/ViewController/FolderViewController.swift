//
//  ViewController.swift
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

import UIKit

class FolderViewController: UIViewController {
    // MARK: - CONFIG UI
    lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search in current folder"
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
        return searchBar
    }()
    
    lazy var titleName: UILabel = {
        let titleName = UILabel()
        titleName.text = "Folders"
        titleName.textColor = .black
        titleName.font = UIFont.boldSystemFont(ofSize: 30)
        return titleName
    }()
    
    lazy var buttonAddFile: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var buttonAddFolder: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "folder-add"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    lazy var buttonSort: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sort by Date", for: .normal)
        button.setImage(UIImage(named: "expand"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .systemBlue
        return button
    }()
    
    lazy var toolBar: UIView = {
        let toolBar = UIView()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.addSubview(buttonAddFile)
        toolBar.addSubview(buttonAddFolder)
        toolBar.addSubview(buttonSort)
        // config button add file
        buttonAddFile.topAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        buttonAddFile.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true
        buttonAddFile.leadingAnchor.constraint(equalTo: toolBar.leadingAnchor).isActive = true
        buttonAddFile.widthAnchor.constraint(equalToConstant: 40).isActive = true
        // config button add forder
        buttonAddFolder.topAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        buttonAddFolder.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true
        buttonAddFolder.leadingAnchor.constraint(equalTo: buttonAddFile.trailingAnchor).isActive = true
        buttonAddFolder.widthAnchor.constraint(equalToConstant: 40).isActive = true
        // config button sort
        buttonSort.topAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
         buttonSort.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true
        buttonSort.trailingAnchor.constraint(equalTo: toolBar.trailingAnchor, constant: -10).isActive = true
        return toolBar
    }()
    
    //MARK: - CONFIG UI CONSTRAINT
    private func configSearchBarConstraint(){
        if #available(iOS 11.0, *) {
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    private func configToolbarConstraint(){
        toolBar.topAnchor.constraint(equalTo: searchBar.bottomAnchor,constant: 0).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    // MARK: - CONTROLLER SETUP
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // add title view
        navigationItem.titleView = titleName
        // add search view
        view.addSubview(searchBar)
        view.addSubview(toolBar)
        configSearchBarConstraint()
        configToolbarConstraint()
    }
    
}
//MARK: - CONFIRM UI SEARCH BAR DELEGATE
extension FolderViewController: UISearchBarDelegate{
    
}

