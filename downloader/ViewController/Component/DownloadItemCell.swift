//
//  DownloadItemCell.swift
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

import UIKit

class DownloadItemCell: UITableViewCell {
    lazy var bookName: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Product name"
        lable.textColor = .black
        lable.font = UIFont.boldSystemFont(ofSize: 20)
        return lable
    }()
    lazy var downloadedQuantity: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Downloaded: "
        lable.textColor = .gray
        lable.font = UIFont.systemFont(ofSize: 17)
        return lable
    }()
    
    lazy var downloadingQuantity: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Downloading: "
        lable.textColor = .gray
        lable.font = UIFont.systemFont(ofSize: 17)
        return lable
    }()
    
    lazy var buttonDownload: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var configuation = UIButton.Configuration.borderless()
        configuation.baseForegroundColor = .black
        configuation.image = UIImage(systemName: "arrow.down.doc")
        button.configuration = configuation
        return button
    }()
    lazy var buttonCancel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var configuation = UIButton.Configuration.borderless()
        configuation.baseForegroundColor = .black
        configuation.image = UIImage(systemName: "xmark.rectangle")
        button.configuration = configuation
        return button
    }()
    lazy var buttonDelete: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var configuation = UIButton.Configuration.borderless()
        configuation.baseForegroundColor = .black
        configuation.image = UIImage(systemName: "trash")
        button.configuration = configuation
        return button
    }()
    lazy var buttonPrint: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var configuation = UIButton.Configuration.borderless()
        configuation.baseForegroundColor = .black
        configuation.image = UIImage(systemName: "printer")
        button.configuration = configuation
        return button
    }()
    
    lazy var downloadBookContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.addArrangedSubview(bookInformationContainer)
        stackView.addArrangedSubview(downloadController)
        
        bookInformationContainer.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
        downloadController.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
        return stackView
    }()
    
    lazy var bookInformationContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.addArrangedSubview(bookName)
        stackView.addArrangedSubview(downloadedQuantity)
        stackView.addArrangedSubview(downloadingQuantity)
        return stackView
    }()
    lazy var downloadController: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(buttonDownload)
        stackView.addArrangedSubview(buttonCancel)
        stackView.addArrangedSubview(buttonDelete)
        stackView.addArrangedSubview(buttonPrint)
        return stackView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(downloadBookContainer)
        downloadBookContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        downloadBookContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        downloadBookContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        downloadBookContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
