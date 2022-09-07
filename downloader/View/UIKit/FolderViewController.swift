//
//  ViewController.swift
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

import UIKit
import AVKit
import AVFoundation
import WebKit
import QuickLook
import UniformTypeIdentifiers
import SwiftUI

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
    
    lazy var emptyMessage: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = .gray
        lable.numberOfLines = 2
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: DimenResource.screenNormalTextSize)
        return lable
    }()
    
    lazy var titleName: UILabel = {
        let titleName = UILabel()
        titleName.text = "Folders"
        titleName.textColor = .black
        titleName.font = UIFont.boldSystemFont(ofSize: DimenResource.screenTitleTextSize)
        return titleName
    }()
    
    lazy var buttonImportFile: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onImportFileClick), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonAddFolder: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "add-folder"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(showCreateFolderAlert), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonSort: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Date", for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(onSortClick), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonFilter: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("All file", for: .normal)
        button.setImage(UIImage(named: "filtered"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(onFilterClick), for: .touchUpInside)
        return button
    }()
    
    lazy var qlPreviewController: QLPreviewController = {
        let qlPreviewController = QLPreviewController()
        qlPreviewController.dataSource = self
        qlPreviewController.tabBarItem.badgeColor = .black
        qlPreviewController.delegate = self
        qlPreviewController.modalPresentationStyle = .fullScreen
        
        return qlPreviewController
    }()
    
    lazy var buttonViewType: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "row"), for: .normal)
        button.addTarget(self, action: #selector(onViewTypeClick), for: .touchUpInside)
        return button
    }()
    
    lazy var toolBar: UIView = {
        let toolBar = UIView()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.addSubview(buttonFilter)
        toolBar.addSubview(buttonImportFile)
        toolBar.addSubview(buttonAddFolder)
        toolBar.addSubview(buttonSort)
        toolBar.addSubview(buttonViewType)
        
        // config button add file
        buttonImportFile.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor).isActive = true
        buttonImportFile.leadingAnchor.constraint(equalTo: toolBar.leadingAnchor).isActive = true
        buttonImportFile.heightAnchor.constraint(equalTo: toolBar.heightAnchor).isActive = true
        buttonImportFile.widthAnchor.constraint(equalToConstant: DimenResource.buttonIconWidth+20).isActive = true
        // config button add forder
        buttonAddFolder.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor).isActive = true
        buttonAddFolder.leadingAnchor.constraint(equalTo: buttonImportFile.trailingAnchor).isActive = true
        buttonAddFolder.widthAnchor.constraint(equalToConstant: DimenResource.buttonIconWidth+20).isActive = true
        buttonAddFolder.heightAnchor.constraint(equalTo: toolBar.heightAnchor).isActive = true
        // config button filter
        buttonFilter.topAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        buttonFilter.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true
        buttonFilter.trailingAnchor.constraint(equalTo: toolBar.trailingAnchor, constant: DimenResource.toolBarMargin.right).isActive = true
        // config button sort
        buttonSort.topAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        buttonSort.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true
        buttonSort.trailingAnchor.constraint(equalTo: buttonFilter.leadingAnchor, constant: DimenResource.toolBarMargin.right).isActive = true
        // config button type view
        buttonViewType.heightAnchor.constraint(equalTo: toolBar.heightAnchor).isActive = true
        buttonViewType.widthAnchor.constraint(equalToConstant: DimenResource.buttonIconWidth+20).isActive = true
        buttonViewType.trailingAnchor.constraint(equalTo: buttonSort.leadingAnchor).isActive = true
        buttonViewType.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor).isActive = true
        
        return toolBar
    }()
    
    lazy var listLayout: MaintainOffsetFlowLayout = {
        let layout = MaintainOffsetFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize.width = view.frame.width-20
        layout.itemSize.height = 60
        return layout
    }()
    
    lazy var gridLayout: MaintainOffsetFlowLayout = {
        let layout = MaintainOffsetFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize.width = view.frame.width/2 - 15
        let height = max(layout.itemSize.width*1.2, 230)
        layout.itemSize.height = height
        return layout
    }()
    
    lazy var pinterestLayout: PinterestLayout = {
        let layout = PinterestLayout()
        layout.scrollDirection = .vertical
        layout.caculator = caculatorForLayout
        return layout
    }()
    
    lazy var caculatorForLayout: PinterestViewLayoutCaculator = {
        let caculator = PinterestViewLayoutCaculator(itemCount: currentFileMatchSearchSortAndFiler.count, collectionViewWidth: fileCollectionView.frame.width)
        caculator.delegate = self
        return caculator
    }()
    
    lazy var fileCollectionView: UICollectionView = {
        let fileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        fileCollectionView.translatesAutoresizingMaskIntoConstraints = false
        fileCollectionView.dataSource = self
        fileCollectionView.layer.backgroundColor = ColorResource.white?.cgColor
        fileCollectionView.delegate = self
        fileCollectionView.register(FileItemViewCellByList.self, forCellWithReuseIdentifier: FileItemViewCellByList.identifier)
        
        let longGestureForCollectionViewItem = UILongPressGestureRecognizer(target: self, action: #selector(onCollectionViewItemLongClick))
        fileCollectionView.addGestureRecognizer(longGestureForCollectionViewItem)
        return fileCollectionView
    }()
    
    
    lazy var sortBySelectionAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "Sort", message: "Select property to sort", preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "Sort by date", style: .default, handler: { [weak self] _ in
            self?.onSortChange(newSortBy: SortBy.Date)
        }))
        alert.addAction(UIAlertAction(title: "Sort by name", style: .default, handler: { [weak self] _ in
            self?.onSortChange(newSortBy: SortBy.Name)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alert
    }()
    
    lazy var filterBySelectionAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "Filter", message: "Select state to filter", preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "All", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByFileType.All)
        }))
        alert.addAction(UIAlertAction(title: "PDF", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByFileType.PDF)
        }))
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByFileType.Image)
        }))
        alert.addAction(UIAlertAction(title: "Text", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByFileType.Text)
        }))
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByFileType.Video)
        }))
        alert.addAction(UIAlertAction(title: "Audio", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByFileType.Audio)
        }))
        alert.addAction(UIAlertAction(title: "Zip", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByFileType.Zip)
        }))
        alert.addAction(UIAlertAction(title: "Unknown", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByFileType.Unknown)
        }))
        alert.addAction(UIAlertAction(title: "Directory", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByFileType.Directory)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alert
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.widthAnchor.constraint(equalToConstant: DimenResource.normalButtonWidth).isActive = true
        backButton.contentHorizontalAlignment = .left
        backButton.titleLabel?.lineBreakMode = .byTruncatingTail
        return backButton
    }()
    
    lazy var pasteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Paste", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: DimenResource.screenNormalTextSize)
        return button
    }()
    lazy var guideMessage: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textAlignment = .center
        lable.textColor = UIColor.systemBlue
        lable.backgroundColor = .white
        lable.text = "Move to: ..."
        lable.font = UIFont.systemFont(ofSize: DimenResource.screenAdditionalInformationTextSize)
        return lable
    }()
    
    lazy var guideLayout: UIView = {
        let container = UIView();
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        
        container.addSubview(guideMessage)
        guideMessage.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.7).isActive = true
        guideMessage.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        guideMessage.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        guideMessage.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        
        container.isHidden = true
        return container
    }()
    
    
    
    lazy var totalFolderItem: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textAlignment = .left
        lable.text = "Total: 12 item(s)"
        lable.textColor = .gray
        lable.font = UIFont.systemFont(ofSize: DimenResource.screenAdditionalInformationTextSize)
        
        return lable;
    }()
    
    
    //MARK: - CONFIG UI CONSTRAINT
    private func configSearchBarConstraint(){
        if #available(iOS 11.0, *) {
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimenResource.screenDefaultMargin.left).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: DimenResource.screenDefaultMargin.right).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func configToolbarConstraint(){
        toolBar.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        if #available(iOS 11.0, *){
            toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: DimenResource.screenDefaultMargin.left).isActive = true
            toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: DimenResource.screenDefaultMargin.right).isActive = true
        }else{
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimenResource.screenDefaultMargin.left).isActive = true
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: DimenResource.screenDefaultMargin.right).isActive = true
        }
        toolBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func configFileCollectionViewConstraint(){
        fileCollectionView.topAnchor.constraint(equalTo: totalFolderItem.bottomAnchor, constant: DimenResource.screenDefaultMargin.top).isActive = true
        fileCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: DimenResource.screenDefaultMargin.bottom).isActive = true
        if #available(iOS 11.0, *){
            fileCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: DimenResource.cellItemMargin.left).isActive = true
            fileCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: DimenResource.screenDefaultMargin.right).isActive = true
        }else{
            fileCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimenResource.cellItemMargin.left).isActive = true
            fileCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: DimenResource.screenDefaultMargin.right).isActive = true
        }
    }
    
    private func configTextGuideConstraint(){
        if #available(iOS 11.0, *) {
            guideLayout.topAnchor.constraint(equalTo: toolBar.safeAreaLayoutGuide.bottomAnchor).isActive = true
            guideLayout.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        } else {
            guideLayout.topAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true
            guideLayout.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        guideLayout.heightAnchor.constraint(equalToConstant: DimenResource.getFontHeight(font: guideMessage.font)).isActive = true
        guideLayout.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
    }
    
    private func configTotalFolderItemLableConstraint(){
        if #available(iOS 11.0, *) {
            totalFolderItem.topAnchor.constraint(equalTo: toolBar.safeAreaLayoutGuide.bottomAnchor).isActive = true
            totalFolderItem.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: DimenResource.screenDefaultMargin.left + 10).isActive = true
            totalFolderItem.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: DimenResource.screenDefaultMargin.right - 10).isActive = true
            
        } else {
            totalFolderItem.topAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: DimenResource.screenDefaultMargin.left + 10).isActive = true
            totalFolderItem.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimenResource.screenDefaultMargin.left - 10).isActive = true
            totalFolderItem.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
        totalFolderItem.heightAnchor.constraint(equalToConstant: DimenResource.getFontHeight(font: totalFolderItem.font)).isActive = true
    }
    
    private func configEmptyMessageConstraint(){
        emptyMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    // MARK: - CONTROLLER SETUP
    private let fileManager: DownloadFileManager = DownloadFileManager.sharedInstance()
    
    private var searchKey: String = ""
    private var viewBy: LayoutType = LayoutType.List
    private var sortBy: SortBy = SortBy.Date
    private var sortDiv: SortDIV = SortDIV.Asc
    private var filterBy: FilterByFileType = FilterByFileType.All
    
    var currentFolder: FolderItem?
    private var currentFileMatchSearchSortAndFiler: [FileItem] = []
    
    private var currentSelectedIndexPath: IndexPath?
  
    // variable for move file (source file) to folder (destinationFolder)
    private var sourceFile: FileItem?
    private var destinationFolder: FolderItem?

    private var lastVisibleItem: Int = 0
    private var lastContentOffset: CGFloat = 0
    private var isMoveSuccess = false
    private var transition: PopAnimator = PopAnimator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContentView()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(fileManager.shouldClearSearchSortAndFilterDataOfFolder() && currentFolder!.isRootFolder){
            fileCollectionView.setContentOffset(CGPoint(x: 0,y: 0), animated: false)
            searchKey = ""
            searchBar.text = nil
            sortDiv = SortDIV.Asc
            setIconOfSortButton()
            onViewSortChange(newSortBy: SortBy.Date)
            onViewFilerChange(newFilter: FilterByFileType.All)
            buttonViewType.setImage(UIImage(named: "row"), for: .normal)
            viewBy = LayoutType.List
            caculatorForLayout.clearCache(itemCount: self.fileManager.getTotalItem(of: currentFolder!.url))
            fileManager.refreshSuccess()
        }
        fetchAllFileOfFolder()
        setHeader()
    }
    
    private func setContentView(){
        view.backgroundColor = .white
        
        // add search view
        view.addSubview(searchBar)
        configSearchBarConstraint()
        
        view.addSubview(toolBar)
        configToolbarConstraint()
        
        view.addSubview(totalFolderItem)
        configTotalFolderItemLableConstraint()
        
        view.addSubview(guideLayout)
        configTextGuideConstraint()
        
        view.addSubview(fileCollectionView)
        configFileCollectionViewConstraint()
        
        setIconOfSortButton()
        
        view.addSubview(emptyMessage)
        configEmptyMessageConstraint()
    }
    
    private func fetchAllFileOfFolder(){
        DispatchQueue.global(qos: .utility).async { [weak self] in
            if let self = self{
                if let currentFolder = self.currentFolder {
                    self.fileManager.fetchAllFile(ofFolder: currentFolder, withAfterCompleteHandler: {
                        self.getAllFileMatchSearchSortAndFilter()
                        if let currentSelectedFilePath = self.currentSelectedIndexPath, self.isMoveSuccess{
                            self.caculatorForLayout.reloadLayoutFromIndex(currentSelectedFilePath.item, itemCount: self.currentFileMatchSearchSortAndFiler.count)
                            self.isMoveSuccess = false
                        }
                        DispatchQueue.main.async {
                            self.onViewByChange(newLayoutState: self.viewBy, withAnimation: false)
                        }
                    })
                }
            }
        }
    }
    
    private func setHeader(){
        // add title view
        titleName.text = currentFolder!.name
        navigationItem.titleView = titleName
        
        
        if(currentFolder!.isRootFolder){
            navigationItem.leftBarButtonItem = nil
        }else{
            setBackButton()
        }
        setPasteButton()
    }
    
    private func setPasteButton(){
        if(fileManager.shouldShowPaste()){
            pasteButton.addTarget(self, action: #selector(onPasteToCurrentFolder), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pasteButton)
        }else{
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func setTotalItemsLable(){
        if(searchKey.isEmpty){
            if(filterBy == FilterByFileType.All){
                self.totalFolderItem.text = "Total: \(currentFileMatchSearchSortAndFiler.count) item(s)"
            }else{
                self.totalFolderItem.text = "Filter result: \(currentFileMatchSearchSortAndFiler.count) item(s)"
            }
        }else{
            self.totalFolderItem.text = "Search result: \(currentFileMatchSearchSortAndFiler.count) item(s)"
        }
    }
    
    private func setBackButton(){
        backButton.setTitle(currentFolder!.directParentName, for: .normal)
        
        backButton.addTarget(self, action: #selector(onBackButtonClick), for: .touchUpInside)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onBackButtonLongClick))
        
        backButton.addGestureRecognizer(longPressGesture)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setEmptyListMessage(){
        if(currentFileMatchSearchSortAndFiler.isEmpty){
            if(filterBy == FilterByFileType.All){
                emptyMessage.text = "Your folder is empty!"
            }else{
                emptyMessage.text = "Filter result is empty\nplease choose other type!"
            }
        }else{
            emptyMessage.text = nil
        }
    }
    
    
    private func setIconOfSortButton(){
        if(sortDiv == SortDIV.Asc){
            buttonSort.setImage(UIImage(named: "sort-asc"), for: .normal)
        }else{
            buttonSort.setImage(UIImage(named: "sort-desc"), for: .normal)
        }
    }

    private func getAllFileMatchSearchSortAndFilter(){
        // get all original list
        var fileItems = currentFolder!.getFileItems()
        // filter
        if(filterBy != FilterByFileType.All){
            if(filterBy == FilterByFileType.Directory){
                fileItems = fileItems.filter({ fileItem in
                    return fileItem.isDir
                })
            }else{
                fileItems = fileItems.filter({ fileItem in
                    return fileItem.type.name == String(describing: filterBy).lowercased() && !fileItem.isDir
                })
            }
        }
        // search
        if(!searchKey.isEmpty){
            fileItems = fileItems.filter({ downloadItem in
                return downloadItem.name.lowercased().contains(searchKey.lowercased())
            })
        }
        // sort
        switch(sortBy){
        case SortBy.Name: do{
            fileItems.sort { hls, fls in
                compareObjectToSort(sortDiv: sortDiv, ObjFirst: hls.name.lowercased(), ObjSecond: fls.name.lowercased())
            }
            break
        }
        case SortBy.Date: do{
            let sortTime: SortDIV = (sortDiv == SortDIV.Asc) ? SortDIV.Desc : SortDIV.Asc
            fileItems.sort { hls, fls in
                if(hls.createdDate == fls.createdDate){
                    return compareObjectToSort(sortDiv: sortDiv, ObjFirst: hls.name.lowercased(), ObjSecond: fls.name.lowercased())
                }
                return compareObjectToSort(sortDiv: sortTime, ObjFirst: hls.createdDate, ObjSecond: fls.createdDate)
            }
            break
        }
        }
        currentFileMatchSearchSortAndFiler = fileItems
    }
    
    private func compareObjectToSort<T: Comparable>(sortDiv: SortDIV, ObjFirst: T, ObjSecond: T)-> Bool{
        if(sortDiv == SortDIV.Asc){
            return ObjFirst < ObjSecond
        }else{
            return ObjFirst > ObjSecond
        }
    }
    
    
    @objc private func onCollectionViewItemLongClick(sender: UILongPressGestureRecognizer){
        if(filterBy == FilterByFileType.All || filterBy == FilterByFileType.Directory){
            onFileIemDragAndDrop(sender: sender)
        }else{
            if(filterBy == FilterByFileType.Image && viewBy == LayoutType.Pinterest){
                if(sender.state == .began){
                    guard let targetIndexPath = fileCollectionView.indexPathForItem(at: sender.location(in: fileCollectionView)) else{
                        return
                    }
                    currentSelectedIndexPath = targetIndexPath
                    let fileItem = currentFileMatchSearchSortAndFiler[currentSelectedIndexPath!.item]
                    showMenuActionOfFileItem(fileItem)
                }
            }
        }
    }
    
    
    private func onFileIemDragAndDrop(sender: UILongPressGestureRecognizer){
        switch sender.state{
        case .began:
            guard let targetIndexPath = fileCollectionView.indexPathForItem(at: sender.location(in: fileCollectionView)) else{
                return
            }
            guideLayout.isHidden = false
            sourceFile = currentFileMatchSearchSortAndFiler[targetIndexPath.item]
            fileCollectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            fileCollectionView.updateInteractiveMovementTargetPosition(sender.location(in: fileCollectionView))
            guard let currentIndexPath = fileCollectionView.indexPathForItem(at: sender.location(in: fileCollectionView)) else{
                return
            }
            let currentFileItem = currentFileMatchSearchSortAndFiler[currentIndexPath.item]
            if(currentFileItem.isDir){
                guideMessage.text = "Move to: \(currentFileItem.name) folder"
                destinationFolder = currentFileItem as? FolderItem
            }else{
                guideMessage.text = "Move to: ..."
                destinationFolder = nil
            }
        case .ended:
            guideLayout.isHidden = true
            if(sourceFile != nil && destinationFolder != nil)
            {
                fileCollectionView.endInteractiveMovement()
            }
            fileCollectionView.cancelInteractiveMovement()
        default:
            fileCollectionView.cancelInteractiveMovement()
        }
    }
    
    @objc private func onBackButtonClick(){
        fileManager.removeTempFolder(fromFolder: currentFolder!)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onBackButtonLongClick(sender: UILongPressGestureRecognizer){
        if(sender.state == UIGestureRecognizer.State.began){
            
            let contextMenuVC = CustomContextMenuViewController()
            contextMenuVC.modalPresentationStyle = .overCurrentContext
            contextMenuVC.contents = currentFolder!.getNamesOfParentFolder()
            contextMenuVC.delegate = self
            
            present(contextMenuVC, animated: false)
        }
    }
    
    
    private func onViewByChange(newLayoutState: LayoutType, withAnimation animation: Bool = true){
        let newLayout: MaintainOffsetFlowLayout
        switch(newLayoutState){
        case LayoutType.List:
            buttonViewType.setImage(UIImage(named: "row"), for: .normal)
            fileCollectionView.register(FileItemViewCellByList.self, forCellWithReuseIdentifier: FileItemViewCellByList.identifier)
            
            newLayout = listLayout
        case LayoutType.Pinterest:
            buttonViewType.setImage(UIImage(named: "grid"), for: .normal)
            fileCollectionView.register(PinterestViewCell.self, forCellWithReuseIdentifier: PinterestViewCell.identifier)
            
            newLayout = pinterestLayout
        case LayoutType.Grid:
            buttonViewType.setImage(UIImage(named: "grid"), for: .normal)
            fileCollectionView.register(FileItemViewCellByIcon.self, forCellWithReuseIdentifier: FileItemViewCellByIcon.identifier)
            
            newLayout = gridLayout
        }
       
        newLayout.invalidateLayout()
        if (animation){
            let transitionManager = TransitionManager(duration: 0.3, collectionView: self.fileCollectionView, destinationLayout: newLayout)
            
            transitionManager.startInteractiveTransition()
        }else{
            self.fileCollectionView.collectionViewLayout = newLayout

        }
        viewBy = newLayoutState
        reloadCollectionView()
    }
    
    private func onViewSortChange(newSortBy: SortBy){
        sortBy = newSortBy
        buttonSort.setTitle("\(newSortBy)", for: .normal)
    }
    
    private func onSortChange(newSortBy: SortBy){
        if(sortBy == newSortBy){
            sortDiv.reverse()
            setIconOfSortButton()
        }else{
            onViewSortChange(newSortBy: newSortBy)
        }
        
        fileCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        clearCache()
        if(filterBy == FilterByFileType.Image){
            guideLayout.isHidden = false
            guideMessage.text = "Sorting..."
            fileCollectionView.isHidden = true
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                if let self = self{
                    let range = self.caculatorForLayout.range
                    self.getAllFileMatchSearchSortAndFilter()
                    self.caculatorForLayout.caculateAtributeForItem(from: 0, to: range/4)
                    self.caculatorForLayout.hightestIndex = range/4 + 1
                    DispatchQueue.main.async {
                        self.reloadCollectionView()
                        self.guideLayout.isHidden = true
                        self.guideMessage.text = "Move to: ..."
                        self.fileCollectionView.isHidden = false
                    }
                }
            }
        }else{
            getAllFileMatchSearchSortAndFilter()
            reloadCollectionView()
        }
    }
    
    private func onViewFilerChange(newFilter: FilterByFileType){
        buttonFilter.setTitle("\(newFilter)", for: .normal)
        filterBy = newFilter
    }
    
    private func onFilterChange(newFilter: FilterByFileType){
        if(newFilter != filterBy){
            onViewFilerChange(newFilter: newFilter)
            fileCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            getAllFileMatchSearchSortAndFilter()
            if(newFilter == FilterByFileType.Image){
                if(caculatorForLayout.getCacheCount()==0){
                    guideLayout.isHidden = false
                    guideMessage.text = "Filtering..."
                    fileCollectionView.isHidden = true
                    DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                        if let self = self{
                            self.caculatorForLayout.caculateAtributeForItem(from: 0, to: self.caculatorForLayout.range/4)
                            self.caculatorForLayout.hightestIndex = self.caculatorForLayout.range/4+1;
                            DispatchQueue.main.async {
                                if(self.viewBy == LayoutType.Grid){
                                    self.gridLayout.invalidateLayout()
                                    self.viewBy = LayoutType.Pinterest
                                }
                                self.guideLayout.isHidden = true
                                self.guideMessage.text = "Move to: ..."
                                self.fileCollectionView.isHidden = false
                                self.onViewByChange(newLayoutState: self.viewBy)
                            }
                        }
                       
                    }
                }else{
                    if(viewBy == LayoutType.Grid){
                        gridLayout.invalidateLayout()
                        viewBy = LayoutType.Pinterest
                    }
                    onViewByChange(newLayoutState: viewBy)
                }
            }else{
                if(viewBy == LayoutType.Pinterest){
                    pinterestLayout.invalidateLayout()
                    viewBy = LayoutType.Grid
                }
                onViewByChange(newLayoutState: viewBy, withAnimation: false)
            }
            
        }
    }
    
    
    
    @objc func onSortClick(){
        present(sortBySelectionAlert, animated: true)
    }
    
    @objc func onFilterClick(){
        present(filterBySelectionAlert, animated: true)
    }
    
    @objc func onViewTypeClick(){
        if(viewBy == LayoutType.List){
            if(filterBy == FilterByFileType.Image){
                viewBy = LayoutType.Pinterest
            }else{
                viewBy = LayoutType.Grid
            }
        }else{
            viewBy = LayoutType.List
        }
        onViewByChange(newLayoutState: viewBy)
    }
    
    @objc func onImportFileClick(){
        let pickerVC: UIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            let fileSupported = [UTType.audio, UTType.video, UTType.text, UTType.pdf, UTType.image, UTType.archive]
            pickerVC = UIDocumentPickerViewController(forOpeningContentTypes: fileSupported, asCopy: true)
            pickerVC.allowsMultipleSelection = true
        } else {
            let fileSupported = ["public.image", "public.archive", "public.audio", "public.video", "public.text", "public.pdf"]
            pickerVC = UIDocumentPickerViewController(documentTypes: fileSupported, in: UIDocumentPickerMode.import)
        }
        
        pickerVC.delegate = self
        present(pickerVC, animated: true)
    }
    
    private func onRenameFileClick(fileItem: FileItem){
        showInputNewFileNameOfFile(fileItem)
    }

    
    private func onMoveFileClick(fileItem: FileItem){
        let moveFileVC = MoveFileViewController()
        moveFileVC.modalPresentationStyle = .fullScreen
        moveFileVC.currentFolder = FolderItem.rootFolder()
        moveFileVC.sourceFile = fileItem
        moveFileVC.delegate = self
        
        let navigationControllder = UINavigationController(rootViewController: moveFileVC)
        navigationControllder.modalPresentationStyle = .fullScreen
        
        present(navigationControllder, animated: true)
    }
    
    private func onCopyFileClick(fileItem: FileItem){
        fileManager.copyFile(fileItem)
        setPasteButton()
    }
    
    private func onPasteFileClick(fileItem: FileItem){
        if(fileManager.pasteCopiedFile(to: fileItem as! FolderItem)){
            present(UIAlertController.notificationAlert(type: NotificationAlertType.Success, message: "Paste success"), animated: true)
            fileItem.size = fileManager.getTotalItem(of: fileItem.url) as NSNumber
            reloadCollectionViewItem(of: fileItem)
        }else{
            present(UIAlertController.notificationAlert(type: NotificationAlertType.Error, message: "Paste fail"), animated: true)
            setPasteButton()
        }
    }
    
    @objc private func onPasteToCurrentFolder(){
        if(fileManager.pasteCopiedFile(to: self.currentFolder!)){
            present(UIAlertController.notificationAlert(type: NotificationAlertType.Success, message: "Paste success"), animated: true)
            if(filterBy == FilterByFileType.Image){
                DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                    if let self = self{
                        self.fileManager.fetchAllFile(ofFolder: self.currentFolder!) {
                            if let currentSelectedFilePath = self.currentSelectedIndexPath, !currentSelectedFilePath.isEmpty {
                                var index = currentSelectedFilePath.item
                                if(self.sortDiv == SortDIV.Asc){
                                    index -= 1
                                }else{
                                    index += 1
                                }
                                self.getAllFileMatchSearchSortAndFilter()
                                self.caculatorForLayout.reloadLayoutFromIndex(index, itemCount: self.currentFileMatchSearchSortAndFiler.count)
                            }
                        }
                        DispatchQueue.main.async {
                            self.reloadCollectionView()
                        }
                    }
                }
            }else{
                fetchAllFileOfFolder()
            }
        }else{
            present(UIAlertController.notificationAlert(type: NotificationAlertType.Error, message: "Paste fail"), animated: true)
            setPasteButton()
        }
    }

    private func onDecompressFileClick(fileItem: FileItem){
        
    }
    
    private func onDetailFileClick(fileItem: FileItem){
        if(fileItem.isDir){
            let folderVC = FolderViewController()
            let folderItem = fileItem as! FolderItem
            folderVC.currentFolder = folderItem
            
            navigationController?.pushViewController(folderVC, animated: true)
        }else{
            if(fileItem.type.name == FileTypeConstants.unknown().name){
                showErrorNotification(message: "This file type is not supported!")
            }else{
                if(fileItem.type.name == FileTypeConstants.image().name){
                    let previewItems = currentFileMatchSearchSortAndFiler.map({ fileItem in
                        return fileItem.url as CustomPreviewItem
                    })
                    
                
                    if #available(iOS 13.0, *) {
                        let uiCustomPreview = UICustomPreview {
                            self.dismiss(animated: true)
                        }


                        if let currentSelectedIndexPath = currentSelectedIndexPath {
                            uiCustomPreview.setPreviewItems(previewItems, currentIndex: currentSelectedIndexPath.item)
                        }

                        let imageVC = UIHostringControllerWithZoomTransition(rootView: uiCustomPreview)
                
                        imageVC.modalPresentationStyle = .overFullScreen
                        imageVC.view.backgroundColor = .clear
                        imageVC.delegate = self

                        present(imageVC, animated: true)
                    } else {
                        // Fallback on earlier versions
                        let imageVC = CustomPreviewController()
                        imageVC.modalPresentationStyle = .overFullScreen
                        imageVC.delegate = self
                        imageVC.previewItems = previewItems

                        if let currentSelectedIndexPath = currentSelectedIndexPath {
                            imageVC.currentPreviewItemPosition = currentSelectedIndexPath.item
                        }

                        present(imageVC, animated: true)
                    }
                    
                }else{
                    qlPreviewController.reloadData()

                    present(qlPreviewController, animated: true)
                }
            }
        }
    }
    
    private func onDeleteFileClick(fileItem: FileItem){
        showDeleteConfirmAlert(fileItem: fileItem)
    }
    
    private func showMenuActionOfFileItem(_ fileItem: FileItem){
        let alert = UIAlertController(
            title: "\(fileItem.name)", message: nil, preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [weak self] _ in
            self?.onRenameFileClick(fileItem: fileItem)
        }))
        alert.addAction(UIAlertAction(title: "Move", style: .default, handler: { [weak self] _ in
            self?.onMoveFileClick(fileItem: fileItem)
        }))
        alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { [weak self] _ in
            self?.onCopyFileClick(fileItem: fileItem)
        }))
        if(fileItem.isDir && fileManager.shouldShowPaste()){
            alert.addAction(UIAlertAction(title: "Paste", style: .default, handler: { [weak self] _ in
                self?.onPasteFileClick(fileItem: fileItem)
            }))
        }
        if(fileItem.type.name == FileTypeConstants.zip().name){
            alert.addAction(UIAlertAction(title: "Decompress", style: .default, handler: { [weak self] _ in
                self?.onDecompressFileClick(fileItem: fileItem)
            }))
        }
        alert.addAction(UIAlertAction(title: "Detail", style: .default, handler: { [weak self] _ in
            self?.onDetailFileClick(fileItem: fileItem)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.onDeleteFileClick(fileItem: fileItem)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func showCreateFolderAlert(){
        let alert = UIAlertController(
            title: "Create folder", message: "Please enter folder name", preferredStyle: .alert
        )
        alert.addTextField{ field in
            field.placeholder = "example"
            field.returnKeyType = .done
            field.keyboardType = .default
        }
        // add action to alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertFieldCount = 1;
        let createAction = UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ in
            if let fields = alert.textFields, fields.count == alertFieldCount {
                if let self = self {
                    if let folderName = fields[0].text, !fields[0].text!.isEmpty {
                        if(self.fileManager.isExitsFolderName(folderName, inFolder: self.currentFolder!.url)){
                            self.showErrorNotification(message: "Folder name is exist!")
                        }else{
                            if(self.fileManager.createNewFolder(folderName, inFolder: self.currentFolder!)){
                                self.fetchAllFileOfFolder()
                            }else{
                                self.showErrorNotification(message: "Create folder fail!")
                            }
                        }
                    }else{
                        self.showErrorNotification(message: "Folder name can not place empty!")
                    }
                }
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        alert.preferredAction = createAction
        
        present(alert, animated: true)
    }
    
    private func showErrorNotification(message: String){
        let emptyURLNotification = UIAlertController.notificationAlert(type: NotificationAlertType.Error, message: message)
        present(emptyURLNotification, animated: true)
    }
    
    private func showDeleteConfirmAlert(fileItem: FileItem){
        let alert = UIAlertController(
            title: "Delete",
            message: "Ensure to delete this file?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            if let self = self{
                if(self.fileManager.removeFile(fileItem, fromFolder: self.currentFolder!)){
                    if let currentSelectedFilePath = self.currentSelectedIndexPath, !currentSelectedFilePath.isEmpty {
                        self.getAllFileMatchSearchSortAndFilter()
                        if(self.filterBy == FilterByFileType.Image){
                            self.caculatorForLayout.reloadLayoutFromIndex(currentSelectedFilePath.item, itemCount: self.currentFileMatchSearchSortAndFiler.count)
                        }
                        CacheThumbnailImage.shareInstance().removeFromCache(url: fileItem.url)
                        self.reloadCollectionView()
                        self.setPasteButton();
                        self.present(UIAlertController.notificationAlert(type: NotificationAlertType.Success, message: "Delete file success!"), animated: true)
                    }
                }else{
                    self.showErrorNotification(message: "Can not delete this file!")
                }
            }
        }))
        present(alert, animated: true)
    }
    
    private func showInputNewFileNameOfFile(_ fileItem: FileItem){
        let alert = UIAlertController(
            title: "Rename file",
            message: nil,
            preferredStyle: .alert
        )
        let fileNameWithoutExtension = URL(fileURLWithPath: fileItem.name).deletingPathExtension().lastPathComponent
        alert.addTextField{ field in
            field.placeholder = "example"
            field.text = (fileNameWithoutExtension)
            field.returnKeyType = .done
            field.keyboardType = .default
        }
        // add action to alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertFieldCount = 1;
        let renameAction = UIAlertAction(title: "Rename", style: .default, handler: { [weak self] _ in
            if let fields = alert.textFields, fields.count == alertFieldCount {
                if let self = self {
                    if let newName = fields[0].text, !fields[0].text!.isEmpty {
                        if(self.fileManager.isExitsFileName(newName, inFolder: fileItem.url)){
                            self.showErrorNotification(message: "File name is exist!")
                        }else{
                            if(self.fileManager.renameFile(fileItem, toNewName: newName)){
                                self.reloadCollectionViewItem(of: fileItem)
                            }else{
                                self.showErrorNotification(message: "Rename fail!")
                            }
                        }
                    }else{
                        self.showErrorNotification(message: "File name can not place empty!")
                    }
                }
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(renameAction)
        alert.preferredAction = renameAction
        present(alert, animated: true)
    }
}
//MARK: - CONFIRM UI SEARCH BAR DELEGATE
extension FolderViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchKey = searchText
        fileCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        getAllFileMatchSearchSortAndFilter()
        clearCache()
        if(filterBy == FilterByFileType.Image){
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                if let self = self{
                    self.caculatorForLayout.caculateAtributeForItem(from: 0, to: self.caculatorForLayout.range/4)
                    self.caculatorForLayout.hightestIndex = self.caculatorForLayout.range/4 + 1
                    DispatchQueue.main.async {
                        self.reloadCollectionView()
                    }
                }
            }
        }else{
            reloadCollectionView()
        }
    }
}
//MARK: - CONFIRM UI COLLECTION VIEW DELEGAE, DATASOURCE
extension FolderViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentFileMatchSearchSortAndFiler.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch(viewBy){
        case LayoutType.List:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileItemViewCellByList.identifier, for: indexPath) as! FileItemViewCellByList
            cell.setCellData(fileItem: currentFileMatchSearchSortAndFiler[indexPath.row])
            cell.delegate = self
            return cell
        case LayoutType.Grid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileItemViewCellByIcon.identifier, for: indexPath) as! FileItemViewCellByIcon
            cell.setCellData(fileItem: currentFileMatchSearchSortAndFiler[indexPath.row])
            cell.delegate = self
            return cell
        case LayoutType.Pinterest:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinterestViewCell.identifier, for: indexPath) as! PinterestViewCell
            cell.setCellData(fileItem: currentFileMatchSearchSortAndFiler[indexPath.row])
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = UICollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return customTransitionLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectedIndexPath = indexPath
        let currentSelectedItem = currentFileMatchSearchSortAndFiler[indexPath.item]
        onDetailFileClick(fileItem: currentSelectedItem)
    }
    
    func reloadCollectionViewItem(of fileItem: FileItem){
        if let itemPosition = currentFileMatchSearchSortAndFiler.firstIndex(of: fileItem){
            let indexPath = IndexPath(item: itemPosition, section: 0)
            self.fileCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let sourceFile = sourceFile,
           let destinationFolder = destinationFolder
        {
            fileManager.moveFile(sourceFile, toFolder: destinationFolder)
            CacheThumbnailImage.shareInstance().removeFromCache(url: sourceFile.url)
            fetchAllFileOfFolder()
        }
    }
    
    func clearCache(){
        caculatorForLayout.clearCache(itemCount: currentFileMatchSearchSortAndFiler.count)
        lastVisibleItem = 0
        lastContentOffset = 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // check if user scroll down
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            if(filterBy == FilterByFileType.Image){
                let lastCell = fileCollectionView.visibleCells.last
                if let lastCell = lastCell{
                    let indexPath = fileCollectionView.indexPath(for: lastCell)
                    guard let indexPath = indexPath, !indexPath.isEmpty, lastVisibleItem != indexPath.item else {
                        return
                    }
                    lastVisibleItem = indexPath.item
                    let highestCaculatedIndex = caculatorForLayout.hightestIndex
                    let range = caculatorForLayout.range
                    if(highestCaculatedIndex < indexPath.item + range){
                        DispatchQueue.global(qos: .userInitiated).async{[weak self] in
                            if let self = self{
                                self.caculatorForLayout.caculateAtributeForItem(from: highestCaculatedIndex, to: indexPath.item + range)
                            }
                            
                        }
                        caculatorForLayout.hightestIndex = min(indexPath.item + range + 1, currentFileMatchSearchSortAndFiler.count)
                    }
                }
            }
        }
        lastContentOffset = scrollView.contentOffset.y
    }
    
    
    func reloadCollectionView(){
        fileCollectionView.reloadData()
        setEmptyListMessage()
        setTotalItemsLable()
    }
}

