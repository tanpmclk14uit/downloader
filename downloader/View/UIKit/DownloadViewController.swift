//
//  DownloadViewController.swift
//  downloader
//
//  Created by LAP14812 on 22/06/2022.
//

import UIKit

class DownloadViewController: UIViewController {
    //MARK: - CONFIG UI
    lazy var titleName: UILabel = {
        let titleName = UILabel()
        titleName.text = StringResource.downloadTitle
        titleName.textColor = .black
        titleName.font = UIFont.boldSystemFont(ofSize: DimenResource.screenTitleTextSize)
        return titleName
    }()
    
    lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = StringResource.downloadSearchPlaceHolder
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
        return searchBar
    }()
    
    lazy var buttonSort: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(sortBy.toString(), for: .normal)
        button.setImage(UIImage(named: "sort-asc"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(onSortClick), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonFilter: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(filterBy.toString(), for: .normal)
        button.setImage(UIImage(named: "filtered"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(onFilterClick), for: .touchUpInside)
        return button
    }()
    
    lazy var downloadItemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = DimenResource.downloadItemsTableViewRowHeight
        tableView.register(DownloadItemViewCell.self, forCellReuseIdentifier: DownloadItemViewCell.identifier)
        return tableView
    }()
    
    lazy var emptyDownloadsMessage: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = .gray
        lable.numberOfLines = 2
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: DimenResource.screenNormalTextSize)
        return lable
    }()
    
    lazy var addNewDownloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemBlue
        button.setImage(UIImage(named: "add"), for: .normal)
        button.addTarget(self, action: #selector(showInputURLAllert), for: .touchUpInside)
        return button
    }()
    
    lazy var sortBySelectionAlert: UIAlertController = {
        let alert = UIAlertController(
            title: StringResource.sortBySelectionAlertTitle, message: StringResource.sortBySelectionAlertMessage, preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "\(StringResource.sortBy) \(SortBy.Date.toString())", style: .default, handler: { [weak self] _ in
            self?.onSortChange(newSortBy: SortBy.Date)
        }))
        alert.addAction(UIAlertAction(title: "\(StringResource.sortBy) \(SortBy.Name.toString())", style: .default, handler: { [weak self] _ in
            self?.onSortChange(newSortBy: SortBy.Name)
        }))
        alert.addAction(UIAlertAction(title: StringResource.cancel, style: .cancel))
        return alert
    }()
    
    lazy var filterBySelectionAlert: UIAlertController = {
        let alert = UIAlertController(
            title: StringResource.filterAlertTitle, message: StringResource.filterAlertTitleMessage, preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title:FilterByDownloadState.All.toString(), style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByDownloadState.All)
        }))
        alert.addAction(UIAlertAction(title: FilterByDownloadState.Downloading.toString(), style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByDownloadState.Downloading)
        }))
        alert.addAction(UIAlertAction(title: FilterByDownloadState.Pause.toString(), style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByDownloadState.Pause)
        }))
        alert.addAction(UIAlertAction(title: FilterByDownloadState.Completed.toString(), style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByDownloadState.Completed)
        }))
        alert.addAction(UIAlertAction(title: FilterByDownloadState.Canceled.toString(), style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByDownloadState.Canceled)
        }))
        alert.addAction(UIAlertAction(title: FilterByDownloadState.Error.toString(), style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByDownloadState.Error)
        }))
        alert.addAction(UIAlertAction(title: StringResource.cancel, style: .cancel))
        return alert
    }()
    
    
    
    // MARK: - CONFIG UI CONSTRAINT
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
    
    private func configTableViewConstraint(){
        downloadItemsTableView.topAnchor.constraint(equalTo: buttonSort.bottomAnchor, constant: DimenResource.screenDefaultMargin.top).isActive = true
        downloadItemsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: DimenResource.screenDefaultMargin.bottom).isActive = true
        downloadItemsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimenResource.screenDefaultMargin.left).isActive = true
        if #available(iOS 11.0, *) {
            downloadItemsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: DimenResource.screenDefaultMargin.right).isActive = true
        } else {
            downloadItemsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: DimenResource.screenDefaultMargin.right).isActive = true
        }
    }
    
    private func configButtonSortConstraint(){
        buttonSort.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: DimenResource.screenDefaultMargin.top).isActive = true
        buttonSort.trailingAnchor.constraint(equalTo: buttonFilter.leadingAnchor, constant: DimenResource.screenDefaultMargin.right).isActive = true
        buttonSort.heightAnchor.constraint(equalToConstant: DimenResource.buttonIconHeight).isActive = true
    }
    
    private func configButtonFilterConstraint(){
        buttonFilter.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: DimenResource.screenDefaultMargin.top).isActive = true
        if #available(iOS 11.0, *) {
            buttonFilter.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: DimenResource.screenDefaultMargin.right-10).isActive = true
        } else {
            buttonFilter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: DimenResource.screenDefaultMargin.right-10).isActive = true
        }
        buttonFilter.heightAnchor.constraint(equalToConstant: DimenResource.buttonIconHeight).isActive = true
    }
    
    private func configEmptyDownloadsMessage(){
        emptyDownloadsMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyDownloadsMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // MARK: - CONTROLLER SETUP
    private var downloadManager = DownloadManager.sharedInstance()
    private var searchKey: String = ""
    private var sortBy: SortBy = SortBy.Date
    private var sortDiv: SortDIV = SortDIV.Asc
    private var filterBy: FilterByDownloadState = FilterByDownloadState.All
    private let mapDownloadItemToCell: NSMapTable = NSMapTable<DownloadItem, DownloadItemViewCell>.weakToWeakObjects()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllDownLoadItems()
        setUpContentView()
        hideKeyboardWhenTappedAround()
        downloadManager.setInternetTrackingDelegate(self)
        downloadManager.setDownloadViewDelegate(self)
    }
    
    private func setUpContentView(){
        
        view.backgroundColor = .white
        navigationItem.titleView = titleName
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addNewDownloadButton)
        
        view.addSubview(searchBar)
        configSearchBarConstraint()
        
        view.addSubview(buttonFilter)
        configButtonFilterConstraint()
        
        view.addSubview(buttonSort)
        configButtonSortConstraint()
        
        view.addSubview(downloadItemsTableView)
        configTableViewConstraint()
        
        view.addSubview(emptyDownloadsMessage)
        configEmptyDownloadsMessage()
        
       
    }
    
    private func setUpContentViewState(){
        if(getAllDownloadItemMatchSearchSortAndFilter().isEmpty){
            if(filterBy == FilterByDownloadState.All){
                emptyDownloadsMessage.text = StringResource.emptyDownloadsMessage
                downloadItemsTableView.isHidden = true
            }else{
                emptyDownloadsMessage.text = StringResource.emptyDownloadsMessageFilter
                downloadItemsTableView.isHidden = true
            }
        }else{
            emptyDownloadsMessage.text = nil
            downloadItemsTableView.isHidden = false
        }
    }
    
    private func fetchAllDownLoadItems(){
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else{
                return
            }
            self.downloadManager.fetchAllDownloadItemsWith {
                DispatchQueue.main.async {
                    self.reloadTableViewData()
                    self.setUpContentViewState()
                }
            }
        }
    }

    
    @objc func onFilterClick(){
        present(filterBySelectionAlert, animated: true)
    }
    
    @objc func onSortClick(){
        present(sortBySelectionAlert, animated: true)
    }
    
    private func onSortChange(newSortBy: SortBy){
        if(sortBy == newSortBy){
            sortDiv.reverse()
            setIconOfSortButton()
        }else{
            sortBy = newSortBy
            buttonSort.setTitle(newSortBy.toString(), for: .normal)
        }
        reloadTableViewData()
    }
    
    private func onFilterChange(newFilter: FilterByDownloadState){
        if(newFilter != filterBy){
            buttonFilter.setTitle(newFilter.toString(), for: .normal)
            buttonFilter.layoutIfNeeded()
            filterBy = newFilter
            reloadTableViewData()
        }
    }
    
    private func onDeleteDownloadItem(downloadItem: DownloadItem){
        downloadManager.remove(downloadItem)
        reloadTableViewData()
    }
    
    private func onRenameDownloadItem(downloadItem: DownloadItem){
        showInputNewNameOfDownloadItem(downloadItem)
    }
    
    private func onRestartDownloadItem(downloadItem: DownloadItem){
        downloadManager.restart(downloadItem)
        
        if(filterBy != FilterByDownloadState.Downloading){
            reloadTableViewData()
            
        }else{
            reloadCell(currentDownloadItem: downloadItem)
        }
    }
    
    private func onCopyURLOfDownloadItem(downloadItem: DownloadItem){
        UIPasteboard.general.string = String(describing: downloadItem.url)
    }
    
    private func onAddNewInputURL(_ inputURL: String){
        if(downloadManager.checkValidDownloadURL(inputURL)){
            DispatchQueue.global(qos: .utility).async {[weak self] in
                self?.downloadManager.download(withURL: inputURL)
                DispatchQueue.main.async {
                    self?.reloadTableViewData()
                }
            }
        }else{
            showErrorNotification(message: "Invalid download url!")
        }
    }
    
    private func showErrorNotification(message: String){
        present(UIAlertController.notificationAlert(type: NotificationAlertType.Error, message: message), animated: true)
    }
    
    @objc private func showInputURLAllert(){
        let alert = UIAlertController(
            title: "Download URL",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField{ field in
            field.placeholder = "https://example.com"
            field.returnKeyType = .done
            field.keyboardType = .URL
        }
        // add action to alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertFieldCount = 1;
        let downloadAction = UIAlertAction(title: "Download", style: .default, handler: { [weak self] _ in
            if let fields = alert.textFields, fields.count == alertFieldCount {
                if let inputURL = fields[0].text, !fields[0].text!.isEmpty {
                    self?.onAddNewInputURL(inputURL)
                }else{
                    self?.showErrorNotification(message: "Please enter download url!")
                }
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(downloadAction)
        alert.preferredAction = downloadAction
        present(alert, animated: true)
    }
    
    private func showInputNewNameOfDownloadItem(_ downloadItem: DownloadItem){
        let alert = UIAlertController(
            title: "Rename download item",
            message: nil,
            preferredStyle: .alert
        )
        alert.addTextField{ field in
            field.placeholder = "example"
            field.text = downloadItem.name
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
                        if(self.downloadManager.isValidFileName(newName)){
                            self.downloadManager.renameDownloadItem(downloadItem, toNewName: newName)
                            self.reloadCell(currentDownloadItem: downloadItem)
                        }
                        else{
                            self.showErrorNotification(message: "Name is in wrong format!")
                        }
                    }else{
                        self.showErrorNotification(message: "Name can not place empty!")
                    }
                }
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(renameAction)
        alert.preferredAction = renameAction
        present(alert, animated: true)
    }
    
    private func showActionOfDownloadItem(downloadItem: DownloadItem){
        let alert = UIAlertController(
            title: "\(downloadItem.name)",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [weak self] _ in
            self?.onRenameDownloadItem(downloadItem: downloadItem)
        }))
        alert.addAction(UIAlertAction(title: "Copy URL", style: .default, handler: { [weak self] _ in
            self?.onCopyURLOfDownloadItem(downloadItem: downloadItem)
        }))
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { [weak self] _ in
            self?.onRestartDownloadItem(downloadItem: downloadItem)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.onDeleteDownloadItem(downloadItem: downloadItem)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    private func showDeleteConfirmAlert(downloadItem: DownloadItem){
        let alert = UIAlertController(
            title: "Delete",
            message: "Ensure to delete this download item?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            if let self = self{
                self.onDeleteDownloadItem(downloadItem: downloadItem)
            }
        }))
        present(alert, animated: true)
    }
    
    private func setIconOfSortButton(){
        if(sortDiv == SortDIV.Asc){
            buttonSort.setImage(UIImage(named: "sort-asc"), for: .normal)
        }else{
            buttonSort.setImage(UIImage(named: "sort-desc"), for: .normal)
        }
    }
    
    private func getAllDownloadItemMatchSearchSortAndFilter()-> [DownloadItem]{
        // get all original list
        var downloadItems = downloadManager.getAllDownloadItems()
        // filter
        if(filterBy != FilterByDownloadState.All){
            downloadItems = downloadItems.filter({ downloadItem in
                return downloadItem.state == String(describing: filterBy)
            })
        }
        // search
        if(!searchKey.isEmpty){
            downloadItems = downloadItems.filter({ downloadItem in
                return downloadItem.name.lowercased().contains(searchKey.lowercased())
            })
        }
        // sort
        switch(sortBy){
        case SortBy.Name: do{
            downloadItems.sort { hls, fls in
                compareObjectToSort(sortDiv: sortDiv, ObjFirst: hls.name.lowercased(), ObjSecond: fls.name.lowercased())
            }
            break
        }
        case SortBy.Date: do{
            if(sortDiv == SortDIV.Asc){
                downloadItems.reverse()
            }
        }
        }
        return downloadItems
    }
    
    private func compareObjectToSort<T: Comparable>(sortDiv: SortDIV, ObjFirst: T, ObjSecond: T)-> Bool{
        if(sortDiv == SortDIV.Asc){
            return ObjFirst < ObjSecond
        }else{
            return ObjFirst > ObjSecond
        }
    }
}
// MARK: - CONFIRM SEARCH BAR DELEGATE
extension DownloadViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchKey = searchText
        reloadTableViewData()
    }
}
// MARK: - CONFIRM TABLE VIEW DELEGATE
extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getAllDownloadItemMatchSearchSortAndFilter().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadItemViewCell.identifier) as! DownloadItemViewCell
        guard indexPath.row < getAllDownloadItemMatchSearchSortAndFilter().count else{
            return cell
        }
        let displayingDownloadItem = getAllDownloadItemMatchSearchSortAndFilter()[indexPath.row]
        cell.setUpDataCell(downloadItem: displayingDownloadItem)
        cell.delegate = self
        mapDownloadItemToCell.setObject(cell, forKey: displayingDownloadItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard indexPath.row < getAllDownloadItemMatchSearchSortAndFilter().count else{
            return nil
        }
        let downloadItem = getAllDownloadItemMatchSearchSortAndFilter()[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, _ in
            self?.showDeleteConfirmAlert(downloadItem: downloadItem)
        }
        let otherAction = UITableViewRowAction(style: .normal, title: "Action") { [weak self] _,_  in
            self?.showActionOfDownloadItem(downloadItem: downloadItem)
        }
        return [deleteAction, otherAction]
    }
    
    func reloadCell(currentDownloadItem: DownloadItem){
        let cell = self.mapDownloadItemToCell.object(forKey: currentDownloadItem)
        if(cell?.getCurrentDownloadItem() == currentDownloadItem){
            cell?.setUpCellByDownloadState(downLoadState: currentDownloadItem.state)
        }
    }
    
    func reloadRow(currentDownloadItem: DownloadItem){
        if let position = getAllDownloadItemMatchSearchSortAndFilter().firstIndex(of: currentDownloadItem){
            let indexPath = IndexPath(item: position, section: 0)
            downloadItemsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func reloadTableViewData(){
        self.downloadItemsTableView.reloadData()
        self.setUpContentViewState()
    }
    
}
//MARK: - CONFORM DOWNLOAD ITEM CELL DELEGATE
extension DownloadViewController: DownloadItemCellDelegate{
    
    func cancelClick(downloadItem: DownloadItem) {
        self.downloadManager.cancelDownload(downloadItem)
        if(filterBy == FilterByDownloadState.Pause){
            self.reloadTableViewData()
        }else{
            self.reloadCell(currentDownloadItem: downloadItem)
        }
    }
    
    func resumeClick(downloadItem: DownloadItem) {
        self.downloadManager.resumeDownload(downloadItem)
        if(filterBy == FilterByDownloadState.Pause){
            self.reloadTableViewData()
        }else{
            self.reloadCell(currentDownloadItem: downloadItem)
        }
    }
    
    func pauseClick(downloadItem: DownloadItem) {
        self.downloadManager.pauseDownload(downloadItem) {
            DispatchQueue.main.async { [self] in
                if(filterBy == FilterByDownloadState.Downloading){
                    self.reloadTableViewData()
                }else{
                    self.reloadCell(currentDownloadItem: downloadItem)
                }
                
            }
        }
    }
}
//MARK: - CONFORM DOWNLOAD DELEGATE
extension DownloadViewController: DownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let currentDownloadItem: DownloadItem? = self.downloadManager.getItemBy(downloadTask);
        
        if let currentDownloadItem = currentDownloadItem {
            self.downloadManager.didFinishDownloadingTask(downloadTask, toLocation: location) {
                DispatchQueue.main.async {[weak self] in
                    if(self?.filterBy == FilterByDownloadState.Downloading){
                        self?.reloadTableViewData()
                    }else{
                        self?.reloadRow(currentDownloadItem: currentDownloadItem)
                    }
                }
            } andFailureHandler: {[weak self] message in
                DispatchQueue.main.async {
                    self?.showErrorNotification(message: message)
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if(self.downloadManager.shouldRestartTracking()){
            self.downloadManager.callForHaveInternetConnection();
        }
        
        let currentDownloadItem = self.downloadManager.getItemBy(downloadTask);
        
        currentDownloadItem.totalSizeFitWithUnit = (FileSizeUnits(bytes: totalBytesExpectedToWrite).getReadableUnit())
        currentDownloadItem.durationString = "\(FileSizeUnits(bytes: totalBytesWritten).getReadableUnit()) / \(currentDownloadItem.totalSizeFitWithUnit)"
        
        DispatchQueue.main.async {[weak self] in
            guard let self = self else{
                return
            }
            let cell = self.mapDownloadItemToCell.object(forKey: currentDownloadItem)
            if(cell?.getCurrentDownloadItem() == currentDownloadItem){
                cell?.setDownloadItemDownloadDuration(currentDownloadItem.durationString)
                let progress: Double = Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)
                cell?.updateProgressBar(progress: progress)
                cell?.setProgressBarColorByInternetConnectionState(hasInternetConection: true)
            }
        }
    }
}
//MARK: - CONFIRM INTERNET TRACKING DELEGATE
extension DownloadViewController: InternetTrackingDelegate{
    func noInternetConnectionHandler() {
        present(UIAlertController.notificationAlert(type: NotificationAlertType.Warning, message: "Check your internet connection!"), animated: true)
        for item in mapDownloadItemToCell.keyEnumerator(){
            let downloadItem = item as! DownloadItem
            let cell = mapDownloadItemToCell.object(forKey: downloadItem)
            if(cell?.getCurrentDownloadItem() == downloadItem){
                cell?.setProgressBarColorByInternetConnectionState(hasInternetConection: false)
            }
        }
    }
}
