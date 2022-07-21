//
//  PinterestLayoutDelegate.swift
//  downloader
//
//  Created by LAP14812 on 18/07/2022.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject{
    func getNumberOfColumn() -> Int;
    
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: NSIndexPath, itemWidth: CGFloat) -> CGFloat;
    
    func getHeightForImageAtIndexPath( indexPath: NSIndexPath, itemWidth: CGFloat) -> CGFloat;
}

