//
//  PinterestViewLayoutCaculator.swift
//  downloader
//
//  Created by LAP14812 on 23/07/2022.
//

import UIKit

class PinterestViewLayoutCaculator{
    weak var delegate: PinterestLayoutCaculatorDelegate?
    private var cellPading: CGFloat;
    private var collectionViewWidth: CGFloat;
    private var itemCount: Int;
    private var numberOfColumn: Int
    private var heightOfColumns: [CGFloat]
    var contentSize: CGSize
    private var contentHeight: CGFloat
    var hightestIndex: Int
    
    private let heightOfColumnsQueue = DispatchQueue(label: "heightOfColumnsThreadSafe")
    private let cacheSafeQueue = DispatchQueue(label: "cacheSafeQueue")
    private let caculatorQueue = DispatchQueue(label: "caculatorQueue")
    
    let range = 100
    var curentCaculteProgress: DispatchWorkItem? = nil
    private var caches: [PinterestLayoutAttributes] = []
    private var cacheClear: Bool = false
    
    
    init(collectionViewWidth: CGFloat, itemCount: Int, numberOfColumn: Int = 2, cellPading: CGFloat = 10){
        self.numberOfColumn = numberOfColumn
        self.collectionViewWidth = collectionViewWidth
        self.cellPading = cellPading
        self.itemCount = itemCount
        self.hightestIndex = 0
        self.contentSize =  CGSize(width: 0, height: 0)
        self.contentHeight = 0
        self.heightOfColumns = [CGFloat].init(repeating: 0.0, count: numberOfColumn)
    }
    
    func caculateAtributeForItem(from: Int, to: Int){
        if let delegate = delegate {
            let numberOfColumn: Int = delegate.getNumberOfColumn();
            let itemWidth: CGFloat = (collectionViewWidth - cellPading*CGFloat(numberOfColumn+1))/CGFloat(numberOfColumn)
            
            caculatorQueue.sync {
                let low = max(0, from)
                let high = min(to, itemCount - 1)
                guard low < high else{
                    return
                }
                for i in from ... high{
                    if(cacheClear){
                        cacheClear = false
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
                        self?.caches.append(attributes)
                    }
                    
                    let newContentHeight:CGFloat = tempY + self.cellPading + itemHeight + self.cellPading;
                    if (newContentHeight > contentHeight){
                        contentHeight = newContentHeight;
                    }
                
                    self.contentSize = CGSize(width: collectionViewWidth, height: contentHeight)
                }
            }
        }
    }
    
    func reloadLayoutFromIndex(_ index: Int, itemCount: Int){
        cacheClear = true
        
        contentHeight = 0
        guard !caches.isEmpty, index<=hightestIndex else{
            return
        }
        self.hightestIndex = min(self.hightestIndex, caches.count)
        
        for i in index..<self.hightestIndex{
            let cache = caches[i]
            heightOfColumnsQueue.sync {
                heightOfColumns[cache.column] = heightOfColumns[cache.column] - cache.frame.height - cellPading
                if(heightOfColumns[cache.column] > contentHeight){
                    contentHeight = heightOfColumns[cache.column]
                }
            }
        }
        
        contentSize =  CGSize(width: collectionViewWidth, height: contentHeight)
        
        cacheSafeQueue.sync {[weak self] in
            if let self = self{
                self.caches.removeSubrange(index..<self.hightestIndex)
                self.cacheClear = false
            }
        }
        
        self.itemCount = itemCount
        curentCaculteProgress?.cancel()
        caculateAtributeForItem(from: index, to: index+range/4)
        hightestIndex = index + range/4 + 1
    }
    
    
    func clearCache(itemCount: Int){
        cacheClear = true
        cacheSafeQueue.sync {[weak self] in
            self?.caches.removeAll()
            self?.cacheClear = false
        }
        self.itemCount = itemCount
        curentCaculteProgress?.cancel()
        hightestIndex = 0
        contentSize =  CGSize(width: 0, height: 0)
        contentHeight = 0
        heightOfColumns = [CGFloat].init(repeating: 0.0, count: numberOfColumn)
    }
    
    func getCacheCount() -> Int{
        cacheSafeQueue.sync {
            return caches.count
        }
    }
    
    func getCacheByIndex(index: Int) -> PinterestLayoutAttributes{
        cacheSafeQueue.sync {
            return caches[index]
        }
    }
    
    
    private func getShortestHeightColumn(_ heightOfColumns: [CGFloat])-> Int{
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
    
    private func getHeighOfColumn(from index: Int) -> CGFloat{
        heightOfColumnsQueue.sync {[weak self] in
            if let self = self{
                return self.heightOfColumns[index]
            }
            return 0.0
        }
    }
    
    private func setHeightOfColum(of index: Int, to value: CGFloat){
        heightOfColumnsQueue.async {[weak self] in
            if let self = self{
                self.heightOfColumns[index] = value
            }
        }
    }
    
    
}
