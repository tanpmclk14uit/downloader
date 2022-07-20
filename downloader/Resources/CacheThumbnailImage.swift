//
//  CacheThumbnailImage.swift
//  downloader
//
//  Created by LAP14812 on 19/07/2022.
//

import UIKit

class CacheThumbnailImage{
    private static var cacheThumb: NSMapTable = NSMapTable<NSURL, UIImage>()
    
    private static var firstURL: URL?
    
    public static func getImageFromCacheOfURL(_ url: URL) -> UIImage?{
        return cacheThumb.object(forKey: url as NSURL)
    }
    
    public static func saveToCache(url: URL, uiImage: UIImage?){
        if(cacheThumb.count > 50){
            cacheThumb.removeAllObjects()
        }
        cacheThumb.setObject(uiImage, forKey: url as NSURL)
    }
    
    public static func isEmpty() -> Bool{
        return cacheThumb.count == 0
    }
    
    
}