// MARK: - CONFIRM FileCellDelegate
extension FolderViewController: FileCellDelegate{
    func menuActionClick(fileItem: FileItem) {
        let position = currentFileMatchSearchSortAndFiler.firstIndex(of: fileItem)
        if let index = position{
            let indexPath = IndexPath(item: index, section: 0)
            currentSelectedIndexPath = indexPath
        }
        showMenuActionOfFileItem(fileItem)
    }
}

//MARK: - COMFRIM QLPreviewDataSource, QLPreviewDelegate
extension FolderViewController: QLPreviewControllerDataSource, QLPreviewControllerDelegate{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        if let path = currentSelectedIndexPath{
            return currentFileMatchSearchSortAndFiler[path.item].url as QLPreviewItem
        }
        
        return currentFileMatchSearchSortAndFiler[index].url as QLPreviewItem
    }
    
    func previewController(_ controller: QLPreviewController, transitionViewFor item: QLPreviewItem) -> UIView? {
        if let indexPath = currentSelectedIndexPath{
            switch(viewBy){
            case LayoutType.List:
                let cell = self.fileCollectionView.cellForItem(at: indexPath) as! FileItemViewCellByList
                return cell.fileIcon
            case LayoutType.Grid:
                let cell = self.fileCollectionView.cellForItem(at: indexPath) as! FileItemViewCellByIcon
                return cell.thumbnail
            case LayoutType.Pinterest:
                let cell = self.fileCollectionView.cellForItem(at: indexPath) as! PinterestViewCell
                return cell.thumbnail
            }
        }
        return nil
    }
    
    @available(iOS 13.0, *)
    func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
        .disabled
    }
    
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        if let indexPath = currentSelectedIndexPath, !indexPath.isEmpty{
            let currentItem = currentFileMatchSearchSortAndFiler[indexPath.item]
            CacheThumbnailImage.shareInstance().removeFromCache(url: currentItem.url)
            reloadCollectionViewItem(of: currentItem)
        }
    }
}

