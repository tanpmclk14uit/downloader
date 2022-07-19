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
    
    //MARK: - CONFIG UI CONSTRAINT
    private func configThumbnailConstraint(){
        thumbnail.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        thumbnail.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        thumbnail.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        thumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    //MARK: - INIT CELL
    public static let identifier: String = "PinterestViewCell"
    private var fileItem: FileItem?
    var delegate: FileCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(thumbnail)
        configThumbnailConstraint()

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
        self.thumbnail.image = CacheThumbnailImage.getImageFromCacheOfURL(fileItem.url)
        setThumbnai()
    }
    
    func setThumbnai(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            [weak self] in
                if let self = self{
                    let newTumbnailImage = UIImage.thumbnailImage(for: self.fileItem!, to: self.thumbnail.bounds.size)
                    if(self.thumbnail.image != newTumbnailImage){
                        self.thumbnail.image = newTumbnailImage
                    }
                }
        })
    }
    
}
