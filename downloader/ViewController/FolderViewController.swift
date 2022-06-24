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
        titleName.font = UIFont.boldSystemFont(ofSize: Dimen.screenTitleTextSize)
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
        button.setImage(UIImage(named: "add-folder"), for: .normal)
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
    
    lazy var buttonViewType: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "row"), for: .normal)
        return button
    }()
    
    lazy var toolBar: UIView = {
        let toolBar = UIView()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.addSubview(buttonAddFile)
        toolBar.addSubview(buttonAddFolder)
        toolBar.addSubview(buttonSort)
        toolBar.addSubview(buttonViewType)
        // config button add file
        buttonAddFile.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor).isActive = true
        buttonAddFile.leadingAnchor.constraint(equalTo: toolBar.leadingAnchor).isActive = true
        buttonAddFile.heightAnchor.constraint(equalToConstant: Dimen.buttonIconHeight).isActive = true
        buttonAddFile.widthAnchor.constraint(equalToConstant: Dimen.buttonIconWidth).isActive = true
        // config button add forder
        buttonAddFolder.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor).isActive = true
        buttonAddFolder.leadingAnchor.constraint(equalTo: buttonAddFile.trailingAnchor).isActive = true
        buttonAddFolder.widthAnchor.constraint(equalToConstant: Dimen.buttonIconWidth).isActive = true
        buttonAddFolder.heightAnchor.constraint(equalToConstant: Dimen.buttonIconHeight).isActive = true
        // config button sort
        buttonSort.topAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        buttonSort.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true
        buttonSort.trailingAnchor.constraint(equalTo: toolBar.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        // config button type view
        buttonViewType.heightAnchor.constraint(equalToConstant: Dimen.buttonIconHeight).isActive = true
        buttonViewType.widthAnchor.constraint(equalToConstant: Dimen.buttonIconWidth).isActive = true
        buttonViewType.trailingAnchor.constraint(equalTo: buttonSort.leadingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        buttonViewType.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor).isActive = true
        
        return toolBar
    }()
    
    lazy var fileCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize.width = view.frame.width-20
        layout.itemSize.height = 60
        let fileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        fileCollectionView.translatesAutoresizingMaskIntoConstraints = false
        fileCollectionView.collectionViewLayout = layout
        fileCollectionView.dataSource = self
        fileCollectionView.delegate = self
        fileCollectionView.register(FileItemViewCell.self, forCellWithReuseIdentifier: FileItemViewCell.identifier)
        return fileCollectionView
    }()
    
    lazy var sortBySelectionAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "Sort", message: "Select property to sort", preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "Sort by date", style: .default, handler: { _ in
            print("sort by date")
        }))
        alert.addAction(UIAlertAction(title: "Sort by name", style: .default, handler: { _ in
            print("sort by name")
        }))
        alert.addAction(UIAlertAction(title: "Sort by size", style: .default, handler: { _ in
            print("sort by size")
        }))
        alert.addAction(UIAlertAction(title: "Sort by type", style: .default, handler: { _ in
            print("sort by type")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alert
    }()
    
    lazy var viewBySelectionAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "View by", message: "", preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "View by list", style: .default, handler: { _ in
            print("View by list")
        }))
        alert.addAction(UIAlertAction(title: "View by icon", style: .default, handler: { _ in
            print("View by icon")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alert
    }()
    
    //MARK: - CONFIG UI CONSTRAINT
    private func configSearchBarConstraint(){
        if #available(iOS 11.0, *) {
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimen.screenDefaultMargin.left).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    private func configToolbarConstraint(){
        toolBar.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        if #available(iOS 11.0, *){
            toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Dimen.screenDefaultMargin.left).isActive = true
            toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        }else{
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimen.screenDefaultMargin.left).isActive = true
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        }
        toolBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    private func configFileCollectionViewConstraint(){
        fileCollectionView.topAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: Dimen.screenDefaultMargin.top).isActive = true
        fileCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Dimen.screenDefaultMargin.bottom).isActive = true
        if #available(iOS 11.0, *){
            fileCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Dimen.cellItemMargin.left).isActive = true
            fileCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        }else{
            fileCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimen.cellItemMargin.left).isActive = true
            fileCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        }
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
        view.addSubview(fileCollectionView)
        
        configSearchBarConstraint()
        configToolbarConstraint()
        configFileCollectionViewConstraint()
        
        buttonSort.addTarget(self, action: #selector(onSortClick), for: .touchUpInside)
        buttonViewType.addTarget(self, action: #selector(onViewTypeClick), for: .touchUpInside)
    }
    //MARK: - BUTTON EVENT
    @objc func onSortClick(){
        present(sortBySelectionAlert, animated: true)
    }
    
    @objc func onViewTypeClick(){
        present(viewBySelectionAlert, animated: true)
    }
}
//MARK: - CONFIRM UI SEARCH BAR DELEGATE
extension FolderViewController: UISearchBarDelegate{
    
}
//MARK: - CONFIRM UI COLLECTION VIEW DELEGAE, DATASOURCE
extension FolderViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileItemViewCell.identifier, for: indexPath)
        return cell
    }
    
    
}
