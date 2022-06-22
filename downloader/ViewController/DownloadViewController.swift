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
        titleName.font = UIFont.boldSystemFont(ofSize: 30)
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
    
    lazy var inputDownloadURLView: UIAlertController = {
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
        let downloadAction = UIAlertAction(title: "Download", style: .default, handler: { _ in
            if let fields = alert.textFields, fields.count == 1 {
                if let inputURL = fields[0].text, !fields[0].text!.isEmpty {
                    print("Download link: \(inputURL)")
                }
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(downloadAction)
        alert.preferredAction = downloadAction
        
        return alert
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
    
    
    // MARK: - CONFIG UI CONSTRAINT
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
    private func configTableViewConstraint(){
        downloadItemsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        downloadItemsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        downloadItemsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        downloadItemsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    // MARK: - CONTROLLER SETUP
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
    }
    @objc func addNewDownloadItemClick(){
        present(inputDownloadURLView, animated: true)
    }
}
// MARK: - CONFIRM SEARCH BAR DELEGATE
extension DownloadViewController: UISearchBarDelegate{
    
}
// MARK: - CONFIRM TABLE VIEW DELEGATE
extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadItemViewCell.identifier) as! DownloadItemViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
    
}
