//
//  ThumbnailImage.swift
//  downloader
//
//  Created by LAP14812 on 14/07/2022.
//

import UIKit

extension UIImage{
    public class func thumbnailImage(for fileItem: FileItem, to pointSize: CGSize)-> UIImage? {
        if let image = CacheThumbnailImage.getImageFromCacheOfURL(fileItem.url){
            return image
        }else{
            var image: UIImage?
            if(fileItem.isDir){
                image = UIImage(named: "folder-image")
            }else{
                switch(fileItem.type.name){
                case FileTypeConstants.pdf().name:
                    image = UIImage(named: "pdf.thumb")
                case FileTypeConstants.image().name:
                    image = UIImage.downsampleImage(imageAt: fileItem.url, to: pointSize)
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
            CacheThumbnailImage.saveToCache(url: fileItem.url, uiImage: image)
            return image
        }
    }
}
