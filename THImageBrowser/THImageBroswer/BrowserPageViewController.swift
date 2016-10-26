//
//  BrowserPageViewController.swift
//  THImageBrowser
//
//  Created by Apple on 16/10/25.
//  Copyright © 2016年 Tsao. All rights reserved.
//

import UIKit
import PureLayout
import SDWebImage
let kFadeInOutDuration = 0.4

// 所有PageViewController下的滑动子Controller需要实现的方法和属性
protocol BrowserVCHandler {
    var dataModel: BrowserViewable? {get} // 当前数据模型
    var dismissSelf:((_ fadeOutView:UIView) -> Void)? {get}
}



class BrowserPageViewController: UIPageViewController {
    
    var viewablesSources: ((_ index: Int) -> BrowserViewable?)?
    var fadeInView: UIView?
    var fadeOutViewBlock: ((_ index: Int) -> UIView?)?
    var showing = true
    var currentIndex:Int {
        get{
            if let handler = self.viewControllers?.first as? BrowserVCHandler {
               return  (handler.dataModel?.index)!
            }
            return 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        view.backgroundColor = UIColor.black
        //            detailVC.view.layoutIfNeeded()
        //            detailVC.showImageView.addGestureRecognizer(singleTap)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        fadeIn()

    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if showing {
            fadeIn()
        }
    }
    
    // 对外唯一调用的显示方法
    // dataSource闭包用于实时请求需要的数据模型（LazyLoad）
    class func show(_ initialShowIndex: Int = 0, _ dataSource: @escaping ((_ index: Int) -> BrowserViewable?)) -> BrowserPageViewController {
        let vc = BrowserPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        vc.viewablesSources = dataSource

        if let detailVC = vc.viewControllerAtIndex(initialShowIndex) {
            vc.setViewControllers([detailVC], direction: .forward, animated: true, completion: nil)
        }
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(vc.view)
            window.rootViewController?.addChildViewController(vc)
            vc.view.autoPinEdgesToSuperviewEdges()
        }
        return vc
    }
    
    func configurableFade(inView: UIView, outView outViewBlock: @escaping ((_ index: Int) -> UIView?)) {
        fadeInView = inView
        fadeOutViewBlock = outViewBlock
    }
    
}

extension BrowserPageViewController {
    fileprivate func fadeIn() {
        guard let fadeInView = fadeInView else {
            return
        }
        
        let contantView =  self.viewControllers?.first?.view
        contantView?.isHidden = true
        var fadeView = fadeInView.snapshotView(afterScreenUpdates:false)
        
        fadeView?.frame = (fadeInView.superview?.convert(fadeInView.frame, to: view))!
        
        var w = (fadeView?.frame.width)!
        var h = (fadeView?.frame.height)!
        
        //如果已经下载好了大图，重新计算图片的大小，
        guard let model = viewablesSources?(currentIndex) else {
            return
        }
        let url = URL(string:model.imageUrl!)
        if  SDWebImageManager.shared().cachedImageExists(for:url) {
            let originalImage = UIImageView()
            originalImage.image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: SDWebImageManager.shared().cacheKey(for: url))
            originalImage.frame = (fadeView?.frame)!
            fadeView = originalImage
            w = (view.bounds.width - 2)
            h = (view.bounds.height - 40)
        }
        
        let x = (view.bounds.width - w)/2
        let y = (view.bounds.height - h)/2
        
        let finalFrame = CGRect(x:x, y:y, width:w, height:h)
        
        view?.addSubview(fadeView!)
        
        UIView.animate(withDuration: kFadeInOutDuration, animations: {
            fadeView?.frame = finalFrame
        }) { (_) in
            fadeView?.removeFromSuperview()
            contantView?.isHidden = false;
            self.showing = false
        }
    }
    
    @objc fileprivate func fadeOut(currentView : UIView) {
        // gestureRecognizers.view as! UIImageView
        let index = currentIndex
        view.backgroundColor = UIColor.clear
        
        guard let fadeOutView = fadeOutViewBlock!(index) else {
            view.removeFromSuperview()
            return
        }
        
//        let fadeView = UIImageView()
        //        fadeView.contentMode = UIViewContentMode.scaleAspectFill
        //        fadeView.layer.masksToBounds = true
        let fadeView = currentView.snapshotView(afterScreenUpdates:false)
        fadeView?.frame = (currentView.superview?.convert(currentView.frame, to: view))!
//        fadeView.image = currentView.image
//        fadeView.setNeedsDisplay()
        
        view.addSubview(fadeView!)
        
        //        tmp = fadeView
        
        let contantView =  self.viewControllers?.first?.view
        contantView?.isHidden = true
        
        let tmpRct = (fadeOutView.superview?.convert(fadeOutView.frame, to: view))!
        
        //        displaylink = CADisplayLink(target: self, selector:#selector(updateDisplay))
        //        displaylink?.add(to: RunLoop.main, forMode:.defaultRunLoopMode)
        
        UIView.animate(withDuration: kFadeInOutDuration, animations: {
            fadeView?.frame = tmpRct
            
        }) { (_) in
            //            self.displaylink?.invalidate()
            self.view.removeFromSuperview()
        }
    }
    
    
    func dismissSelf(currentView: UIView) {
        fadeOut(currentView: currentView)
    }

}

extension BrowserPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let broserHandler = viewController as? BrowserVCHandler else {
            return nil
        }
        
        return self.viewControllerAtIndex((broserHandler.dataModel?.index ?? 0) + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let broserHandler = viewController as? BrowserVCHandler else {
            return nil
        }
        
        return self.viewControllerAtIndex((broserHandler.dataModel?.index ?? 0) - 1)
    }
    
    fileprivate func viewControllerAtIndex(_ index: Int) -> UIViewController?{
        
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowserDetailViewController") as? BrowserDetailViewController {
//            let singleTap = UITapGestureRecognizer(target: self, action: #selector( fadeOut(gestureRecognizers:)))
//            detailVC.view.layoutIfNeeded()
//            detailVC.showImageView.addGestureRecognizer(singleTap)
            detailVC.dismissSelf = dismissSelf(currentView:)
            if let block = self.viewablesSources, let model = block(index) {
                detailVC.dataModel = model
                return detailVC
            }
        }
        
        return nil
    }
}
