//
//  FileItemViewCell.swift
//  downloader
//
//  Created by LAP14812 on 24/06/2022.
//

import UIKit

class FileItemViewCell: UICollectionViewCell {
    //MARK: - CONFIG UI
    lazy var fileName: UILabel = {
        let downloadItemTitle = UILabel()
        downloadItemTitle.translatesAutoresizingMaskIntoConstraints = false
        downloadItemTitle.text = "File item title"
        downloadItemTitle.font = UIFont.systemFont(ofSize: Dimen.itemTitleTextSize)
        return downloadItemTitle
    }()
    
    lazy var fileSize: UILabel = {
        let downloadItemStatus = UILabel()
        downloadItemStatus.translatesAutoresizingMaskIntoConstraints = false
        downloadItemStatus.text = "0 bytes"
        downloadItemStatus.textColor = .gray
        downloadItemStatus.font = UIFont.systemFont(ofSize: Dimen.itemAdditionalContentTextSize)
        return downloadItemStatus
    }()
    
    lazy var fileDate: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = .gray
        lable.text = "3 days ago"
        lable.font = UIFont.systemFont(ofSize: Dimen.itemAdditionalContentTextSize)
        return lable
    }()
    
    lazy var fileButtonAction: UIButton = {
        let downloadItemButtonAction = UIButton(type: .system)
        downloadItemButtonAction.translatesAutoresizingMaskIntoConstraints = false
        downloadItemButtonAction.setImage(UIImage(named: "menu"), for: .normal)
        return downloadItemButtonAction
    }()
    
    lazy var divider: UILabel = {
        let divider = UILabel()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.text = " - "
        divider.textColor = .gray
        return divider
    }()
    
    lazy var fileIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "folder-image")?.withRenderingMode(.alwaysOriginal)
        return image
    }()
    
    lazy var itemCellLayout: UIView = {
        let layout = UIView()
        layout.translatesAutoresizingMaskIntoConstraints = false
        layout.backgroundColor = .white
        layout.addSubview(fileButtonAction)
        layout.addSubview(fileIcon)
        // config file icon constraint
        fileIcon.widthAnchor.constraint(equalToConstant: Dimen.imageIconWidth).isActive = true
        fileIcon.heightAnchor.constraint(equalToConstant: Dimen.imageIconHeight).isActive = true
        fileIcon.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: Dimen.cellItemMargin.left).isActive = true
        fileIcon.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        // config button download action
        fileButtonAction.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        fileButtonAction.trailingAnchor.constraint(equalTo: layout.trailingAnchor).isActive = true
        fileButtonAction.widthAnchor.constraint(equalToConstant: Dimen.buttonIconWidth).isActive = true
        fileButtonAction.heightAnchor.constraint(equalToConstant: Dimen.buttonIconHeight).isActive = true
        // config content layout (title & information)
        let contentLayout = UIStackView()
        contentLayout.translatesAutoresizingMaskIntoConstraints = false
        contentLayout.axis = .vertical
        contentLayout.distribution = .fillEqually
        layout.addSubview(contentLayout)
        
        // config file information (size && date)
        let informationLayout = UIStackView()
        informationLayout.translatesAutoresizingMaskIntoConstraints = false
        informationLayout.axis = .horizontal
        // config file name
        informationLayout.addArrangedSubview(fileSize)
        informationLayout.addArrangedSubview(divider)// divider
        informationLayout.addArrangedSubview(fileDate)
        // config information layout constraint
        
        contentLayout.addArrangedSubview(fileName)
        contentLayout.addArrangedSubview(informationLayout)
        
        // config content layout constraint
        contentLayout.leadingAnchor.constraint(equalTo: fileIcon.trailingAnchor, constant: Dimen.cellItemMargin.left).isActive = true
        contentLayout.trailingAnchor.constraint(equalTo: fileButtonAction.leadingAnchor, constant: Dimen.cellItemMargin.right).isActive = true
        contentLayout.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        contentLayout.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return layout
    }()
    
    //MARK: - CONFIG CELL CONSTRAINT
    private func configItemCellConstraint(){
        itemCellLayout.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimen.cellItemMargin.left).isActive = true
        itemCellLayout.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Dimen.cellItemMargin.right).isActive = true
        itemCellLayout.heightAnchor.constraint(equalToConstant: 60).isActive = true
        itemCellLayout.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    // MARK: - SETUP ITEM CELL
    public static let identifier: String = "FileItemCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(itemCellLayout)
        configItemCellConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