//MARK: - CONFIRM CustomContextMenuDelegate
extension FolderViewController: CustomContextMenuDelegate{
    func onItemClick(at position: Int) {
        if(position < navigationController?.viewControllers.count ?? 0){
            let targetController = (navigationController?.viewControllers[position])
            if let targetController = targetController{
                navigationController?.popToViewController(targetController, animated: true)
            }
        }
    }
}
// MARK: - CONFIRM UIDocumentPickerDelegate
extension FolderViewController: UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let alert = UIAlertController(title: nil, message: "Importing...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        for url in urls{
            if(fileManager.copyFile(at: url, toFolder: currentFolder!)){
                
            }else{
                present(UIAlertController.notificationAlert(type: NotificationAlertType.Error, message: "Import \(url.lastPathComponent) fail"), animated: true)
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            if let self = self{
                self.fileManager.fetchAllFile(ofFolder: self.currentFolder!) {
                    self.getAllFileMatchSearchSortAndFilter()
                    self.clearCache()
                    if(self.filterBy == FilterByFileType.Image){
                        self.caculatorForLayout.caculateAtributeForItem(from: 0, to: self.caculatorForLayout.range/4)
                        self.caculatorForLayout.hightestIndex = self.caculatorForLayout.range/4 + 1
                    }
                    DispatchQueue.main.async {
                        self.fileCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                        self.reloadCollectionView()
                        self.present(UIAlertController.notificationAlert(type: .Success, message: "Import file success"), animated: true)
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }
        
    }
}
//MARK: - CONFIRM PINTEREST DELEGATE
extension FolderViewController: PinterestLayoutCaculatorDelegate{
    
    func getHeightForImageAtIndexPath(indexPath: NSIndexPath, itemWidth: CGFloat) -> CGFloat {
        guard indexPath.item < currentFileMatchSearchSortAndFiler.count else {
            return itemWidth
        }
        let currentItem = currentFileMatchSearchSortAndFiler[indexPath.item]
        let actualImage = UIImage(contentsOfFile: currentItem.url.path)
        if let actualImage = actualImage{
            let itemHeight = itemWidth * actualImage.size.height / actualImage.size.width
            return itemHeight
        }else{
            return itemWidth
        }
    }
    
    func getNumberOfColumn() -> Int {
        return 2
    }
}
//MARK: - CONFIRM MOVEFILE DELEGATE
extension FolderViewController: MoveFileDelegate{
    func onMoveFileSuccess() {
        isMoveSuccess = true
    }
}

//MARK: - Confirm Custom Preview Controller Delegate, Data Source
extension FolderViewController: CustomPreviewControllerDelegate{
    
    func previewController(_ controller: UIViewController, transitionViewForItemAt position: Int) -> UIView? {
        let indexPath = IndexPath(item: position, section: 0)
        switch(viewBy){
        case LayoutType.Pinterest:
            let cell = self.fileCollectionView.cellForItem(at: indexPath) as? PinterestViewCell
            if let cell = cell{
                return cell.thumbnail
            }else{
                return nil
            }
        default:
            return nil
        }
    }
    
    func previewController(_ controller: UIViewController, defaultPlaceHolderForItemAt position: Int) -> UIImage? {
        
        let indexPath = IndexPath(item: position, section: 0)
        switch(viewBy){
        case LayoutType.Pinterest:
            let cell = self.fileCollectionView.cellForItem(at: indexPath) as? PinterestViewCell
            if let cell = cell{
                return cell.thumbnail.image
            }else{
                return nil
            }
        default:
            return nil
        }
    }
    
}
