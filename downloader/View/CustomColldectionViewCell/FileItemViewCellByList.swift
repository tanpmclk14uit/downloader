//
//  FileItemViewCell.swift
//  downloader
//
//  Created by LAP14812 on 24/06/2022.
//

import UIKit
import QuickLook

class FileItemViewCellByList: UICollectionViewCell {
    //MARK: - CONFIG UI
    lazy var fileName: UILabel = {
        let downloadItemTitle = UILabel()
        downloadItemTitle.translatesAutoresizingMaskIntoConstraints = false
        downloadItemTitle.text = "File item title"
        downloadItemTitle.font = UIFont.systemFont(ofSize: DimenResource.itemTitleTextSize)
        return downloadItemTitle
    }()
    
    lazy var fileSize: UILabel = {
        let downloadItemStatus = UILabel()
        downloadItemStatus.translatesAutoresizingMaskIntoConstraints = false
        downloadItemStatus.text = "0 bytes"
        downloadItemStatus.textColor = .gray
        downloadItemStatus.font = UIFont.systemFont(ofSize: DimenResource.itemAdditionalContentTextSize)
        return downloadItemStatus
    }()
    
    lazy var fileDate: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = .gray
        lable.text = "0"
        lable.font = UIFont.systemFont(ofSize: DimenResource.itemAdditionalContentTextSize)
        return lable
    }()
    
    lazy var fileActionMenu: UIButton = {
        let downloadItemButtonAction = UIButton(type: .system)
        downloadItemButtonAction.translatesAutoresizingMaskIntoConstraints = false
        downloadItemButtonAction.setImage(UIImage(named: "menu"), for: .normal)
        return downloadItemButtonAction
    }()
    
    lazy var divider: UILabel = {
        let divider = UILabel()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.text = "-"
        divider.textColor = .gray
        return divider
    }()
    
    lazy var fileIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "folder-image")?.withRenderingMode(.alwaysOriginal)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var itemCellLayout: UIView = {
        let layout = UIView()
        layout.translatesAutoresizingMaskIntoConstraints = false
        layout.backgroundColor = .white
        layout.addSubview(fileActionMenu)
        layout.addSubview(fileIcon)
        // config file icon constraint
        fileIcon.widthAnchor.constraint(equalToConstant: DimenResource.imageIconWidth).isActive = true
        fileIcon.heightAnchor.constraint(equalToConstant: DimenResource.imageIconHeight).isActive = true
        fileIcon.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: DimenResource.cellItemMargin.left).isActive = true
        fileIcon.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        // config button download action
        fileActionMenu.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        fileActionMenu.trailingAnchor.constraint(equalTo: layout.trailingAnchor).isActive = true
        fileActionMenu.widthAnchor.constraint(equalToConstant: DimenResource.buttonIconWidth+20).isActive = true
        fileActionMenu.heightAnchor.constraint(equalTo: layout.heightAnchor).isActive = true
        // config content layout (title & information)
        let contentLayout = UIStackView()
        contentLayout.translatesAutoresizingMaskIntoConstraints = false
        contentLayout.axis = .vertical
        contentLayout.alignment = .leading
        contentLayout.distribution = .fillEqually
        layout.addSubview(contentLayout)
        
        // config file information (size && date)
        let informationLayout = UIStackView()
        informationLayout.translatesAutoresizingMaskIntoConstraints = false
        informationLayout.axis = .horizontal
        informationLayout.alignment = .center
        informationLayout.spacing = 5
        informationLayout.distribution = .fillProportionally
        // config file name
        informationLayout.addArrangedSubview(fileSize)
        informationLayout.addArrangedSubview(divider)// divider
        informationLayout.addArrangedSubview(fileDate)
        
        
        // config information layout constraint
        
        contentLayout.addArrangedSubview(fileName)
        contentLayout.addArrangedSubview(informationLayout)
        
        // config content layout constraint
        contentLayout.leadingAnchor.constraint(equalTo: fileIcon.trailingAnchor, constant: DimenResource.cellItemMargin.left).isActive = true
        contentLayout.trailingAnchor.constraint(equalTo: fileActionMenu.leadingAnchor, constant: DimenResource.cellItemMargin.right).isActive = true
        contentLayout.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        contentLayout.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return layout
    }()
    
    //MARK: - CONFIG CELL CONSTRAINT
    private func configItemCellConstraint(){
        itemCellLayout.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DimenResource.cellItemMargin.left).isActive = true
        itemCellLayout.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DimenResource.cellItemMargin.right).isActive = true
        itemCellLayout.heightAnchor.constraint(equalToConstant: 60).isActive = true
        itemCellLayout.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    // MARK: - INIT CELL
    public static let identifier: String = "FileItemCellByList"
    private var fileItem: FileItem?
    var delegate: FileCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(itemCellLayout)
        configItemCellConstraint()
        contentView.layoutIfNeeded()
        fileActionMenu.addTarget(self, action: #selector(onFileActionMenuClick), for: .touchUpInside)
    }
    
    @objc private func onFileActionMenuClick(){
        if let fileItem = fileItem {
            delegate?.menuActionClick(fileItem: fileItem)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellData(fileItem: FileItem){
        self.fileItem = fileItem
        self.fileName.text = fileItem.name
        if(fileItem.isDir){
            self.fileSize.text = "\(fileItem.size) item(s)"
        }else{
            self.fileSize.text = FileSizeUnits(bytes: Int64(truncating: fileItem.size)).getReadableUnit()
        }
        
        self.fileDate.text = TimeUnitsConvertor(withSeconds: Int64(fileItem.countDaysFromCreatedToNow())).getReadableTimeUnit()
        
        ThumbnailManager.getInstance().gernerateThumbnail(for: fileItem, to: fileIcon.bounds.size) { image in
            DispatchQueue.main.async { [weak self] in
                if(fileItem.url == self?.fileItem?.url){
                    self?.fileIcon.image = image
                }
            }
        } onPlaceViewHolder: { image in
            if(fileItem.url == self.fileItem?.url){
                self.fileIcon.image = image
            }
        }
    }
    
    func hideItemAction(){
        fileActionMenu.isHidden = true
    }
}
