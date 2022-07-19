//
//  PinterestViewCell.swift
//  downloader
//
//  Created by LAP14812 on 18/07/2022.
//

import UIKit
import QuickLook

class PinterestViewCell: UICollectionViewCell {
    //MARK: - CONFIG UI VIEW
    lazy var thumbnail: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "image")
        return image
    }()
    
    private lazy var fileName: UILabel = {
        let downloadItemTitle = UILabel()
        downloadItemTitle.translatesAutoresizingMaskIntoConstraints = false
        downloadItemTitle.text = "File item title"
        downloadItemTitle.font = UIFont.systemFont(ofSize: Dimen.itemTitleTextSize)
        downloadItemTitle.textAlignment = .left
        downloadItemTitle.numberOfLines = 1
        return downloadItemTitle
    }()
    
    private lazy var fileActionMenu: UIButton = {
        let downloadItemButtonAction = UIButton(type: .system)
        downloadItemButtonAction.translatesAutoresizingMaskIntoConstraints = false
        downloadItemButtonAction.setImage(UIImage(named: "menu"), for: .normal)
        return downloadItemButtonAction
    }()
    
    //MARK: - CONFIG UI CONSTRAINT
    private func configThumbnailConstraint(){
        thumbnail.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        thumbnail.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        thumbnail.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        thumbnail.bottomAnchor.constraint(equalTo: fileName.topAnchor).isActive = true
    }
    
    private func configFileNameConstraint(){
        fileName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        fileName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimen.cellItemByIconMargin.left).isActive = true
        fileName.trailingAnchor.constraint(equalTo: fileActionMenu.leadingAnchor, constant: Dimen.cellItemByIconMargin.right).isActive = true
        fileName.heightAnchor.constraint(equalToConstant: Dimen.pinterestContentMaxHeight).isActive = true
    }
    
    private func configFileButtonActionConstraint(){
        fileActionMenu.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        fileActionMenu.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Dimen.cellItemByIconMargin.right).isActive = true
        fileActionMenu.widthAnchor.constraint(equalToConstant: Dimen.buttonIconWidth).isActive = true
        fileActionMenu.heightAnchor.constraint(equalToConstant: Dimen.pinterestContentMaxHeight).isActive = true
    }
    
    //MARK: - INIT CELL
    public static let identifier: String = "PinterestViewCell"
    private var fileItem: FileItem?
    var delegate: FileCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(fileActionMenu)
        configFileButtonActionConstraint()
        
        contentView.addSubview(fileName)
        configFileNameConstraint()
        
        contentView.addSubview(thumbnail)
        configThumbnailConstraint()
        
        self.fileActionMenu.addTarget(self, action: #selector(onFileActionMenuClick), for: .touchUpInside)
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
        DispatchQueue.main.async { [weak self] in
            if let self = self{
                self.thumbnail.image = UIImage.thumbnailImage(for: fileItem, to: self.thumbnail.bounds.size)
            }
        }
    }
    
}
