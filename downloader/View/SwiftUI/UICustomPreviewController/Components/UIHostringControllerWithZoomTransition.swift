//
//  UIHostringControllerWithZoomTransition.swift
//  downloader
//
//  Created by LAP14812 on 30/08/2022.
//

import UIKit
import SwiftUI

@available(iOS 13, *)
class UIHostringControllerWithZoomTransition<Content>:UIHostingController<Content>, UIViewControllerTransitioningDelegate where Content: View {
    
    override init(rootView: Content) {
        super.init(rootView: rootView)
        print("init")
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate: CustomPreviewControllerDelegate?
    private var animator = PopAnimator()
    
    func getOriginFrameForItemAt(position: Int) -> CGRect?{
        if let delegate = delegate{
            let animationView = delegate.previewController(self, transitionViewForItemAt: position)
            guard let animationView = animationView else {
                return nil
            }
            let selectedCellSuperview = animationView.superview ?? UIView()
            return selectedCellSuperview.convert(animationView.frame, to: nil)
        }else{
            return nil
        }
    }
    
    func getCurrentPreviewItemPosition() -> Int{
        let previewControllerView = self.rootView as! UICustomPreview
        return previewControllerView.viewModel.currentPreviewItemIndex
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let originFrame = getOriginFrameForItemAt(position: getCurrentPreviewItemPosition()){
            animator.originFrame = originFrame
            animator.presenting = true
            return animator
        }else{
            return nil
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let originFrame = getOriginFrameForItemAt(position: getCurrentPreviewItemPosition()){
            animator.originFrame = originFrame
            animator.presenting = false
            return animator
        }else{
            return nil
        }
    }
}
