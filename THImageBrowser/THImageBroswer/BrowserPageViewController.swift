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
let kFadeInOutDuration = 0.6

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
    
    var pageController = UIPageControl ()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        view.backgroundColor = UIColor.black
        

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if showing {
            fadeIn()
        }
    }
    
    // 对外唯一调用的显示方法
    // dataSource闭包用于实时请求需要的数据模型（LazyLoad）
    class func show(startAt initialShowIndex: Int = 0, sourceAt dataSource: @escaping ((_ index: Int) -> BrowserViewable?)) -> BrowserPageViewController {
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
        showing = true
//        view.isUserInteractionEnabled = false
        dataSource = nil
        let contantView =  self.viewControllers?.first?.view
        contantView?.isHidden = true
        let fadeView = UIImageView()
        fadeView.contentMode = fadeInView.contentMode
        fadeView.clipsToBounds = true
        fadeView.image =  snapShot(fadeInView)//.snapshotView(afterScreenUpdates:false)
        fadeView.frame = (fadeInView.superview?.convert(fadeInView.frame, to: view))!
        
        var w = (fadeView.frame.width)
        var h = (fadeView.frame.height)
        w = 100
        h = 100 * max(imageToBoundsWidthRatio(image: fadeView.image!),  imageToBoundsHeightRatio(image: fadeView.image!))
        //如果已经下载好了大图，重新计算图片的大小，
        guard let model = viewablesSources?(currentIndex) else {
            return
        }
        let url = URL(string:model.imageUrl!)
        if  SDWebImageManager.shared().cachedImageExists(for:url) {
            fadeView.image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: SDWebImageManager.shared().cacheKey(for: url))
            let image = fadeView.image
            let widthRatio = imageToBoundsWidthRatio(image: image!)
            let heightRatio = imageToBoundsHeightRatio(image: image!)
            w = image!.size.width / max(widthRatio, heightRatio)
            h = image!.size.height / max(widthRatio, heightRatio)
        }
        
        let x = (view.bounds.width - w)/2
        let y = (view.bounds.height - h)/2 // + 10
        
        let finalFrame = CGRect(x:x, y:y, width:w, height:h)
        
        view?.addSubview(fadeView)
        
        UIView.animate(withDuration: kFadeInOutDuration, animations: {
            fadeView.frame = finalFrame
        }) { (_) in
            fadeView.removeFromSuperview()
            contantView?.isHidden = false;
            self.showing = false
           self.dataSource = self

        }
    }
    
    @objc fileprivate func fadeOut(currentView : UIView) {
        // gestureRecognizers.view as! UIImageView
        guard let fadeOutView = fadeOutViewBlock?(currentIndex) else {
            view.removeFromSuperview()
            return
        }
        
        dataSource = nil

        fadeOutView.alpha = 0.0
        let fadeView = UIImageView()
        fadeView.contentMode = fadeOutView.contentMode
        fadeView.clipsToBounds = true
        fadeView.image = snapShot(fadeOutView)//.snapshotView(afterScreenUpdates:false)
        var startFrame = (fadeOutView.superview?.convert(fadeOutView.frame, to: view))!
        var w = (fadeView.frame.width)
        var h = (fadeView.frame.height)
        
        //如果已经下载好了大图，重新计算图大小，
        guard let model = viewablesSources?(currentIndex) else {
            return
        }
        let url = URL(string:model.imageUrl!)
        if  SDWebImageManager.shared().cachedImageExists(for:url) {
            fadeView.image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: SDWebImageManager.shared().cacheKey(for: url))
            let image = fadeView.image
            let widthRatio = imageToBoundsWidthRatio(image: image!)
            let heightRatio = imageToBoundsHeightRatio(image: image!)
            w = image!.size.width / max(widthRatio, heightRatio)
            h = image!.size.height / max(widthRatio, heightRatio)
            let x = (view.bounds.width - w)/2
            let y = (view.bounds.height - h)/2 //+ 10
            startFrame = CGRect(x:x, y:y, width:w, height:h)
        }
        
        
        fadeView.frame = startFrame
        let finalFrame = (fadeOutView.superview?.convert(fadeOutView.frame, to: view))!
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(fadeView)
        }
        
        
        let contantView =  self.viewControllers?.first?.view
        contantView?.isHidden = true
        
        UIView.animate(withDuration: kFadeInOutDuration, animations: {
            fadeView.frame = finalFrame
            self.view.alpha = 0.0
            fadeOutView.alpha = 0.2
        }) { (_) in
            fadeOutView.alpha = 1.0
            fadeView.removeFromSuperview()
            self.view.removeFromSuperview()
        }
    }
    
    
    func dismissSelf(currentView: UIView) {
        fadeOut(currentView: currentView)
    }
    
    
    func imageToBoundsWidthRatio(image: UIImage) -> CGFloat  { return image.size.width / view.bounds.size.width }
    func imageToBoundsHeightRatio(image: UIImage) -> CGFloat { return image.size.height / view.bounds.size.height }
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
            detailVC.dismissSelf = dismissSelf(currentView:)
            if let block = self.viewablesSources, let model = block(index) {
                detailVC.dataModel = model
                return detailVC
            }
        }
        
        return nil
    }
    internal func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 4
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
}

extension BrowserPageViewController{
    func snapShot(_ view:UIView) -> UIImage {
        
        UIGraphicsBeginImageContext(view.bounds.size);
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!);
        
        let viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return viewImage!;
        
    }
}

