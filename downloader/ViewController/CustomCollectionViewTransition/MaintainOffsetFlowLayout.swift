//
//  MaintainOffsetFlowLayout.swift
//  downloader
//
//  Created by LAP14812 on 06/07/2022.
//

import UIKit

class MaintainOffsetFlowLayout: UICollectionViewFlowLayout {
    private var previousContentOffset: NSValue?
    
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
    
    func resetContentOffset(){
        previousContentOffset = nil
    }
    
    override open func prepareForTransition(from oldLayout: UICollectionViewLayout) {
        previousContentOffset = NSValue(cgPoint: collectionView!.contentOffset)
        return super.prepareForTransition(from: oldLayout)
    }
    
    override open func finalizeLayoutTransition() {
        previousContentOffset = nil
        super.finalizeLayoutTransition()
    }
}
