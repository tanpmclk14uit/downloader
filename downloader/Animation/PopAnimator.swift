//
//  PopAnimator.swift
//  downloader
//
//  Created by LAP14812 on 08/08/2022.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.6
    var presenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (() -> Void)?
    var recipeImage: UIImageView?
    var transitionDelegate: PopAnimator?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let recipeView: UIView?
        var initialFrame: CGRect = CGRect.zero
        var finalFrame: CGRect = CGRect.zero
        var xScaleFactor = 1.0
        var yScaleFactor = 1.0
        if presenting{
            recipeView =  transitionContext.view(forKey: .to)
            guard let recipeView = recipeView else {
                return
            }
            initialFrame = originFrame
            finalFrame = recipeView.frame
            xScaleFactor = initialFrame.width/finalFrame.width
            yScaleFactor = initialFrame.height/finalFrame.height
            
        }else{
            recipeView = transitionContext.view(forKey: .from)
            guard let recipeView = recipeView else {
                return
            }
            initialFrame = recipeView.frame
            finalFrame = originFrame
            xScaleFactor = finalFrame.width/initialFrame.width
            yScaleFactor = finalFrame.height/initialFrame.height
        }
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            recipeView!.transform = scaleTransform
            recipeView!.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            recipeView!.clipsToBounds = true
        }
        recipeView!.layer.masksToBounds = true
        
        if let toView = transitionContext.view(forKey: .to){
            containerView.addSubview(toView)
        }
        
        transitionContext.view(forKey: .to)?.backgroundColor = UIColor.black.withAlphaComponent(0)
        containerView.bringSubviewToFront(recipeView!)
        
        UIView.animate(
            withDuration: duration,
            delay:0.0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.5,
            options: .curveLinear,
            animations: {
                recipeView!.transform = self.presenting ? .identity : scaleTransform
                recipeView!.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                transitionContext.view(forKey: .to)?.backgroundColor = UIColor.black.withAlphaComponent(1)
            },
            completion: { _ in
                transitionContext.completeTransition(true)
                
                if !self.presenting {
                    self.dismissCompletion?()
                }
            })
        
    }
}
