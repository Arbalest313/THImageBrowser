//
//  BrowserDetailViewController.swift
//  THImageBrowser
//
//  Created by Apple on 16/10/25.
//  Copyright © 2016年 Tsao. All rights reserved.
//

import UIKit

typealias SingleTapBlock = () -> Void

class BrowserDetailViewController: UIViewController, BrowserVCHandler {
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    // 数据模型
    var dataModel: BrowserViewable?
    var dismissSelf:((_ fadeOutView:UIView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        if let model = dataModel, let urlStr = model.imageUrl, let url = URL(string: urlStr) {
            showImageView.sd_setImage(with: url)
        }
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(BrowserDetailViewController.dismiss as (BrowserDetailViewController) -> () -> ()))
        showImageView.addGestureRecognizer(singleTap)
        
        showImageView.isUserInteractionEnabled = true
        
        mainScrollView.delegate = self
        mainScrollView.maximumZoomScale = 3.0
        mainScrollView.minimumZoomScale = 0.5
        
        showImageView.contentMode = .scaleAspectFit
        showImageView.isUserInteractionEnabled = true
        
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandle(tap:)))
        doubleTap.numberOfTapsRequired = 2
        showImageView.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mainScrollView.setZoomScale(1.0, animated: true)
    }
    
    func doubleTapHandle(tap: UIGestureRecognizer) {
        
        // 双击：如果未放大，则放大两倍；否则，缩小为原图大小
        if self.mainScrollView.zoomScale == 1.0 {
            let zoomRect = self.zoomRect(forScale: 2.0, withCenter: tap.location(in: tap.view))
            self.mainScrollView.zoom(to: zoomRect, animated: true)
        } else {
            self.mainScrollView.setZoomScale(1.0, animated: true)
        }
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    func dismiss () {
        if let dismissSelf = dismissSelf {
            dismissSelf(showImageView)
        }
    }
    
    
}


extension BrowserDetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.showImageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale < 1.0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.mainScrollView.zoomScale = 1.0
            })
        }
    }
    
}

extension BrowserDetailViewController {
    func zoomRect(forScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var tempRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        tempRect.size.height = showImageView.frame.height / scale
        tempRect.size.width = showImageView.frame.width / scale
        
        let tempCenter = showImageView.convert(center, from: self.mainScrollView)
        
        tempRect.origin.x = tempCenter.x - (tempRect.size.width / 2.0)
        tempRect.origin.y = tempCenter.y - (tempRect.size.height / 2.0)
        
        return tempRect
        
    }
}
