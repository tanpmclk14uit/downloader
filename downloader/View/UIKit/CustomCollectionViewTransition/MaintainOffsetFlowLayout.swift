//
//  MaintainOffsetFlowLayout.swift
//  downloader
//
//  Created by LAP14812 on 06/07/2022.
//

import UIKit

class MaintainOffsetFlowLayout: UICollectionViewFlowLayout {
    open var previousContentOffset: NSValue?

    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let previousContentOffsetPoint = previousContentOffset?.cgPointValue
        let superContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        if let previousContentOffsetPoint = previousContentOffsetPoint {
            if previousContentOffsetPoint.y == 0 {
                return previousContentOffsetPoint
            }
        }
        return superContentOffset
    }
    
    override open func prepareForTransition(from oldLayout: UICollectionViewLayout) {
        if(previousContentOffset?.cgPointValue.y != 0){
            previousContentOffset = NSValue(cgPoint: collectionView!.contentOffset)
        }
        return super.prepareForTransition(from: oldLayout)
    }
    
    func resetContentOffset(){
        previousContentOffset = NSValue(cgPoint: CGPoint(x: 0, y: 0))
    }
    
    override open func finalizeLayoutTransition() {
        previousContentOffset = nil
        super.finalizeLayoutTransition()
    }
    
    
}
