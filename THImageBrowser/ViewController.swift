//
//  ViewController.swift
//  THImageBrowser
//
//  Created by Apple on 16/10/25.
//  Copyright © 2016年 Tsao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var showImage: UIButton!
    @IBOutlet weak var v1: UIImageView!
    @IBOutlet weak var v2: UIImageView!

    @IBOutlet weak var v4: UIImageView!
    @IBOutlet weak var v3: UIImageView!
    
    //thumb300,or360
    var compressedURL = [
        "http://ww4.sinaimg.cn/or480/6ba7ecc9gw1f93x6ua5cnj21kw11xdtk.jpg",
        "http://ww3.sinaimg.cn/or480/7828dd47jw1f94xrskwvhj20u00u0god.jpg",
        "http://ww2.sinaimg.cn/or480/6ba7ecc9gw1f93x9rc2zwj21kw11xdq6.jpg",
        "http://ww2.sinaimg.cn/or480/6ba7ecc9gw1f93x6lhk6lj21kw11xgvz.jpg",
        "http://ww4.sinaimg.cn/or480/6ba7ecc9gw1f93x708zbij21kw11xdt7.jpg",
        ]
    //mw1024,woriginal
    var originalURL = [
        "http://ww4.sinaimg.cn/woriginal/6ba7ecc9gw1f93x6ua5cnj21kw11xdtk.jpg",
        "http://ww3.sinaimg.cn/woriginal/7828dd47jw1f94xrskwvhj20u00u0god.jpg",
        "http://ww2.sinaimg.cn/woriginal/6ba7ecc9gw1f93x9rc2zwj21kw11xdq6.jpg",
        "http://ww2.sinaimg.cn/woriginal/6ba7ecc9gw1f93x6lhk6lj21kw11xgvz.jpg",
        "http://ww4.sinaimg.cn/woriginal/6ba7ecc9gw1f93x708zbij21kw11xdt7.jpg",
        ]

    func url(string:String) -> URL! {
        return URL(string: string);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        v1.sd_setImage(with:url(string:compressedURL[0]))
        v2.sd_setImage(with:url(string:compressedURL[1]))
        v3.sd_setImage(with:url(string:compressedURL[2]))
        v4.sd_setImage(with:url(string:compressedURL[3]))

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showImage(_ sender: UIGestureRecognizer) {
        let numberOfViews = 3
        BrowserPageViewController.show((sender.view?.tag)!-1, { (index) -> BrowserViewable? in
            if index > numberOfViews || index<0{return nil}
            let viewable = BrowserViewable()
            viewable.index = index
            viewable.imageUrl = self.originalURL[index]
            return viewable
        }).configurableFade(inView:sender.view!, outView: { (index) -> UIView? in
            return self.view.viewWithTag(index+1)
        })
    }
}

