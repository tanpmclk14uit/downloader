//
//  TransitionManager.swift
//  downloader
//
//  Created by LAP14812 on 05/07/2022.
//

import UIKit

private let finishTransitionValue = 1.0
@objc class TransitionManager: NSObject{
    private let duration: TimeInterval
    private let collectionView: UICollectionView
    private let destinationLayout: UICollectionViewLayout
    private var transitionLayout: UICollectionViewTransitionLayout!
    private var updater: CADisplayLink!
    private var startTime: TimeInterval!
    
    public init(
        duration: TimeInterval,
        collectionView: UICollectionView,
        destinationLayout: UICollectionViewLayout
    ) {
        self.collectionView = collectionView
        self.destinationLayout = destinationLayout
        self.duration = duration
    }
    
    func startInteractiveTransition() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        transitionLayout = collectionView.startInteractiveTransition(to: destinationLayout) { success, finish in
            if success && finish {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        createUpdaterAndStart()
    }
    
    func createUpdaterAndStart() {
        startTime = CACurrentMediaTime()
        updater = CADisplayLink(target: self, selector: #selector(updateTransitionProgress))
        updater.add(to: .current, forMode: .common)
    }
    
    @objc func updateTransitionProgress() {
        var progress = (updater.timestamp - startTime) / duration
        progress = min(1, progress)
        progress = max(0, progress)
        transitionLayout.transitionProgress = CGFloat(progress)
        
        transitionLayout.invalidateLayout()
        if progress == finishTransitionValue {
            
            collectionView.finishInteractiveTransition()
            updater.invalidate()
        }
    }
}
