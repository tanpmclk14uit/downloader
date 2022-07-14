//
//  ThumbnailImage.swift
//  downloader
//
//  Created by LAP14812 on 14/07/2022.
//

import UIKit

extension UIImage{
    public class func thumbnailImage(for fileItem: FileItem)-> UIImage? {
        if(fileItem.isDir){
            return UIImage(named: "folder-image")
        }else{
            switch(fileItem.type.name){
            case FileTypeConstants.pdf().name:
                return UIImage(named: "pdf.thumb")
            case FileTypeConstants.image().name:
                return UIImage(named: "image.thumb")
            case FileTypeConstants.audio().name:
                if(fileItem.url.pathExtension == "mp3"){
                    return UIImage(named: "mp3.thumb")
                }
                return UIImage(named: "music.thumb")
            case FileTypeConstants.video().name:
                return UIImage(named: "video.thumb")
            case FileTypeConstants.zip().name:
                return UIImage(named: "zip.thumb")
            case FileTypeConstants.text().name:
                if(fileItem.url.pathExtension == "html"){
                    return UIImage(named: "html.thumb")
                }
                if(fileItem.url.pathExtension == "doc" || fileItem.url.pathExtension == "docx"){
                    return UIImage(named: "doc.thumb")
                }
                return UIImage(named: "text.thumb")
            default:
                return UIImage(named: "unknown.thumb")
            }
        }
    }
}
