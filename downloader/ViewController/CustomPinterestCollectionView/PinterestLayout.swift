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
    private var cache: [PinterestLayoutAttributes] = []
    private var cellPading: CGFloat = 10
    private var collectionViewWidth: CGFloat = 0
    private var itemCount = 0
    var hightestIndex = 0
    private let range = 40;
    private var contentHeight: CGFloat = 0
    private var numberOfColumn: Int = 0
    private var heightOfColumns: [CGFloat] = []
    private let heightOfColumnsQueue = DispatchQueue(label: "heightOfColumnsThreadSafe")
    private let cacheSafeQueue = DispatchQueue(label: "cacheSafeQueue")
    private var curentCaculteProgress: DispatchWorkItem? = nil
    private var cacheClear: Bool = false
    
    
    
    override func prepare() {
        super.prepare()
        guard getCacheCount() == 0, let collectionView = collectionView else{
            return
        }
        contentHeight = 0.0
        hightestIndex = 0
        contentSize = CGSize(width: 0, height: 0)
        collectionViewWidth = collectionView.frame.size.width
        itemCount = collectionView.numberOfItems(inSection: 0)
        cacheClear = false
        if let delegate = delegate {
            let numberOfColumn: Int = delegate.getNumberOfColumn()
            heightOfColumns = [CGFloat](repeating: 0.0, count: numberOfColumn)
        }
        caculateAtributeForItem(from: 0, to: range/2)
    }
    
    func caculateAtributeForItem(from: Int, to: Int){
        let low = max(0, from)
        let high = min(to, itemCount - 1)
        guard low < high else{
            return
        }
        hightestIndex = high
        if let delegate = delegate {
            let numberOfColumn: Int = delegate.getNumberOfColumn();
            let itemWidth: CGFloat = (collectionViewWidth - cellPading*CGFloat(numberOfColumn+1))/CGFloat(numberOfColumn)
            
            for i in from ... high{
                if(cacheClear){
                    clearCache()
                    return
                }
                var tempX : CGFloat = 0.0
                var tempY : CGFloat = 0.0
            
                let indexPath = NSIndexPath(item: i, section: 0)
                let itemHeight = delegate.getHeightForImageAtIndexPath(indexPath: indexPath, itemWidth: itemWidth)
                let shortestHeightColumn = self.getShortestHeightColumn(heightOfColumns)
                let shortestHeight = getHeighOfColumn(from: shortestHeightColumn)
                
                tempX = self.cellPading + (itemWidth + self.cellPading) *  CGFloat(shortestHeightColumn);
                tempY = shortestHeight + self.cellPading
                setHeightOfColum(of: shortestHeightColumn, to: tempY + itemHeight)
                let attributes = PinterestLayoutAttributes(forCellWith: indexPath as IndexPath)
                attributes.column = shortestHeightColumn
                attributes.frame = CGRect(x: tempX, y: tempY, width: itemWidth, height: itemHeight)
                cacheSafeQueue.async {[weak self] in
                    self?.cache.append(attributes)
                }
                
                let newContentHeight:CGFloat = tempY + self.cellPading + itemHeight + self.cellPading;
                if (newContentHeight > contentHeight){
                    contentHeight = newContentHeight;
                }
                self.contentSize = CGSize(width: collectionViewWidth, height: contentHeight)
            }
        }
    }
    
    func clearCache(){
        cacheSafeQueue.sync {[weak self] in
            self?.cache.removeAll()
        }
        cacheClear = true
        curentCaculteProgress?.cancel()
    }    
    
    func getShortestHeightColumn(_ heightOfColumns: [CGFloat])-> Int{
        heightOfColumnsQueue.sync {
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
    }
    
    func removeHeightOfColumn(from index: Int, withVaue value: CGFloat){
        heightOfColumnsQueue.async {[weak self] in
            if let self = self{
                self.heightOfColumns[index] = self.getHeighOfColumn(from: 0) - value
            }
        }
    }
    
    func getHeighOfColumn(from index: Int) -> CGFloat{
        heightOfColumnsQueue.sync {[weak self] in
            if let self = self{
                return self.heightOfColumns[index]
            }
            return 0.0
        }
    }
    
    func setHeightOfColum(of index: Int, to value: CGFloat){
        heightOfColumnsQueue.async {[weak self] in
            if let self = self{
                self.heightOfColumns[index] = value
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        var lastSawIndex = 0;
        guard getCacheCount() > 0 else{
            return visibleLayoutAttributes
        }
        for i in 0...getCacheCount()-1{
            let attributes = getCacheByIndex(index: i)
            if(attributes.frame.intersects(rect)){
                visibleLayoutAttributes.append(attributes)
                lastSawIndex = i
            }
        }
        curentCaculteProgress = DispatchWorkItem{[weak self] in
            if let self = self{
                self.caculateAtributeForItem(from: self.hightestIndex+1, to: lastSawIndex + self.range)
            }
        }
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now(), execute: curentCaculteProgress!)
        return visibleLayoutAttributes
    }
    
    
    private func getCacheCount() -> Int{
        cacheSafeQueue.sync {
            return cache.count
        }
    }
    
    private func getCacheByIndex(index: Int) -> PinterestLayoutAttributes{
        cacheSafeQueue.sync {
            return cache[index]
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            if indexPath.isEmpty { return nil }
            if(indexPath.row < getCacheCount()){
                return getCacheByIndex(index: indexPath.item)
            }else{
                return super.layoutAttributesForItem(at: indexPath)
            }
    }
    
    override var collectionViewContentSize: CGSize{
        return self.contentSize
    }
    
    override func prepareForTransition(from oldLayout: UICollectionViewLayout) {
        super.prepareForTransition(from: oldLayout)
    }
}
