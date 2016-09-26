//
//  ViewController.swift
//  HYImageBrowser
//
//  Created by huangyuan on 9/21/16.
//  Copyright © 2016 tuhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FadeInTransitionProtocal {

    var fadeInView: UIView?
    var fadeInViewInfo: AnyObject?

    var del = FadeInNavigationDelegate()

    convenience init() {
        self.init();
        fadeInView = UIView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let aV = UIView()
        aV.frame = CGRect(x: 0, y: 90, width: 48, height: 48)//CGRectMake(100,100,100,100)
        aV.backgroundColor = UIColor.black
        view.addSubview(aV)
        fadeInView = aV
        
        let pushGes = UITapGestureRecognizer(target: self, action: #selector(push))
        aV.addGestureRecognizer(pushGes)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = del
    }
    
    func push()  {
        self.navigationController?.pushViewController(BViewController(), animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func endFadeInView(info: AnyObject?) -> UIView? {
        return fadeInView
    }
    
   

}

