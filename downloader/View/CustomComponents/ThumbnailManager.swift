//
//  ThumbnailManager.swift
//  downloader
//
//  Created by LAP14812 on 20/07/2022.
//

import UIKit
import AVFoundation

class ThumbnailManager {
    private static var shareInstance: ThumbnailManager?;
    
    public static func getInstance() -> ThumbnailManager{
        if(shareInstance == nil){
            shareInstance = ThumbnailManager()
        }
        return shareInstance!
    }
    
    private init(){
        
    }
    
    public func gernerateThumbnail(for fileItem: FileItem,
                                   to size: CGSize,
                                   onComplete: @escaping (UIImage?) -> Void,
                                   onPlaceViewHolder: (UIImage?) -> Void)
    {
        // check if file type is neither image nor  video nor pdf
        // (orther type dont need to generate thumbnail
        let defauleImage = getDefaultThumbnail(for: fileItem)
        if(fileItem.type.name != FileTypeConstants.image().name &&
           fileItem.type.name != FileTypeConstants.video().name &&
           fileItem.type.name != FileTypeConstants.pdf().name
        ){
            // use default thumbnail
            onComplete(defauleImage)
        }else{
            if let cacheImage = CacheThumbnailImage.shareInstance().getImageFromCacheOfURL(fileItem.url){
                // check cache image fit size
                if cacheImage.size.height >= (size.height*UIScreen.main.scale) {
                    // choose cache as thumbnail
                    onComplete(cacheImage)
                    return
                }else{
                    // set cache as place holder
                    onPlaceViewHolder(cacheImage)
                }
            }else{
                // set default image as place holder
                onPlaceViewHolder(defauleImage)
            }
            //gernerate thumb
            switch(fileItem.type.name){
            case FileTypeConstants.video().name:
                onComplete(generateThumbnailFromVideo(withURL: fileItem.url))
            case FileTypeConstants.image().name:
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.generateThumbnailFromImage(withURL: fileItem.url, to: size, defaultImage: defauleImage, onComplete: onComplete)
                }
            case FileTypeConstants.pdf().name:
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.thumbnailFromPdf(withUrl: fileItem.url, to: size, defaultImage: defauleImage, onComplete: onComplete)
                }
            default:
                onComplete(defauleImage)
            }
        }
        
    }
    
    
    private func getDefaultThumbnail(for fileItem: FileItem) -> UIImage?{
        var image: UIImage?
        if(fileItem.isDir){
            image = UIImage(named: "folder-image")
        }else{
            switch(fileItem.type.name){
            case FileTypeConstants.pdf().name:
                image = UIImage(named: "pdfthumb")
            case FileTypeConstants.image().name:
                image = UIImage(named: "image")
            case FileTypeConstants.audio().name:
                if(fileItem.url.pathExtension == "mp3"){
                    image = UIImage(named: "mp3thumb")
                }else{
                    image = UIImage(named: "musicthumb")
                }
            case FileTypeConstants.video().name:
                image = UIImage(named: "videothumb")
            case FileTypeConstants.zip().name:
                image = UIImage(named: "zipthumb")
            case FileTypeConstants.text().name:
                if(fileItem.url.pathExtension == "html"){
                    image = UIImage(named: "htmlthumb")
                }
                if(fileItem.url.pathExtension == "doc" || fileItem.url.pathExtension == "docx"){
                    image = UIImage(named: "docthumb")
                }
                image = UIImage(named: "textthumb")
            default:
                image = UIImage(named: "unknownthumb")
            }
        }
        return image
    }
    
    private func thumbnailFromPdf(withUrl url:URL,
                                 to pointSize: CGSize,
                                 defaultImage: UIImage?,
                                 onComplete: @escaping (UIImage?) -> Void) {
        guard let pdf = CGPDFDocument(url as CFURL),
              let page = pdf.page(at: 1)
        else {
            onComplete(defaultImage)
            return
        }
        
        var pageRect = page.getBoxRect(.mediaBox)
        let pdfScale =  pointSize.width / pageRect.size.width
        pageRect.size = CGSize(width: pageRect.size.width*pdfScale, height: pageRect.size.height*pdfScale)
        pageRect.origin = .zero
        
        UIGraphicsBeginImageContext(pageRect.size)
        guard let context = UIGraphicsGetCurrentContext() else{
            onComplete(defaultImage)
            return
        }
        
        // White BG
        context.setFillColor(UIColor.white.cgColor)
        context.fill(pageRect)
        context.saveGState()
        
        // Next 3 lines makes the rotations so that the page look in the right direction
        context.translateBy(x: 0.0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.concatenate(page.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
        
        context.drawPDFPage(page)
        context.restoreGState()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        CacheThumbnailImage.shareInstance().saveToCache(url: url, uiImage: image)
        onComplete(image)
        
    }
    
    private func generateThumbnailFromVideo(withURL: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: withURL, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            CacheThumbnailImage.shareInstance().saveToCache(url: withURL, uiImage: thumbnail)
            return thumbnail
        } catch{
            return nil
        }
    }
    
    private func generateThumbnailFromImage(withURL: URL,
                                           to pointSize: CGSize,
                                           defaultImage: UIImage?,
                                           scale: CGFloat = UIScreen.main.scale,
                                           onComplete: @escaping (UIImage?) -> Void){
        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(withURL as CFURL, imageSourceOptions) else {
            onComplete(defaultImage)
            return
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
            onComplete(defaultImage)
            return
        }
        
        // Return the downsampled image as UIImage
        let imageData = UIImage(cgImage: downsampledImage).jpegData(compressionQuality: 0.5)
        guard let imageData = imageData else{
            onComplete(defaultImage)
            return
        }
        let image = UIImage(data: imageData)
        onComplete(image)
        CacheThumbnailImage.shareInstance().saveToCache(url: withURL, uiImage: image)
    }
    
}
