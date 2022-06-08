//
//  ViewController.swift
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var downloadItemsView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.register(DownloadItemCell.self, forCellReuseIdentifier: DownloadItemCell.identifier)
        return tableView
    }()
    
    private var downloadItems: [DownloadItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(downloadItemsView)
        configDownloadItemViewContraints()
        downloadItems = fetchDownloadItem()
    }
    private func configDownloadItemViewContraints(){
        downloadItemsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        downloadItemsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        downloadItemsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        downloadItemsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadItemCell.identifier) as! DownloadItemCell
        cell.setDownloadItem(downloadItems[indexPath.row])
        cell.delegate = self
        return cell
    }
}
extension MainViewController{
    func fetchDownloadItem() -> [DownloadItem]{
        let learniOSDev = DownloadItem(name: "Learn iOS dev", andDownloadLink: "")
        let beginningiOS = DownloadItem(name: "Beginning iOS", andDownloadLink: "")
        let theBigNerdRanch = DownloadItem(name: "The Big Nerd Ranch", andDownloadLink: "")
        return [learniOSDev, beginningiOS, theBigNerdRanch]
    }
}
extension MainViewController: DownloadItemCellDelegate{
    func downloadClick(downloadItem: DownloadItem) {
        print(downloadItem.name)
    }
}



