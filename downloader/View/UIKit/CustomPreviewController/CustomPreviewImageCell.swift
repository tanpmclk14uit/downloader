//
//  PreviewImageCell.swift
//  downloader
//
//  Created by LAP14812 on 12/08/2022.
//

import UIKit

protocol CustomPreviewImageCellDelegate{
    func setZoomState(isInZoomState: Bool)
}

class CustomPreviewImageCell: UICollectionViewCell {
    //MARK: - Config UI
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
    
    private lazy var scrollViewToZoom: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.maximumZoomScale = maximumZoomScale
        scrollView.minimumZoomScale = 1
        scrollView.delegate = self
        scrollView.bounces = false
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapImageToScale))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        return scrollView
    }()
    
    //MARK: - Config UI Constraint
    private func configScrollViewToZoomConstraint(){
        scrollViewToZoom.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollViewToZoom.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollViewToZoom.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        scrollViewToZoom.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func configImageViewConstraint(){
        imageView.leadingAnchor.constraint(equalTo: scrollViewToZoom.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollViewToZoom.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: scrollViewToZoom.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollViewToZoom.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }
    //MARK: - Set up Cell
    public static let identifier: String = "PreviewImageCell"
    public var imageSize: CGSize = CGSize(width: 0, height: 0)
    private let maximumZoomScale = 4.0
    var delegate: CustomPreviewImageCellDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(scrollViewToZoom)
        configScrollViewToZoomConstraint()
        
        scrollViewToZoom.addSubview(imageView)
        configImageViewConstraint()
    }
    
    @objc private func onDoubleTapImageToScale(sender: UITapGestureRecognizer){
        let scale = scrollViewToZoom.zoomScale * 2
        if scale <= scrollViewToZoom.maximumZoomScale{// zoom in
            let point = sender.location(in: imageView)
            let scrollSize = scrollViewToZoom.frame.size
            let size = CGSize(width: scrollSize.width / scale,
                              height: scrollSize.height / scale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            scrollViewToZoom.zoom(to:CGRect(origin: origin, size: size), animated: true)
        } else { // zoom out
            scrollViewToZoom.setZoomScale(1.0, animated: true)
        }
    }
    
    override func prepareForReuse() {
        resetZoomScale()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetZoomScale(){
        scrollViewToZoom.zoomScale = 1
    }
    
    func setImageDataByImageURL(_ url: URL){
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
                                let optimizeImage = self.getAndOptimizeImage(withURL: url, to: self.imageSize, scale: self.maximumZoomScale)
                                
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

// MARK: - Confirm UI Scroll View Delegate
extension CustomPreviewImageCell: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if(scrollView.zoomScale == 1){
            // exit zoom mode
            delegate?.setZoomState(isInZoomState: false)
        }else{
            // enter zoom mode
            delegate?.setZoomState(isInZoomState: true)
        }
        
        if(scrollView.zoomScale >= 1){
            if let image = imageView.image{
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                let left = 0.5  * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                
                let conditionTop = newHeight*scrollView.zoomScale > imageView.frame.height
                
                let top = 0.5 * (conditionTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        }
    }
}
