//
//  PreviewImageCell.swift
//  downloader
//
//  Created by LAP14812 on 12/08/2022.
//

import UIKit

class PreviewImageCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var errorMessage: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Load image failed"
        lable.textColor = .gray
        lable.textAlignment = .center
        lable.numberOfLines = 2
        return lable
    }()
    
    private func configImageViewConstraint(){
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        imageView.widthAnchor.constraint(equalToConstant: contentView.bounds.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: contentView.bounds.height).isActive = true
    }
    
    public static let identifier: String = "PreviewImageCell"
    public var imageSize: CGSize = CGSize(width: 0, height: 0)
    public var currentItem: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        configImageViewConstraint()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImageDataByImageURL(_ url: URL){
        self.currentItem = url
        DispatchQueue.global().async { [weak self] in
            if let self = self{
                do{
                    let image = try UIImage(data: Data(contentsOf: url))
                    if let image = image {
                        DispatchQueue.main.async { [self] in
                            let imageRatio = image.size.width / image.size.height
                            let imageWidth = self.contentView.bounds.width
                            let imageHeight = imageWidth/imageRatio
                            DispatchQueue.global().async {
                                self.imageSize = CGSize(width: imageWidth, height: imageHeight)
                                let optimizeImage = self.getAndOptimizeImage(withURL: url, to: self.imageSize)
                                
                                DispatchQueue.main.async {
                                    self.imageView.image = optimizeImage
                                }
                                
                            }
                        }
                    }
                }catch{
                    DispatchQueue.main.async {
                        self.showErrorMessage()
                    }
                }
            }
        }
    }

    private func getAndOptimizeImage(withURL: URL,
                               to pointSize: CGSize,
                               scale: CGFloat = UIScreen.main.scale) -> UIImage?{
        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(withURL as CFURL, imageSourceOptions) else {
            return nil
        }
        
        // Calculate the desired dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        
        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        // Return the downsampled image as UIImage
        let imageData = UIImage(cgImage: downsampledImage).jpegData(compressionQuality: 0.5)
        guard let imageData = imageData else{
            return nil
        }
        return UIImage(data: imageData)
    }
    
    
    private func showErrorMessage(){
        imageView.isHidden = true
        contentView.addSubview(errorMessage)
        
        errorMessage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        errorMessage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    
}
