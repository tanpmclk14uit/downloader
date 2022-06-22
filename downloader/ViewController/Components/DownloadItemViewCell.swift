//
//  DownloadItemViewCell.swift
//  downloader
//
//  Created by LAP14812 on 22/06/2022.
//

import UIKit

class DownloadItemViewCell: UITableViewCell {
    //MARK: - CONFIG UI
    lazy var downloadItemTitle: UILabel = {
        let downloadItemTitle = UILabel()
        downloadItemTitle.translatesAutoresizingMaskIntoConstraints = false
        downloadItemTitle.text = "Download item title"
        downloadItemTitle.font = UIFont.boldSystemFont(ofSize: 20)
        return downloadItemTitle
    }()
    
    lazy var downloadItemStatus: UILabel = {
        let downloadItemStatus = UILabel()
        downloadItemStatus.translatesAutoresizingMaskIntoConstraints = false
        downloadItemStatus.text = "Download item status"
        downloadItemStatus.font = UIFont.systemFont(ofSize: 18)
        return downloadItemStatus
    }()
     
    lazy var downloadItemButtonAction: UIButton = {
        let downloadItemButtonAction = UIButton()
        downloadItemButtonAction.translatesAutoresizingMaskIntoConstraints = false
        downloadItemButtonAction.setImage(UIImage(named: "download.fill.action"), for: .normal)
        downloadItemButtonAction.tintColor = .gray
        return downloadItemButtonAction
    }()
    
    lazy var itemCellLayout: UIView = {
        let layout = UIView()
        layout.translatesAutoresizingMaskIntoConstraints = false
        layout.backgroundColor = .white
        layout.addSubview(downloadItemButtonAction)
        // config button download action
        downloadItemButtonAction.topAnchor.constraint(equalTo: layout.topAnchor).isActive = true
        downloadItemButtonAction.bottomAnchor.constraint(equalTo: layout.bottomAnchor).isActive = true
        downloadItemButtonAction.trailingAnchor.constraint(equalTo: layout.trailingAnchor, constant: -10).isActive = true
        downloadItemButtonAction.widthAnchor.constraint(equalToConstant: 40).isActive = true
        // config content tile & status
        let contentLayout = UIStackView()
        contentLayout.translatesAutoresizingMaskIntoConstraints = false
        contentLayout.axis = .vertical
        contentLayout.distribution = .fillEqually
        layout.addSubview(contentLayout)
        contentLayout.addArrangedSubview(downloadItemTitle)
        contentLayout.addArrangedSubview(downloadItemStatus)
        contentLayout.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: 10).isActive = true
        contentLayout.trailingAnchor.constraint(equalTo: downloadItemButtonAction.leadingAnchor, constant: -10).isActive = true
        contentLayout.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        contentLayout.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return layout
    }()
    //MARK: - CONFIG CELL CONSTRAINT
    private func configItemCellConstraint(){
        itemCellLayout.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        itemCellLayout.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        itemCellLayout.heightAnchor.constraint(equalToConstant: 60).isActive = true
        itemCellLayout.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
     }
    // MARK: - SETUP ITEM CELL
    public static let identifier: String = "DownloadItemCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(itemCellLayout)
        
        configItemCellConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
