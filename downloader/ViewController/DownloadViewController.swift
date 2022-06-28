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
    
    func createInputDownloadURLAlert() -> UIAlertController {
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
        let alertFieldCount = 1; //
        let downloadAction = UIAlertAction(title: "Download", style: .default, handler: { _ in
            if let fields = alert.textFields, fields.count == alertFieldCount {
                if let inputURL = fields[0].text, !fields[0].text!.isEmpty {
                    if(self.downloadManager.checkValidDownloadURL(inputURL)){
                        DispatchQueue.global(qos: .utility).async {[self] in
                            self.downloadManager.download(withURL: inputURL)
                            DispatchQueue.main.async {
                                self.downloadItemsTableView.reloadData()
                            }
                        }
                        
                    }else{
                        let invalidURLNotification = UIAlertController(title: "Error", message: "Invalid download url!", preferredStyle: .alert)
                        invalidURLNotification.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self.present(invalidURLNotification, animated: false)
                    }
                }else{
                    let emptyURLNotification = UIAlertController(title: "Error", message: "Please enter download url!", preferredStyle: .alert)
                    emptyURLNotification.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(emptyURLNotification, animated: false)
                }
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(downloadAction)
        alert.preferredAction = downloadAction
        
        return alert
    }
    lazy var downloadItemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(DownloadItemViewCell.self, forCellReuseIdentifier: DownloadItemViewCell.identifier)
        return tableView
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
        downloadItemsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Dimen.screenDefaultMargin.top).isActive = true
        downloadItemsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Dimen.screenDefaultMargin.bottom).isActive = true
        downloadItemsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimen.screenDefaultMargin.left).isActive = true
        downloadItemsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
    }
    
    // MARK: - CONTROLLER SETUP
    
    private var downloadManager = DownloadManager.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = titleName
        // set up button add new download item
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(addNewDownloadItemClick))
        view.addSubview(searchBar)
        configSearchBarConstraint()
        view.addSubview(downloadItemsTableView)
        configTableViewConstraint()
        
        downloadManager.setDownloadViewDelegate(self)
    }
    @objc func addNewDownloadItemClick(){
        present(createInputDownloadURLAlert(), animated: true)
    }
}
// MARK: - CONFIRM SEARCH BAR DELEGATE
extension DownloadViewController: UISearchBarDelegate{

}
// MARK: - CONFIRM TABLE VIEW DELEGATE
extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadManager.allDownloadItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadItemViewCell.identifier) as! DownloadItemViewCell
        cell.setUpDataCell(downloadItem: downloadManager.allDownloadItems[indexPath.row] as! DownloadItem)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let downloadItem = downloadManager.allDownloadItems[indexPath.row] as! DownloadItem
        return downloadItem.state != String(describing: DownloadState.Downloading)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
            print("Remove item at index: \(indexPath.row)")
        }
        let otherAction = UITableViewRowAction(style: .normal, title: "Action") { action, index in
            print("Do some action here")
        }
        return [deleteAction, otherAction]
    }
    
    func reloadRow(downloadItem: DownloadItem){
        let position = self.downloadManager.allDownloadItems.index(of: downloadItem)
        let indexPath = IndexPath(row: position, section: 0)
        self.downloadItemsTableView.reloadRows(at: [indexPath], with: .none)
    }
}
//MARK: - CONFORM DOWNLOAD ITEM CELL DELEGATE
extension DownloadViewController: DownloadItemViewCellDelegate{
    
    func cancelClick(downloadItem: DownloadItem) {
        self.downloadManager.cancelDownload(downloadItem)
        self.reloadRow(downloadItem: downloadItem)
    }
    
    func resumeClick(downloadItem: DownloadItem) {
        self.downloadManager.resumeDownload(downloadItem)
        self.reloadRow(downloadItem: downloadItem)
    }
    
    func pauseClick(downloadItem: DownloadItem) {
        self.downloadManager.pauseDownload(downloadItem) {
            DispatchQueue.main.async { [self] in
                self.reloadRow(downloadItem: downloadItem)
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
                    let pathExtension = URL(fileURLWithPath: downloadTask.response?.mimeType ?? "/tmp").lastPathComponent
                    let fileExtension: String = (i > 0) ? ("(\(i)).\(pathExtension)") : (".\(pathExtension)")
                    let fileName = "\(currentDownloadItem.name)\(fileExtension)"
                    let savedURL = documentsURL.appendingPathComponent(
                        fileName)
                    do{
                        try FileManager.default.moveItem(at: location, to: savedURL)
                        currentDownloadItem.state = String(describing: DownloadState.Complete)
                        print(savedURL)
                        break;
                    }catch{
                        i += 1
                    }
                }while(true)
                DispatchQueue.main.async {[self] in
                    self.reloadRow(downloadItem: currentDownloadItem)
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
        if(currentDownloadItem.totalSizeFitWithUnit.isEmpty){
            currentDownloadItem.totalSizeFitWithUnit = (FileSizeUnits(bytes: totalBytesExpectedToWrite).getReadableUnit())
        }
        currentDownloadItem.durationString = "\(FileSizeUnits(bytes: totalBytesWritten).getReadableUnit()) of \(currentDownloadItem.totalSizeFitWithUnit)"
        DispatchQueue.main.async {[self] in
            self.reloadRow(downloadItem: currentDownloadItem)
        }
    }
}
