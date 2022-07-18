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
        
        image.image = UIImage(named: "folder-image")
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
        generateThumbnailRepresentations(url: fileItem.url)
    }
    
    private func generateThumbnailRepresentations(url: URL) {
        // Set up the parameters of the request.
        let size: CGSize = CGSize(width: Dimen.imageIconWidth , height: Dimen.imageIconHeight)
        let scale = UIScreen.main.scale
        // Create the thumbnail request.
        if #available(iOS 13.0, *) {
            let request = QLThumbnailGenerator.Request(fileAt: url,
                                                       size: size,
                                                       scale: scale,
                                                       representationTypes: .all)
            // Retrieve the singleton instance of the thumbnail generator and generate the thumbnails.
            let generator = QLThumbnailGenerator.shared
            generator.generateRepresentations(for: request) {[weak self] (thumbnail, type, error) in
                DispatchQueue.main.async {
                    if thumbnail == nil || error != nil {
                        if let fileItem = self?.fileItem {
                            self?.thumbnail.image = UIImage.thumbnailImage(for: fileItem)
                        }
                    } else {
                        self?.thumbnail.image = thumbnail?.uiImage
                    }
                }
            }
        }else{
            // handle for ios below ios 13
            thumbnail.image = UIImage.thumbnailImage(for: fileItem!)
        }
    }
    
}
