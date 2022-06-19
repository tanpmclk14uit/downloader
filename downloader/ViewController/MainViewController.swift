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
    
    private var controller: MainController?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // init main controller
        controller = MainController()
        controller?.setDownloadViewDelegate(self)
        view.addSubview(downloadItemsView)
        configDownloadItemViewContraints()
        
    }
    private func configDownloadItemViewContraints(){
        downloadItemsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        downloadItemsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        downloadItemsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        downloadItemsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
    }
}
// MARK: - Conform Table Delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller?.downloadItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadItemCell.identifier) as! DownloadItemCell
        cell.setDownloadItem((controller?.downloadItems[indexPath.row])!, position: indexPath.row)
        cell.delegate = self
        return cell
    }
}
// MARK: - Conform DowloadItemCellDelegate
extension MainViewController: DownloadItemCellDelegate{
    func cancelClick(position: Int) {
        reloadRow(position: position)
    }
    
    func deleteClick(position: Int) {
        reloadRow(position: position)
    }
    
    func printClick(dowloadItem: DownloadItem, position: Int) {
        dowloadItem.shouldShowCopiesItem = true
        reloadRow(position: position)
    }
    
    func downloadClick(downloadItem: DownloadItem, position: Int) {
        DispatchQueue.global(qos: .utility).async { [self] in
            self.controller?.downloadItem(downloadItem)
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
        let currentDownloadItem = self.controller?.getItemByDownloadingTask(downloadTask);
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
                    self.reloadRow(position: self.controller?.downloadItems.firstIndex(of: downloadItem) ?? 0)
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



