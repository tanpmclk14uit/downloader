//
//  ThumbnailImage.swift
//  downloader
//
//  Created by LAP14812 on 14/07/2022.
//

import UIKit
import AVFoundation

extension UIImage{
    public class func tempThumbnailImage(for fileItem: FileItem)-> UIImage? {
        var image: UIImage?
        if(fileItem.isDir){
            image = UIImage(named: "folder-image")
        }else{
            switch(fileItem.type.name){
            case FileTypeConstants.pdf().name:
                    image = UIImage(named: "pdf.thumb")
            case FileTypeConstants.image().name:
                image = UIImage(named: "image")
            case FileTypeConstants.audio().name:
                if(fileItem.url.pathExtension == "mp3"){
                    image = UIImage(named: "mp3.thumb")
                }
                image = UIImage(named: "music.thumb")
            case FileTypeConstants.video().name:
                image = UIImage(named: "video.thumb")
            case FileTypeConstants.zip().name:
                image = UIImage(named: "zip.thumb")
            case FileTypeConstants.text().name:
                if(fileItem.url.pathExtension == "html"){
                    image = UIImage(named: "html.thumb")
                }
                if(fileItem.url.pathExtension == "doc" || fileItem.url.pathExtension == "docx"){
                    image = UIImage(named: "doc.thumb")
                }
                image = UIImage(named: "text.thumb")
            default:
                image = UIImage(named: "unknown.thumb")
            }
        }
        return image
    }
    
    public class func thumbnailImage(for fileItem: FileItem, to pointSize: CGSize)-> UIImage? {
        let image = CacheThumbnailImage.getImageFromCacheOfURL(fileItem.url)
        if(image != nil && image!.size.height >= pointSize.height * UIScreen.main.scale )
        {
            return image
        }else{
            var image: UIImage?
            switch(fileItem.type.name){
            case FileTypeConstants.pdf().name:
                let thumbnailFromPDF = UIImage.thumbnailFromPdf(withUrl: fileItem.url, to: pointSize)
                if let thumbnailFromPDF = thumbnailFromPDF {
                    image = thumbnailFromPDF
                    CacheThumbnailImage.saveToCache(url: fileItem.url, uiImage: image)
                }else{
                    image = UIImage(named: "pdf.thumb")
                }
            case FileTypeConstants.image().name:
                image = UIImage.downsampleImage(imageAt: fileItem.url, to: pointSize)
                CacheThumbnailImage.saveToCache(url: fileItem.url, uiImage: image)
            case FileTypeConstants.video().name:
                let thumbnailFromVideo = UIImage.generateThumbnailFromVideo(path: fileItem.url)
                if let thumbnailFromVideo = thumbnailFromVideo {
                    image = thumbnailFromVideo
                    CacheThumbnailImage.saveToCache(url: fileItem.url, uiImage: image)
                }else{
                    image = UIImage(named: "video.thumb")
                }
            default:
                image = UIImage.tempThumbnailImage(for: fileItem)
            }
            return image
        }
    }
    
    public class func thumbnailFromPdf(withUrl url:URL, to pointSize: CGSize) -> UIImage? {
        guard let pdf = CGPDFDocument(url as CFURL),
            let page = pdf.page(at: 1)
            else {
                return nil
        }

        var pageRect = page.getBoxRect(.mediaBox)
        let pdfScale =  pointSize.width / pageRect.size.width
        pageRect.size = CGSize(width: pageRect.size.width*pdfScale, height: pageRect.size.height*pdfScale)
        pageRect.origin = .zero

        UIGraphicsBeginImageContext(pageRect.size)
        guard let context = UIGraphicsGetCurrentContext() else{
            return nil
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
        return image
    }
    
   public class func generateThumbnailFromVideo(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch{
            return nil
        }
    }
}
