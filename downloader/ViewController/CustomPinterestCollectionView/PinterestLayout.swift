//
//  PinterestLayout.swift
//  downloader
//
//  Created by LAP14812 on 18/07/2022.
//

import UIKit

class PinterestLayout: MaintainOffsetFlowLayout {
    weak var delegate: PinterestLayoutDelegate?
    private var contentSize: CGSize = CGSize(width: 0, height: 0)
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var cellPading: CGFloat = 10
    
    override func prepare() {
        super.prepare()
        guard cache.isEmpty, let collectionView = collectionView else{
            return
        }
        if let delegate = delegate {
            let numberOfColumn: Int = delegate.getNumberOfColumn();
            let collectionViewWidth = collectionView.frame.size.width
            let itemWidth: CGFloat = (collectionViewWidth - cellPading*CGFloat(numberOfColumn+1))/CGFloat(numberOfColumn)
            var contentHeight: CGFloat = 0.0;
            var heightOfColumns = [CGFloat](repeating: 0.0, count: numberOfColumn)
            for i in 0 ... (collectionView.numberOfItems(inSection: 0)-1){
                var tempX : CGFloat = 0.0
                var tempY : CGFloat = 0.0
                let indexPath = NSIndexPath(item: i, section: 0)
                
                let itemHeight = delegate.collectionView(collectionView: collectionView, heightForImageAtIndexPath: indexPath, itemWidth: itemWidth) + Dimen.pinterestContentMaxHeight
                let shortestHeightColumn = getShortestHeightColumn(heightOfColumns)
                let shortestHeight = heightOfColumns[shortestHeightColumn];
                
                tempX = cellPading + (itemWidth + cellPading) *  CGFloat(shortestHeightColumn);
                tempY = shortestHeight + cellPading
                heightOfColumns[shortestHeightColumn] = tempY + itemHeight;
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)
                attributes.frame = CGRect(x: tempX, y: tempY, width: itemWidth, height: itemHeight)
                cache.append(attributes)
                
                let newContentHeight:CGFloat = tempY + cellPading + itemHeight + cellPading;
                   if (newContentHeight > contentHeight){
                       contentHeight = newContentHeight;
                   }
                
                self.contentSize = CGSize(width: collectionViewWidth, height: contentHeight)
            }
            
        }
    }
    
    func clearCache(){
        cache.removeAll()
    }
    
    func getShortestHeightColumn(_ heightOfColumns: [CGFloat])-> Int{
        var minHeight: CGFloat = 0.0
        var minIndex: Int = 0;
        
        if heightOfColumns.count > 0 {
            minHeight = heightOfColumns[0]
        }
        for colIndex in 0 ..< heightOfColumns.count {
            if (minHeight > heightOfColumns[colIndex]){
                minHeight = heightOfColumns[colIndex]
                minIndex = colIndex
            }
        }
        return minIndex
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
          for attributes in cache {
            if attributes.frame.intersects(rect) {
              visibleLayoutAttributes.append(attributes)
            }
          }
          return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
      return cache[indexPath.item]
    }
    
    override var collectionViewContentSize: CGSize{
        return self.contentSize
    }
}
