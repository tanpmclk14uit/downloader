//
//  PinterestLayoutDelegate.swift
//  downloader
//
//  Created by LAP14812 on 18/07/2022.
//

import UIKit

protocol PinterestLayoutCaculatorDelegate: AnyObject{
    func getNumberOfColumn() -> Int;
    
    func getHeightForImageAtIndexPath( indexPath: NSIndexPath, itemWidth: CGFloat) -> CGFloat;
}

