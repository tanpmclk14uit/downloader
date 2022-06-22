//
//  ViewController.swift
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Init UI
    lazy var downloadItemsView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DownloadItemCell.self, forCellReuseIdentifier: DownloadItemCell.identifier)
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        // searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.placeholder = "Search for download item"
        return searchBar
    }()
    
    
    private var downloader: Downloader?
    private var filterDownloadItems: Array<DownloadItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // init main controller
        downloader = Downloader.sharedInstance()
        downloader?.setDownloadViewDelegate(self)
        filterDownloadItems = downloader?.downloadItems
        view.addSubview(downloadItemsView)
        configDownloadItemViewContraints()
        navigationItem.titleView = searchBar
        
    }
    private func configDownloadItemViewContraints(){
        downloadItemsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        downloadItemsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        downloadItemsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        downloadItemsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
}
// MARK: - Conform Table Delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterDownloadItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadItemCell.identifier) as! DownloadItemCell
        cell.setDownloadItem((filterDownloadItems?[indexPath.row])!, position: indexPath.row)
        cell.delegate = self
        return cell
    }
}
// MARK: - Conform DowloadItemCellDelegate
extension MainViewController: DownloadItemCellDelegate{
    func deleteClick(dowloadItem: DownloadItem, position: Int) {
        if(dowloadItem.removeDownloadedCopySuccess()){
            reloadRow(position: position)
        }else{
            print("Error")
        }
    }
    
    func cancelClick(dowloadItem: DownloadItem, position: Int) {
        dowloadItem.cancelRandomDownloadingTask()
        reloadRow(position: position)
    }
    
    func printClick(dowloadItem: DownloadItem, position: Int) {
        dowloadItem.shouldShowCopiesItem = true
        reloadRow(position: position)
    }
    
    func downloadClick(downloadItem: DownloadItem, position: Int) {
        DispatchQueue.global(qos: .utility).async { [self] in
            self.downloader?.downloadItem(downloadItem)
            DispatchQueue.main.async {
                self.reloadRow(position: position)
            }
        }
    }
    
    private func reloadRow(position: Int){
        let indexPath = IndexPath(row: position, section: 0)
        self.downloadItemsView.reloadRows(at: [indexPath], with: .fade)
    }
}
// MARK: - Conform DownloadDelegate
extension MainViewController: DownloadDelegate{
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let currentDownloadItem = self.downloader?.getItemByDownloadingTask(downloadTask);
        if let downloadItem = currentDownloadItem{
            do {
                let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
                var i: Int = 0;
                repeat{
                    let fileExtension: String = (i > 0) ? ("(\(i)).pdf") : (".pdf")
                    let fileName = "\(downloadItem.name)\(fileExtension)"
                    let savedURL = documentsURL.appendingPathComponent(
                        fileName)
                    do{
                        try FileManager.default.moveItem(at: location, to: savedURL)
                        downloadItem.downloadedCount += 1
                        downloadItem.downloadingCount -= 1
                        downloadItem.addNewDownloadedCopy(fileName)
                        downloadItem.removeDowloadingTask(downloadTask)
                        print(savedURL)
                        break;
                    }catch{
                        i += 1
                    }
                }while(true)
                DispatchQueue.main.async {
                    self.reloadRow(position: self.downloader?.downloadItems.firstIndex(of: downloadItem) ?? 0)
                }
            } catch {
                print("error")
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //handle progress here
        let calculatedProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print(calculatedProgress)
    }
}
// MARK: - Search bar delegate
extension MainViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(!searchText.isEmpty){
            filterDownloadItems = downloader?.downloadItems.filter({(downloadItem: DownloadItem)->Bool in
                return downloadItem.name.lowercased().contains(searchText.lowercased())
            })
        }else{
            filterDownloadItems = downloader?.downloadItems
        }
        self.downloadItemsView.reloadData()
    }
}

