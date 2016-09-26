//
//  BViewController.swift
//  HYImageBrowser
//
//  Created by huangyuan on 9/22/16.
//  Copyright © 2016 tuhu. All rights reserved.
//

import UIKit

class BViewController: UIViewController,FadeInTransitionProtocal {
    var fadeInView: UIView? =  UIView(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
    var fadeInViewInfo: AnyObject?

    var del = FadeInNavigationDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(fadeInView!)
        view.backgroundColor = UIColor.white
        navigationController?.delegate = del
        fadeInView?.backgroundColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func endFadeInView(info: AnyObject?) -> UIView? {
        if let info = info as? URL!, SDWebImageManager.shared().cachedImageExists(for: info) || true{
            fadeInView?.frame = CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width);
        }
        return fadeInView
    }

}
