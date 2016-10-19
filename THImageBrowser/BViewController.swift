//
//  BViewController.swift
//  HYImageBrowser
//
//  Created by huangyuan on 9/22/16.
//  Copyright © 2016 tuhu. All rights reserved.
//

import UIKit
import SDWebImage
let kscreenW = UIScreen.main.bounds.width
class BViewController: UIViewController,FadeInTransitionProtocal {
    let starFrame = CGRect(x: (kscreenW - 100)/2, y: (kscreenW)/2 + 100 - 50 , width: 100, height: 100)
    let endFrame =  CGRect(x: 0, y: 100, width:kscreenW , height: kscreenW)

    var fadeInView: UIView? =  UIView()
    var fadeInViewInfo: AnyObject?

    var del = FadeInNavigationDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(fadeInView!)
        view.backgroundColor = UIColor.black
        navigationController?.delegate = del
        fadeInView?.backgroundColor = UIColor.red
        fadeInView?.frame = starFrame
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if let info = URL(string:"HTTP://A") as? URL!, SDWebImageManager.shared().cachedImageExists(for: info) || true{
//            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//                self.fadeInView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//            }){(_) in
//                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//                    self.fadeInView?.transform = CGAffineTransform.identity
//                }) {(_) in
//                    self.fadeInView?.frame = self.endFrame
//                    let initMagnifyCircle:UIBezierPath = UIBezierPath.init(ovalIn: self.starFrame)
//                    let radius = UIScreen.main.bounds.width/2
//                    let finalMagnifyCircle:UIBezierPath = UIBezierPath.init(ovalIn: self.endFrame.insetBy(dx: -radius, dy: -radius))
//                    
//                    let maskLayer = CAShapeLayer()
//                    maskLayer.path = finalMagnifyCircle.cgPath
//                    self.fadeInView?.layer.mask = maskLayer;
//                    
//                    let maskAnimation = CABasicAnimation.init(keyPath: "path")
//                    maskAnimation.fromValue = initMagnifyCircle.cgPath
//                    maskAnimation.toValue = finalMagnifyCircle.cgPath
//                    maskAnimation.duration = 0.5
//                    maskLayer.add(maskAnimation, forKey: "path")
//                    
//                
//                }
//            }
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func endFadeInView(_ info: AnyObject?) -> UIView? {
        if let info = info as? URL!, SDWebImageManager.shared().cachedImageExists(for: info) || false{
            fadeInView?.frame = endFrame;
        }
        return fadeInView
    }

}
