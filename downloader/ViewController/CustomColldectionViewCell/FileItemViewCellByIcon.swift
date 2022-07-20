//
//  FileItemViewCellByIcon.swift
//  downloader
//
//  Created by LAP14812 on 05/07/2022.
//

import UIKit
import QuickLook

class FileItemViewCellByIcon: UICollectionViewCell {
    //MARK: - CONFIG UI VIEW
    lazy var thumbnail: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "image")
        return image
    }()
    
    private lazy var fileName: UILabel = {
        let downloadItemTitle = UILabel()
        downloadItemTitle.translatesAutoresizingMaskIntoConstraints = false
        downloadItemTitle.text = "File item title"
        downloadItemTitle.font = UIFont.systemFont(ofSize: DimenResource.itemTitleTextSize)
        downloadItemTitle.textAlignment = .center
        downloadItemTitle.numberOfLines = 1
        return downloadItemTitle
    }()
    
    private lazy var fileSize: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "0 bytes"
        lable.textColor = .gray
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: DimenResource.itemAdditionalContentTextSize)
        return lable
    }()
    
    private lazy var fileActionMenu: UIButton = {
        let downloadItemButtonAction = UIButton(type: .system)
        downloadItemButtonAction.translatesAutoresizingMaskIntoConstraints = false
        downloadItemButtonAction.setImage(UIImage(named: "menu"), for: .normal)
        return downloadItemButtonAction
    }()
    
    private lazy var fileTypeIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    //MARK: - CONFIG UI CONSTRAINT
    private func configThumbnailConstraint(){
        thumbnail.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        thumbnail.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        thumbnail.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        thumbnail.heightAnchor.constraint(equalTo: thumbnail.widthAnchor).isActive = true
    }
    private func configFileNameConstraint(){
        fileName.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: DimenResource.cellItemByIconMargin.top).isActive = true
        fileName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        fileName.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        let fileNameWidth = contentView.frame.width
        let fileNameHeight = fileName.text?.height(withConstrainedWidth: fileNameWidth, font: fileName.font)
        let singleLineHeight = DimenResource.getFontHeight(font: fileName.font)
        if var fileNameHeight = fileNameHeight {
            switch(fileNameHeight){
            case singleLineHeight...2*singleLineHeight:
                fileName.numberOfLines = 2
                break
            case 2*singleLineHeight...CGFloat.infinity:
                fileNameHeight = 2*singleLineHeight
                fileName.numberOfLines = 2
                break
            default:
                fileName.numberOfLines = 1
                break
            }
        }
    }
    
    private func configFileSizeConstraint(){
        fileSize.topAnchor.constraint(equalTo: fileName.bottomAnchor, constant: DimenResource.cellItemByIconMargin.top).isActive = true
        fileSize.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        fileSize.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        fileSize.heightAnchor.constraint(equalToConstant: (fileSize.text?.height(withConstrainedWidth: contentView.frame.width, font: fileSize.font))!).isActive = true
        
    }
    
    private func configFileButtonActionConstraint(){
        fileActionMenu.topAnchor.constraint(equalTo: fileSize.bottomAnchor, constant: DimenResource.cellItemByIconMargin.top).isActive = true
        fileActionMenu.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        fileActionMenu.widthAnchor.constraint(equalToConstant: DimenResource.buttonIconWidth).isActive = true
        fileActionMenu.heightAnchor.constraint(equalToConstant: DimenResource.buttonIconHeight).isActive = true
    }
    private func configFileTypeIconConstraint(){
        fileTypeIcon.bottomAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: DimenResource.cellItemByIconMargin.bottom).isActive = true
        fileTypeIcon.trailingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: DimenResource.cellItemByIconMargin.right).isActive = true
        fileTypeIcon.heightAnchor.constraint(equalToConstant: DimenResource.imageTinyIconHeight).isActive = true
        fileTypeIcon.widthAnchor.constraint(equalToConstant: DimenResource.imageTinyIconWidth).isActive = true
    }
    //MARK: - INIT CELL
    public static let identifier: String = "FileItemCellByIcon"
    private var fileItem: FileItem?
    var delegate: FileCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(thumbnail)
        configThumbnailConstraint()
        contentView.addSubview(fileName)
        configFileNameConstraint()
        contentView.addSubview(fileSize)
        configFileSizeConstraint()
        contentView.addSubview(fileActionMenu)
        configFileButtonActionConstraint()
        contentView.addSubview(fileTypeIcon)
        configFileTypeIconConstraint()
        
        contentView.layoutIfNeeded()
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
        if(fileItem.isDir){
            self.fileSize.text = "\(fileItem.size) item(s)"
            self.fileTypeIcon.image = UIImage(named: "folder-image")
        }else{
            self.fileSize.text = FileSizeUnits(bytes: Int64(truncating: fileItem.size)).getReadableUnit()
            drawIconFromFileType(fileType: fileItem.type)
        }
        
        ThumbnailManager.getInstance().gernerateThumbnail(for: fileItem, to: thumbnail.bounds.size) { image in
            DispatchQueue.main.async { [weak self] in
                if(fileItem.url == self?.fileItem?.url){
                    self?.thumbnail.image = image
                }
            }
        } onPlaceViewHolder: { image in
            if(fileItem.url == self.fileItem?.url){
                self.thumbnail.image = image
            }
        }
    }

    func drawIconFromFileType(fileType: FileTypeEnum){
        switch(fileType.name){
        case FileTypeConstants.pdf().name:
            fileTypeIcon.image = UIImage(named: "pdf")
            break
        case FileTypeConstants.image().name:
            fileTypeIcon.image = UIImage(named: "image")
            break
        case FileTypeConstants.audio().name:
            fileTypeIcon.image = UIImage(named: "audio")
            break
        case FileTypeConstants.video().name:
            fileTypeIcon.image = UIImage(named: "video")
            break
        case FileTypeConstants.zip().name:
            fileTypeIcon.image = UIImage(named: "zip")
            break
        case FileTypeConstants.text().name:
            fileTypeIcon.image = UIImage(named: "text")
            break
        default:
            fileTypeIcon.image = UIImage(named: "unknown")
            break
        }
    }
}
