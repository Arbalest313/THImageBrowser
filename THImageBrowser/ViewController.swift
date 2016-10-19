//
//  ViewController.swift
//  HYImageBrowser
//
//  Created by huangyuan on 9/21/16.
//  Copyright © 2016 tuhu. All rights reserved.
//

import UIKit
import SDWebImage

let btnTagOffset = 10
class ViewController: UIViewController {


    var del = FadeInNavigationDelegate()
    //thumb300,or360
    var compressedURL = [//"http://ww2.sinaimg.cn/or360/65dc76a3gw1f8xfl7vpj5j20p10dxtdk.jpg",
                         "http://ww4.sinaimg.cn/or360/855c540agw1ez4x0wycsvj20p00dwtck.jpg",
                         "http://ww2.sinaimg.cn/or360/855c540agw1ez4x0q5hjbj20p00dwtbq.jpg",
                         "http://ww2.sinaimg.cn/or360/855c540agw1ez4x0t5wyaj20p00dwtd0.jpg"]
    //mw1024,woriginal
    var originalURL = [//"http://ww2.sinaimg.cn/woriginal/65dc76a3gw1f8xfl7vpj5j20p10dxtdk.jpg",
                       "http://ww4.sinaimg.cn/woriginal/855c540agw1ez4x0wycsvj20p00dwtck.jpg",
                       "http://ww2.sinaimg.cn/woriginal/855c540agw1ez4x0q5hjbj20p00dwtbq.jpg",
                       "http://ww2.sinaimg.cn/woriginal/855c540agw1ez4x0t5wyaj20p00dwtd0.jpg",]
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn1: UIButton!
    convenience init() {
        self.init();
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        btn1.imageView?.contentMode = .scaleAspectFill
//        btn1..contentMode = .scaleAspectFill
//
//        btn2.imageView?.contentMode = .scaleAspectFill
//        btn3.imageView?.contentMode = .scaleAspectFill

        btn1.sd_setBackgroundImage(with:url(string:compressedURL[0]) , for: .normal, placeholderImage:UIImage(named:"Icon-180"))
        btn2.sd_setBackgroundImage(with:url(string:compressedURL[1]) , for: .normal,placeholderImage:UIImage(named:"Icon-180"))
        btn3.sd_setBackgroundImage(with:url(string:compressedURL[2]) , for: .normal,placeholderImage:UIImage(named:"Icon-180"))
        btn1.setNeedsDisplay()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func url(string:String) -> URL! {
        return URL(string: string);
    }
    
    @IBAction func showBroswer(_ sender: UIButton) {
        let browser = THImageBroswer()
        browser.currentIndex = sender.tag - btnTagOffset
        browser.numberOfImages = originalURL.count
        browser.placeolders = { (atIndex: Int) -> UIImage in
            let btn =  self.view.viewWithTag(atIndex) as! UIButton
            return btn.image(for: .normal)!
        }
        browser.urls = {(atIndex:Int) -> String in
            return self.originalURL[atIndex]
        }
        browser.fadeInView = sender
        browser.fadeOutView = {(atIndex:Int) -> UIView in
            let btn =  self.view.viewWithTag(atIndex+btnTagOffset) as! UIButton
            return btn
        }
        browser.show()

    }
    
}

