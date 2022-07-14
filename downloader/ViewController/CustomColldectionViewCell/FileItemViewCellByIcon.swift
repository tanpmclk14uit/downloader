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
        image.image = UIImage(named: "folder-image")
        return image
    }()
    
    private lazy var fileName: UILabel = {
        let downloadItemTitle = UILabel()
        downloadItemTitle.translatesAutoresizingMaskIntoConstraints = false
        downloadItemTitle.text = "File item title"
        downloadItemTitle.font = UIFont.systemFont(ofSize: Dimen.itemTitleTextSize)
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
        lable.font = UIFont.systemFont(ofSize: Dimen.itemAdditionalContentTextSize)
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
        fileName.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: Dimen.cellItemByIconMargin.top).isActive = true
        fileName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        fileName.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        let fileNameWidth = contentView.frame.width
        let fileNameHeight = fileName.text?.height(withConstrainedWidth: fileNameWidth, font: fileName.font)
        let singleLineHeight = Dimen.getFontHeight(font: fileName.font)
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
        fileSize.topAnchor.constraint(equalTo: fileName.bottomAnchor, constant: Dimen.cellItemByIconMargin.top).isActive = true
        fileSize.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        fileSize.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        fileSize.heightAnchor.constraint(equalToConstant: (fileSize.text?.height(withConstrainedWidth: contentView.frame.width, font: fileSize.font))!).isActive = true
        
    }
    
    private func configFileButtonActionConstraint(){
        fileActionMenu.topAnchor.constraint(equalTo: fileSize.bottomAnchor, constant: Dimen.cellItemByIconMargin.top).isActive = true
        fileActionMenu.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        fileActionMenu.widthAnchor.constraint(equalToConstant: Dimen.buttonIconWidth).isActive = true
        fileActionMenu.heightAnchor.constraint(equalToConstant: Dimen.buttonIconHeight).isActive = true
    }
    private func configFileTypeIconConstraint(){
        fileTypeIcon.bottomAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: Dimen.cellItemByIconMargin.bottom).isActive = true
        fileTypeIcon.trailingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: Dimen.cellItemByIconMargin.right).isActive = true
        fileTypeIcon.heightAnchor.constraint(equalToConstant: Dimen.imageTinyIconHeight).isActive = true
        fileTypeIcon.widthAnchor.constraint(equalToConstant: Dimen.imageTinyIconWidth).isActive = true
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
                            if(fileItem.isDir){
                                self?.thumbnail.image = UIImage(named: "folder-image")
                            }else{
                                self?.thumbnail.image = UIImage(named: "file")
                            }
                        }
                    } else {
                        self?.thumbnail.image = thumbnail?.uiImage
                    }
                }
            }
        }else{
            // handle for ios below ios 13
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
