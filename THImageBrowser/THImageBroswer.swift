//
//  THImageBroswer.swift
//  THImageBrowser
//
//  Created by huangyuan on 10/19/16.
//  Copyright © 2016 tuhu. All rights reserved.
//

import UIKit
import SDWebImage
let kFadeInOutDuration = 0.4
let ktagOffset = 10

fileprivate let imageViewMargin : CGFloat = 1.0
class THImageBroswer: UIView,UIScrollViewDelegate {
    //图片数量
    var numberOfImages = 1
    var currentIndex = 0 {
        didSet {
            print("currentIndex \(currentIndex)");
        }
    }
    
    var tmp : UIView?
    var displaylink : CADisplayLink?
    //淡入淡出时的视图
    var fadeInView : UIView?
    var fadeOutView : ((_ currentIndex: Int) -> (UIView?))?
    
    var urls:((_ currentIndex: Int) -> (String?))?
    var placeolders = {(atIndex: Int) ->UIImage? in
        return UIImage(named:"defaultImage")
    }
    
    
//    let imageViewer : ImageViewer?
    
    fileprivate var scrollView = UIScrollView()
    fileprivate var showing = false
    
    init() {
        super.init(frame:.zero)
        backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show () {
        let window = UIApplication.shared.keyWindow;
        frame = (window?.bounds)!
        window?.addSubview(self);
        showing = true;
    }
    
    func dismiss(gestureRecognizers : UITapGestureRecognizer) {
        fadeOut(gestureRecognizers: gestureRecognizers)
    }
    
    
    
    //MARK: - ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let index = scrollView.contentOffset.x / bounds.width
    }
    
    
}

extension THImageBroswer {
    
    fileprivate func fadeIn() {
        guard let fadeInView = fadeInView else {
            return
        }
        scrollView.isHidden = true
        var fadeView = fadeInView.snapshotView(afterScreenUpdates:false)
        
        fadeView?.frame = (fadeInView.superview?.convert(fadeInView.frame, to: self))!
        
        var w = (fadeView?.frame.width)!
        var h = (fadeView?.frame.height)!
        
        //如果已经下载好了大图，重新计算图片的大小，
        let url = URL(string:(urls?(currentIndex))!)
        if SDWebImageManager.shared().cachedImageExists(for:url) {
            let originalImage = UIImageView()
            originalImage.image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: SDWebImageManager.shared().cacheKey(for: url))
            originalImage.frame = (fadeView?.frame)!
            fadeView = originalImage
            w = (bounds.width - 2)
            h = (bounds.height)
        }

        let x = (bounds.width - w)/2
        let y = (bounds.height - h)/2

        let finalFrame = CGRect(x:x, y:y, width:w, height:h)

        addSubview(fadeView!)
        
        UIView.animate(withDuration: kFadeInOutDuration, animations: {
                fadeView?.frame = finalFrame
        }) { (_) in
            fadeView?.removeFromSuperview()
            self.scrollView.isHidden = false;
        }
    }

    fileprivate func fadeOut(gestureRecognizers : UITapGestureRecognizer) {
        let currentView = gestureRecognizers.view as! UIImageView
        let index = indexFrom(tag: currentView.tag)
        self.backgroundColor = UIColor.clear

        guard let fadeOutView = fadeOutView!(index) else {
            self.removeFromSuperview()
            return
        }
        
        let fadeView = UIImageView()
//        fadeView.contentMode = UIViewContentMode.scaleAspectFill
//        fadeView.layer.masksToBounds = true
        fadeView.frame = (currentView.superview?.convert(currentView.frame, to: self))!
        fadeView.image = currentView.image // = currentView.snapshotView(afterScreenUpdates:false)
        fadeView.setNeedsDisplay()

        addSubview(fadeView)
        
        tmp = fadeView
        
        scrollView.isHidden = true

        
        let tmpRct = (fadeOutView.superview?.convert(fadeOutView.frame, to: self))!
        
//        displaylink = CADisplayLink(target: self, selector:#selector(updateDisplay))
//        displaylink?.add(to: RunLoop.main, forMode:.defaultRunLoopMode)

        UIView.animate(withDuration: kFadeInOutDuration, animations: {
            fadeView.frame = tmpRct

        }) { (_) in
//            self.displaylink?.invalidate()
            self.removeFromSuperview()
        }
    }
    
    @objc fileprivate func updateDisplay () {
        tmp?.setNeedsDisplay()
    }

}

