//
//  CacheThumbnailImage.swift
//  downloader
//
//  Created by LAP14812 on 19/07/2022.
//

import UIKit

class CacheThumbnailImage{
    
    private static var instance: CacheThumbnailImage?
    private let cacheThumb: NSCache = NSCache<NSURL, UIImage>()
    
    private init(){
        cacheThumb.countLimit = 100
    }
    
    public static func shareInstance() -> CacheThumbnailImage{
        if(instance == nil){
            instance = CacheThumbnailImage()
        }
        return instance!
    }
    
    public func getImageFromCacheOfURL(_ url: URL) -> UIImage?{
        return cacheThumb.object(forKey: url as NSURL)
    }
    
    public func saveToCache(url: URL, uiImage: UIImage?){
        cacheThumb.setObject(uiImage! as UIImage, forKey: url as NSURL)
    }
    
    public func removeFromCache(url: URL){
        cacheThumb.removeObject(forKey: url as NSURL)
    }
    
    
}
