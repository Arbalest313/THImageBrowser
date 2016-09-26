//
//  FadeInTransition.swift
//  HYImageBrowser
//
//  Created by huangyuan on 9/21/16.
//  Copyright © 2016 tuhu. All rights reserved.
//

import UIKit

@objc protocol FadeInTransitionProtocal {

    func endFadeInView(info: AnyObject?) -> UIView?

    var fadeInView : UIView? {get set}
    
    @objc optional
    var fadeInViewInfo : AnyObject? {get set}
    

}

class FadeInTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let containView = transitionContext.containerView as UIView?, let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as UIViewController?, let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as UIViewController? else{
            return
        }
        guard let fromPotocol = fromVC as? FadeInTransitionProtocal else {return}
        guard let toPotocol = toVC as? FadeInTransitionProtocal else {return}
        let fromV = fromPotocol.fadeInView
        let toV = toPotocol.endFadeInView(info:fromPotocol.fadeInViewInfo!)
        
        let snapShot = fromV?.snapshotView(afterScreenUpdates: false)
        snapShot?.frame = containView.convert((fromV?.frame)!, to: fromV?.superview)
        
        fromV?.isHidden = true
        toV?.isHidden = true
        toVC.view.alpha = 0
        
        containView.addSubview(toVC.view)
        containView.addSubview(snapShot!)
        
        let frame = containView.convert((toV?.frame)!, to: toV?.superview)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapShot?.frame = frame
            toVC.view.alpha = 1
            }) { (_) in
                fromV?.isHidden = false
                toV?.isHidden = false
                snapShot?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
