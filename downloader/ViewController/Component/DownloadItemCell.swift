//
//  DownloadItemCell.swift
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

import UIKit

// MARK: Click handler delegate
protocol DownloadItemCellDelegate{
    func downloadClick(downloadItem: DownloadItem, position: Int);
    func printClick(dowloadItem: DownloadItem, position: Int);
    func deleteClick(dowloadItem: DownloadItem, position: Int)
    func cancelClick(dowloadItem: DownloadItem, position: Int)
}
// MARK: - Download item cell UI
class DownloadItemCell: UITableViewCell {
    public var delegate: DownloadItemCellDelegate?
    public static let identifier: String = "DownloadItemCell"
    private var downloadItem: DownloadItem?
    private var downloadItemPosition: Int = 0
    

    //MARK: - Config property UI
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
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "download"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    lazy var buttonCancel: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    lazy var buttonDelete: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "trash"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    lazy var buttonPrint: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "print"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 7, left: 7, bottom: 7, right: 7)
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
    lazy var result: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textColor = .gray
        textView.font = UIFont.boldSystemFont(ofSize: 15)
        return textView
    }()
    //MARK: Method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // disable chagne background when click on item
        self.selectionStyle = .none
        contentView.addSubview(downloadBookContainer)
        contentView.addSubview(result)
        
        configResultConstraint()
        
        configDownloadBookContainerConstraint()
        
        // set up button event
        buttonCancel.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
        
        buttonDelete.addTarget(self, action: #selector(onDeleteClick), for: .touchUpInside)
        
        buttonDownload.addTarget(self, action: #selector(onDownloadClick), for: .touchUpInside)
        
        buttonPrint.addTarget(self, action: #selector(onPrintClick), for: .touchUpInside)
    }
    // MARK: - Set up event
    @objc func onCancelClick(){
        self.delegate?.cancelClick(dowloadItem: self.downloadItem!, position: self.downloadItemPosition)
    }
    
    @objc func onDeleteClick(){
            self.delegate?.deleteClick(dowloadItem: self.downloadItem!, position: self.downloadItemPosition)
    }
    
    @objc func onPrintClick(){
        delegate?.printClick(dowloadItem: self.downloadItem!, position: self.downloadItemPosition)
    }
    
    @objc func onDownloadClick(){
        delegate?.downloadClick(downloadItem: self.downloadItem!, position: self.downloadItemPosition)
    }
    
    // MARK: - Set up constraint
    private func configDownloadBookContainerConstraint(){
        downloadBookContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        downloadBookContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        downloadBookContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        downloadBookContainer.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
    }
    
    private func configResultConstraint(){
        result.topAnchor.constraint(equalTo: downloadBookContainer.bottomAnchor).isActive = true
        result.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        result.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        result.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    // MARK: - init cell
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setDownloadItem(_ downloadItem: DownloadItem, position: Int){
        self.downloadItem = downloadItem
        self.downloadItemPosition = position
        bookName.text = downloadItem.name
        downloadedQuantity.text = "Downloaded: \(downloadItem.downloadedCount)"
        downloadingQuantity.text = "Downloading: \(downloadItem.downloadingCount)"
        if(downloadItem.shouldShowCopiesItem){
            result.text = downloadItem.getAllDownloadedCopiesToString()
        }else{
            result.text = "Result"
        }
        self.downloadItem?.shouldShowCopiesItem = false
    }
}
