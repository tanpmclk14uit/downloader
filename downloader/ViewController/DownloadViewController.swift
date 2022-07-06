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
        titleName.text = "Downloads"
        titleName.textColor = .black
        titleName.font = UIFont.boldSystemFont(ofSize: Dimen.screenTitleTextSize)
        return titleName
    }()
    
    lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search in downloads"
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
        return searchBar
    }()
    
    lazy var buttonSort: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sort by Date", for: .normal)
        button.setImage(UIImage(named: "sort-asc"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .systemBlue
        return button
    }()
    
    lazy var buttonFilter: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("All process", for: .normal)
        button.setImage(UIImage(named: "filtered"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .systemBlue
        return button
    }()
    
    lazy var downloadItemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(DownloadItemViewCell.self, forCellReuseIdentifier: DownloadItemViewCell.identifier)
        return tableView
    }()
    
    lazy var emptyListMessage: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = .gray
        lable.numberOfLines = 2
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: Dimen.screenNormalTextSize)
        return lable
    }()
    
    lazy var sortBySelectionAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "Sort", message: "Select property to sort", preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "Sort by date", style: .default, handler: { [weak self] _ in
            self?.onSortChange(newSortBy: BasicSort.Date)
        }))
        alert.addAction(UIAlertAction(title: "Sort by name", style: .default, handler: { [weak self] _ in
            self?.onSortChange(newSortBy: BasicSort.Name)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alert
    }()
    
    lazy var filterBySelectionAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "Filter", message: "Select state to filter", preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "All", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByState.All)
        }))
        alert.addAction(UIAlertAction(title: "Downloading", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByState.Downloading)
        }))
        alert.addAction(UIAlertAction(title: "Pause", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByState.Pause)
        }))
        alert.addAction(UIAlertAction(title: "Completed", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByState.Completed)
        }))
        alert.addAction(UIAlertAction(title: "Canceled", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByState.Canceled)
        }))
        alert.addAction(UIAlertAction(title: "Error", style: .default, handler: { [weak self] _ in
            self?.onFilterChange(newFilter: FilterByState.Error)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alert
    }()
    
    // MARK: - CONFIG UI CONSTRAINT
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
    
    private func configTableViewConstraint(){
        downloadItemsTableView.topAnchor.constraint(equalTo: buttonSort.bottomAnchor, constant: Dimen.screenDefaultMargin.top).isActive = true
        downloadItemsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Dimen.screenDefaultMargin.bottom).isActive = true
        downloadItemsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimen.screenDefaultMargin.left).isActive = true
        downloadItemsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
    }
    
    private func configButtonSortConstraint(){
        buttonSort.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Dimen.screenDefaultMargin.top).isActive = true
        buttonSort.trailingAnchor.constraint(equalTo: buttonFilter.leadingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        buttonSort.heightAnchor.constraint(equalToConstant: Dimen.buttonIconHeight).isActive = true
    }
    
    private func configButtonFilterConstraint(){
        buttonFilter.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Dimen.screenDefaultMargin.top).isActive = true
        buttonFilter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Dimen.screenDefaultMargin.right-10).isActive = true
        buttonFilter.heightAnchor.constraint(equalToConstant: Dimen.buttonIconHeight).isActive = true
    }
    
    // MARK: - CONTROLLER SETUP
    // MARK: - property
    private var downloadManager = DownloadManager.sharedInstance()
    private var downloadItemPersistenceManager = DownloadItemPersistenceManager.sharedInstance()
    private var searchKey: String = ""
    private var sortBy: BasicSort = BasicSort.Date
    private var sortDiv: SortDIV = SortDIV.Asc
    private var filterBy: FilterByState = FilterByState.All
    private let mapDownloadItemToCell: NSMapTable = NSMapTable<DownloadItem, DownloadItemViewCell>.weakToWeakObjects()
    
    //MARK: - function
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = titleName
        // set up button add new download item
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(addNewDownloadItemClick))
        // download view delegate
        downloadManager.setDownloadViewDelegate(self)
        // set up screen
        view.addSubview(searchBar)
        configSearchBarConstraint()
        view.addSubview(buttonFilter)
        configButtonFilterConstraint()
        view.addSubview(buttonSort)
        configButtonSortConstraint()
        view.addSubview(downloadItemsTableView)
        configTableViewConstraint()
        
        buttonSort.addTarget(self, action: #selector(sortButtonClick), for: .touchUpInside)
        buttonFilter.addTarget(self, action: #selector(filterButtonClick), for: .touchUpInside)
        
        // set up empty list table
        view.addSubview(emptyListMessage)
        emptyListMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyListMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        setUpEmptyListMessage()

    }
    
    @objc func addNewDownloadItemClick(){
        showInputURLAllert()
    }
    
    @objc func filterButtonClick(){
        present(filterBySelectionAlert, animated: true)
    }
    
    @objc func sortButtonClick(){
        present(sortBySelectionAlert, animated: true)
    }
    
    private func setUpEmptyListMessage(){
        if(getAllDownloadItemMatchSearchSortAndFilter().isEmpty){
            if(filterBy == FilterByState.All){
                emptyListMessage.text = "Your download process is empty!"
            }else{
                emptyListMessage.text = "Filter result is empty\nplease choose other state!"
            }
        }else{
            emptyListMessage.text = nil
        }
    }
    
    private func onSortChange(newSortBy: BasicSort){
        if(sortBy == newSortBy){
            sortDiv.reverse()
            setIconOfSortButton()
        }else{
            sortBy = newSortBy
            buttonSort.setTitle("Sort by \(newSortBy)", for: .normal)
        }
        reloadTableViewData()
    }
    
    private func onFilterChange(newFilter: FilterByState){
        if(newFilter != filterBy){
            buttonFilter.setTitle("\(newFilter) process", for: .normal)
            filterBy = newFilter
            reloadTableViewData()
        }
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
        let emptyURLNotification = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        emptyURLNotification.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(emptyURLNotification, animated: true)
    }
    
    private func showInputURLAllert(){
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
        if(filterBy != FilterByState.All){
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
        case BasicSort.Name: do{
            downloadItems.sort { hls, fls in
                compareObjectToSort(sortDiv: sortDiv, ObjFirst: hls.name, ObjSecond: fls.name)
            }
            break
        }
        case BasicSort.Date: do{
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
        let displayingDownloadItem = getAllDownloadItemMatchSearchSortAndFilter()[indexPath.row]
        cell.setUpDataCell(downloadItem: displayingDownloadItem)
        cell.delegate = self
        mapDownloadItemToCell.setObject(cell, forKey: displayingDownloadItem)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let downloadItem = getAllDownloadItemMatchSearchSortAndFilter()[indexPath.row]
        return downloadItem.state != String(describing: DownloadState.Downloading)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, indexPath in
            let downloadItem = self?.getAllDownloadItemMatchSearchSortAndFilter()[indexPath.row]
            if let downloadItem = downloadItem{
                self?.downloadManager.remove(downloadItem)
                self?.reloadTableViewData()
            }
        }
        let otherAction = UITableViewRowAction(style: .normal, title: "Action") { action, index in
            print("Do some action here")
        }
        return [deleteAction, otherAction]
    }
    
    func reloadRow(downloadItem: DownloadItem){
        let position = getAllDownloadItemMatchSearchSortAndFilter().firstIndex(of: downloadItem)
        if let position = position{
            let indexPath = IndexPath(row: position, section: 0)
            self.downloadItemsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func reloadTableViewData(){
        self.downloadItemsTableView.reloadData()
        self.setUpEmptyListMessage()
    }
    
}
//MARK: - CONFORM DOWNLOAD ITEM CELL DELEGATE
extension DownloadViewController: DownloadItemViewCellDelegate{
    
    func cancelClick(downloadItem: DownloadItem) {
        self.downloadManager.cancelDownload(downloadItem)
        if(filterBy == FilterByState.Pause){
            self.reloadTableViewData()
        }else{
            self.reloadRow(downloadItem: downloadItem)
        }
    }
    
    func resumeClick(downloadItem: DownloadItem) {
        self.downloadManager.resumeDownload(downloadItem)
        if(filterBy == FilterByState.Pause){
            self.reloadTableViewData()
        }else{
            self.reloadRow(downloadItem: downloadItem)
        }
    }
    
    func pauseClick(downloadItem: DownloadItem) {
        self.downloadManager.pauseDownload(downloadItem) {
            DispatchQueue.main.async { [self] in
                if(filterBy == FilterByState.Downloading){
                    self.reloadTableViewData()
                }else{
                    self.reloadRow(downloadItem: downloadItem)
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
            do {
                let documentsURL = try
                FileManager.default.url(for: .downloadsDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: true)
                var i: Int = 0;
                repeat{
                    let pathExtension = URL(fileURLWithPath: downloadTask.response?.mimeType ?? "/octet-stream").lastPathComponent
                    let fileExtension: String = (i > 0) ? ("(\(i)).\(pathExtension)") : (".\(pathExtension)")
                    let fileName = "\(currentDownloadItem.name)\(fileExtension)"
                    let savedURL = documentsURL.appendingPathComponent(
                        fileName)
                    do{
                        try FileManager.default.moveItem(at: location, to: savedURL)
                        currentDownloadItem.state = String(describing: DownloadState.Completed)
                        print(savedURL)
                        break;
                    }catch{
                        i += 1
                    }
                }while(true)
                DispatchQueue.main.async {[self] in
                    if(filterBy == FilterByState.Downloading){
                        reloadTableViewData()
                    }else{
                        self.reloadRow(downloadItem: currentDownloadItem)
                    }
                }
            } catch {
                print("error")
            }
        }
    }
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("error")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let currentDownloadItem = self.downloadManager.getItemBy(downloadTask);
        currentDownloadItem.totalSizeFitWithUnit = (FileSizeUnits(bytes: totalBytesExpectedToWrite).getReadableUnit())
        currentDownloadItem.durationString = "\(FileSizeUnits(bytes: totalBytesWritten).getReadableUnit()) of \(currentDownloadItem.totalSizeFitWithUnit)"
        
        DispatchQueue.main.async {[self] in
            let cell = self.mapDownloadItemToCell.object(forKey: currentDownloadItem)
            if(cell?.getCurrentDownloadItem() == currentDownloadItem){
                cell?.setDownloadItemDownloadDuration(currentDownloadItem.durationString)
            }
        }
    }
}
