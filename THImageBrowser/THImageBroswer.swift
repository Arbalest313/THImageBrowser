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
    
    //淡入淡出时的视图
    var fadeInView : UIView?
    var fadeOutView : ((_ currentIndex: Int) -> (UIView?))?
    
    var urls:((_ currentIndex: Int) -> (String?))?
    var placeolders = {(atIndex: Int) ->UIImage? in
        return UIImage(named:"defaultImage")
    }
    
    
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
        let fadeView = fadeInView.snapshotView(afterScreenUpdates:false)
        
        if SDWebImageManager.shared().cachedImageExists(for:URL(string:(urls?(currentIndex))!)) {
            fadeView?.frame = (fadeInView.superview?.convert(fadeInView.frame, to: self))!
        } else {
            fadeView?.frame = (fadeInView.superview?.convert(fadeInView.frame, to: self))!
        }
        
        addSubview(fadeView!)
        
        UIView.animate(withDuration: kFadeInOutDuration, animations: {
            fadeView?.center = self.center
        }) { (_) in
            fadeView?.removeFromSuperview()
            self.scrollView.isHidden = false;
        }
    }

    fileprivate func fadeOut(gestureRecognizers : UITapGestureRecognizer) {
        let currentView = gestureRecognizers.view!
        let index = indexFrom(tag: currentView.tag)
        guard let fadeOutView = fadeOutView!(index) else {
            self.removeFromSuperview()
            return
        }
        
        let fadeView = currentView.snapshotView(afterScreenUpdates:false)
        fadeView?.frame = (currentView.superview?.convert(currentView.frame, to: self))!
        addSubview(fadeView!)
        
        scrollView.isHidden = true

        
        let tmpRct = (fadeOutView.superview?.convert(fadeOutView.frame, to: self))!

        UIView.animate(withDuration: kFadeInOutDuration, animations: {
            fadeView?.frame = tmpRct
            self.backgroundColor = UIColor.clear
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}

extension THImageBroswer {
    fileprivate func starImagesCloseTo(index:Int){
        defer {
            loadImageFor(index: index)
        }
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
    
    fileprivate func setUPScrollView (){
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        addSubview(scrollView)
        

        for index in 0...numberOfImages - 1 {
            let view = UIImageView()
            view.tag = index + ktagOffset
            view.isUserInteractionEnabled = true;
//            view.backgroundColor = (index % 2  == 0 ? UIColor.red : UIColor.black)
            let singleTap = UITapGestureRecognizer(target: self, action: #selector( dismiss(gestureRecognizers:)))
            view.addGestureRecognizer(singleTap)
            scrollView.addSubview(view)
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
