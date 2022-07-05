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
        button.setImage(UIImage(named: "sort"), for: .normal)
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
        buttonAddFile.leadingAnchor.constraint(equalTo: toolBar.leadingAnchor, constant: Dimen.toolBarMargin.left).isActive = true
        buttonAddFile.heightAnchor.constraint(equalToConstant: Dimen.buttonIconHeight).isActive = true
        buttonAddFile.widthAnchor.constraint(equalToConstant: Dimen.buttonIconWidth).isActive = true
        // config button add forder
        buttonAddFolder.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor).isActive = true
        buttonAddFolder.leadingAnchor.constraint(equalTo: buttonAddFile.trailingAnchor, constant: Dimen.toolBarMargin.left).isActive = true
        buttonAddFolder.widthAnchor.constraint(equalToConstant: Dimen.buttonIconWidth).isActive = true
        buttonAddFolder.heightAnchor.constraint(equalToConstant: Dimen.buttonIconHeight).isActive = true
        // config button sort
        buttonSort.topAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        buttonSort.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true
        buttonSort.trailingAnchor.constraint(equalTo: toolBar.trailingAnchor, constant: Dimen.toolBarMargin.right).isActive = true
        // config button type view
        buttonViewType.heightAnchor.constraint(equalToConstant: Dimen.buttonIconHeight).isActive = true
        buttonViewType.widthAnchor.constraint(equalToConstant: Dimen.buttonIconWidth).isActive = true
        buttonViewType.trailingAnchor.constraint(equalTo: buttonSort.leadingAnchor, constant: Dimen.toolBarMargin.right).isActive = true
        buttonViewType.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor).isActive = true
        
        return toolBar
    }()
    
    lazy var listLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize.width = view.frame.width-20
        layout.itemSize.height = 60
        return layout
    }()
    
    lazy var gridLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize.width = view.frame.width/2 - 15
        layout.itemSize.height = layout.itemSize.width * 1.2
        return layout
    }()
    
    lazy var fileCollectionView: UICollectionView = {
        let fileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        fileCollectionView.translatesAutoresizingMaskIntoConstraints = false
        fileCollectionView.dataSource = self
        fileCollectionView.delegate = self
        fileCollectionView.register(FileItemViewCellByList.self, forCellWithReuseIdentifier: FileItemViewCellByList.identifier)
        return fileCollectionView
    }()
    
    lazy var sortBySelectionAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "Sort", message: "Select property to sort", preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "Sort by date", style: .default, handler: { [weak self] _ in
            self?.buttonSort.setTitle("Sort by Date", for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "Sort by name", style: .default, handler: { [weak self] _ in
            self?.buttonSort.setTitle("Sort by Name", for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "Sort by size", style: .default, handler: { [weak self] _ in
            self?.buttonSort.setTitle("Sort by Size", for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "Sort by type", style: .default, handler: { [weak self] _ in
            self?.buttonSort.setTitle("Sort by Type", for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alert
    }()
    
    lazy var viewBySelectionAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "View by", message: "", preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "View by list", style: .default, handler: { [weak self] _ in
            self?.onViewByChange(newLayoutState: LayoutState.List)
        }))
        alert.addAction(UIAlertAction(title: "View by icon", style: .default, handler: { [weak self] _ in

            self?.onViewByChange(newLayoutState: LayoutState.Grid)
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
    
    private var currentLayoutState: LayoutState = LayoutState.List
    private let fileManager: DownloadFileManager = DownloadFileManager.sharedInstance()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.fileManager.fetchAllFileOfDownloadFolder {
                DispatchQueue.main.async {
                    self?.fileCollectionView.reloadData()
                }
            }
        }
    }
    
    private func onViewByChange(newLayoutState: LayoutState){
        let transitionManager: TransitionManager
        if(newLayoutState != currentLayoutState){
            if(newLayoutState == LayoutState.List){
                buttonViewType.setImage(UIImage(named: "row"), for: .normal)
                fileCollectionView.register(FileItemViewCellByList.self, forCellWithReuseIdentifier: FileItemViewCellByList.identifier)
                transitionManager = TransitionManager(duration: 0.3, collectionView: self.fileCollectionView, destinationLayout: listLayout)
            }else{
                buttonViewType.setImage(UIImage(named: "grid"), for: .normal)
                fileCollectionView.register(FileItemViewCellByIcon.self, forCellWithReuseIdentifier: FileItemViewCellByIcon.identifier)
                transitionManager = TransitionManager(duration: 0.3, collectionView: self.fileCollectionView, destinationLayout: gridLayout)
            }
            currentLayoutState = newLayoutState
            transitionManager.startInteractiveTransition()
            fileCollectionView.reloadData()
        }
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
        return fileManager.getFileItems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(currentLayoutState == LayoutState.List){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileItemViewCellByList.identifier, for: indexPath) as! FileItemViewCellByList
            cell.setCellData(fileItem: fileManager.getFileItems()[indexPath.row])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileItemViewCellByIcon.identifier, for: indexPath) as! FileItemViewCellByIcon
            cell.setCellData(fileItem: fileManager.getFileItems()[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = UICollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
            return customTransitionLayout
    }
}
