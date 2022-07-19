//
//  CacheThumbnailImage.swift
//  downloader
//
//  Created by LAP14812 on 19/07/2022.
//

import UIKit

class CacheThumbnailImage{
    private static var cacheThumb: NSMapTable = NSMapTable<NSURL, UIImage>()
    
    public static func getImageFromCacheOfURL(_ url: URL) -> UIImage?{
        return cacheThumb.object(forKey: url as NSURL)
    }
    
    public static func saveToCache(url: URL, uiImage: UIImage?){
        cacheThumb.setObject(uiImage, forKey: url as NSURL)
    }
    
    public static func isEmpty() -> Bool{
        return cacheThumb.count == 0
    }
    
    
}
