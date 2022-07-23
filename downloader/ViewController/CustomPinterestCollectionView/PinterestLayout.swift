//
//  PinterestLayout.swift
//  downloader
//
//  Created by LAP14812 on 18/07/2022.
//

import UIKit

class PinterestLayout: MaintainOffsetFlowLayout {
    
    
    override func prepare() {
        super.prepare()
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        if let caculator = caculator{
            for i in 0...caculator.getCacheCount()-1{
                let attributes = caculator.getCacheByIndex(index: i)
                if(attributes.frame.intersects(rect)){
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }
        return visibleLayoutAttributes
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            if indexPath.isEmpty { return nil }
            guard let caculator = caculator else {
                return nil
            }
            if(indexPath.row < caculator.getCacheCount()){
                return caculator.getCacheByIndex(index: indexPath.item)
            }else{
                return nil
            }
    }
    
    override var collectionViewContentSize: CGSize{
        return caculator!.contentSize
    }
    
    override func prepareForTransition(from oldLayout: UICollectionViewLayout) {
        super.prepareForTransition(from: oldLayout)
    }
}