extension THImageBroswer {
    fileprivate func starImagesCloseTo(index:Int){

        loadImageFor(index: index)
        
        if index != 0 {
            loadImageFor(index: index - 1)
        }
        
        if index != numberOfImages - 1 {
            loadImageFor(index: index + 1)
        }
    }
    
    fileprivate func loadImageFor(index:Int){
        guard let imageV = scrollView.viewWithTag(index + ktagOffset) as? UIImageView else {
            return
        }
        guard let url = URL(string: (urls?(index))!) else {
            return
        }
        imageV.sd_setImage(with:url, placeholderImage: UIImage(named:"Icon-180"))
    }
}

extension THImageBroswer {
    
    fileprivate func indexFrom(tag:Int) -> Int {
        return tag - ktagOffset
    }
    
    fileprivate func addGesture(toView imageView:ScaleUIImageView) {
        //singleTap
        let singleTap = UITapGestureRecognizer(target: self, action: #selector( dismiss(gestureRecognizers:)))
        imageView.addGestureRecognizer(singleTap)
        
        //doubleTap
        let doubleTap = UITapGestureRecognizer(actionBlock: { (ges) in
            if (ges as? UITapGestureRecognizer) != nil {
                if imageView.scale == 1 {
                    imageView.scale = 2
                    
                    UIView.animate(withDuration: 0.4, animations: {
                        imageView.layer.setAffineTransform(CGAffineTransform(scaleX: 2, y: 2))
                    })
                }
                else {
                    imageView.scale = 1
                    imageView.zoomed = false
                    
                    UIView.animate(withDuration: 0.4, animations: {
                        imageView.layer.setAffineTransform(CGAffineTransform(scaleX: 1, y: 1))
                    })
                }
            }
        })
        
        doubleTap!.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap!)
        singleTap.require(toFail: doubleTap!)
        
        // pinch
        let pinch = UIPinchGestureRecognizer.init(actionBlock: { (ges) in
            if let sender =  ges as? UIPinchGestureRecognizer {
                
                
                let scale = max(imageView.scale * sender.scale, 1)
                
                let location = sender.location(in: imageView)
                let contentViewSize = self.bounds.size
                
                if sender.state == .began {
                    if !imageView.zoomed {
                        let lastAnchor = imageView.layer.anchorPoint
                        let lastPosition = imageView.layer.position
                        
                        imageView.layer.anchorPoint = CGPoint(x: location.x / contentViewSize.width, y: location.y / contentViewSize.height)
                        imageView.layer.position = CGPoint(x: lastPosition.x + (imageView.layer.anchorPoint.x - lastAnchor.x) * imageView.frame.width * scale, y: lastPosition.y + (imageView.layer.anchorPoint.y - lastAnchor.y) * imageView.frame.height * scale)
                    }
                    imageView.zoomed = true
                }
                
                imageView.layer.setAffineTransform(CGAffineTransform(scaleX: scale, y: scale))
                
                if sender.state == .ended || sender.state == .cancelled{
                    imageView.scale = scale
                    if scale == 1 {
                        imageView.zoomed = false
                    }
                }
            }
        })
        imageView.addGestureRecognizer(pinch!)
    
    }
    
    fileprivate func setUPScrollView (){
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        addSubview(scrollView)
        
        for index in 0...numberOfImages - 1 {
            let imageView = ScaleUIImageView()
            imageView.tag = index + ktagOffset
            imageView.isUserInteractionEnabled = true
//            imageView.contentMode = .scaleAspectFill
            addGesture(toView: imageView)
            scrollView.addSubview(imageView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        scrollView.center =  center
        let height = bounds.height
        let width = bounds.width - 2 * imageViewMargin
        for (index,value) in scrollView.subviews.enumerated() {
            value.frame = CGRect(x: imageViewMargin + index * (imageViewMargin * 2 + width), y: 0, width: width , height: height)
            
        }
        
        scrollView.contentSize = CGSize(width: bounds.width * numberOfImages,height:height)
        scrollView.contentOffset =  CGPoint(x:bounds.width * currentIndex, y:0)
        
        if showing {
            fadeIn()
            showing = false
        }
    }
    
    override func didMoveToSuperview() {
        setUPScrollView()
        starImagesCloseTo(index:currentIndex)
    }

    
    

}
