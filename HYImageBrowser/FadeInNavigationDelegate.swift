//
//  FadeInNavigationDelegate.swift
//  HYImageBrowser
//
//  Created by huangyuan on 9/22/16.
//  Copyright © 2016 tuhu. All rights reserved.
//

import UIKit

class FadeInNavigationDelegate: NSObject,UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let _ = fromVC as? FadeInTransitionProtocal, let _ = toVC as? FadeInTransitionProtocal {
            return FadeInTransition()
        }
        return nil
    }
}
