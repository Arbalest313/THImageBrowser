//
//  ImageViewer.swift
//  THImageViewer
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Tsao. All rights reserved.
//

import UIKit
import PureLayout

class ImageViewer: UIView {
    private var imageUrls:[String]? = nil
    {
        didSet {
            self.refreshContent()
        }
    }
    
    // 当前显示位置
    var currentIndex = 0
    
    // 主滑动视图
    @IBOutlet weak var mainScrollView: UIScrollView!
    // 主滑动视图的内容View
    @IBOutlet weak var mainContentView: UIView!
    
    class func showWithImages(images: [String]) {        
        if let window = UIApplication.shared.keyWindow, let selfView = Bundle.main.loadNibNamed("ImageViewer", owner: nil, options: nil)?.first as? ImageViewer {
            selfView.imageUrls = images
            
            window.addSubview(selfView)
            
            selfView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.currentIndex >= 1 {
            self.mainScrollView.contentOffset = CGPoint(x: Int(Float(1) * Float(self.frame.size.width)), y: 0)
        }
    }
    
    // 重新加载整个内容
    private func refreshContent() {
        if self.mainScrollView.delegate == nil {
            self.mainScrollView.delegate = self;
        }
        
        // 先删除所有子View
        mainContentView.subviews.forEach({ (subView) in
            subView.removeFromSuperview()
        })

        guard let allUrls = self.imageUrls, allUrls.count > 0 else {
            return
        }
        
        guard currentIndex + 1 <= allUrls.count else {
            return
        }
        
        var imagesUrlToShow: [String] = []
        // 追加图片URL，最多三张，最少一张
        
        [currentIndex - 1, currentIndex, currentIndex + 1].forEach { (i) in
            if i + 1 <= allUrls.count, i >= 0 {
                imagesUrlToShow.append(allUrls[i])
            }
        }
        
        var scrollWrappersArray:[UIScrollView] = []
        
        for (index, imageUrl) in imagesUrlToShow.enumerated() {
            let imageWrapperScrollView = UIScrollView()
            imageWrapperScrollView.delegate = self
            
            self.mainContentView.addSubview(imageWrapperScrollView)
            imageWrapperScrollView.backgroundColor = .black
            
            // 约束
            if index == 0 {
                imageWrapperScrollView.autoPinEdge(.leading, to: .leading, of: self.mainContentView, withOffset: 0)
                imageWrapperScrollView.autoPinEdge(.top, to: .top, of: self, withOffset: 0)
                imageWrapperScrollView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0)
                imageWrapperScrollView.autoMatch(.width, to: .width, of: self)
            }
            else {
                imageWrapperScrollView.autoPinEdge(.leading, to: .trailing, of: scrollWrappersArray[index - 1], withOffset: 0)
                imageWrapperScrollView.autoPinEdge(.top, to: .top, of: self, withOffset: 0)
                imageWrapperScrollView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0)
                imageWrapperScrollView.autoMatch(.width, to: .width, of: self)
            }
            
            // 最后一个，补全
            if index + 1 == imagesUrlToShow.count{
                imageWrapperScrollView.autoPinEdge(.trailing, to: .trailing, of: self.mainContentView, withOffset: 0)
            }
            
            scrollWrappersArray.append(imageWrapperScrollView)

            // 图片View初始化
            let imageView = ScaleUIImageView()
            imageView.contentMode = .scaleAspectFit
            let contentView = UIView()
            contentView.addSubview(imageView)
            imageWrapperScrollView.addSubview(contentView)
            
            contentView.autoPinEdgesToSuperviewEdges()
            contentView.autoMatch(.height, to: .height, of: self)
            imageView.tag = 1000
            // 图片和ScrollView约束
            imageView.autoPinEdgesToSuperviewEdges()
            imageView.autoMatch(.width, to: .width, of: self)
            // 加载图片
            if let url = URL(string: imageUrl) {
                imageView.sd_setImage(with: url)
            }
            
            
           
            
            // 添加手势
            let gesture = UIPinchGestureRecognizer.init(actionBlock: { (ges) in
                if let sender =  ges as? UIPinchGestureRecognizer {
                    
                    
                    let scale = max(imageView.scale * sender.scale, 1)
                    
                    let location = sender.location(in: imageView)
                    let contentViewSize = contentView.frame.size
                   
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
            
//            let pan = UIPanGestureRecognizer(actionBlock: { (ges) in
//                if let sender =  ges as? UIPanGestureRecognizer {
//                    guard imageView.zoomed else {
//                        return
//                    }
//                    let offset = sender.translation(in: contentView)
//                    
//                    imageView.layer.setAffineTransform(CGAffineTransform(translationX: offset.x, y: offset.y))
//                }
//            })
//            
//            if let gesture = pan {
//                imageWrapperScrollView.addGestureRecognizer(gesture)
//            }
            
            let tap = UITapGestureRecognizer(actionBlock: { (ges) in
                if let sender =  ges as? UITapGestureRecognizer {
                    if imageView.scale == 1 {
//                        let location = sender.location(in: contentView)
//                        
//                        let lastAnchor = imageView.layer.anchorPoint
//                        let lastPosition = imageView.layer.position
//                        let contentViewSize = contentView.frame.size
//
//                        imageView.layer.anchorPoint = CGPoint(x: location.x / contentViewSize.width, y: location.y / contentViewSize.height)
//                        imageView.layer.position = CGPoint(x: lastPosition.x + (imageView.layer.anchorPoint.x - lastAnchor.x) * imageView.frame.width * 2, y: lastPosition.y + (imageView.layer.anchorPoint.y - lastAnchor.y) * imageView.frame.height * 2)
                        
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
            
            if let tapGesture = tap {
                tapGesture.numberOfTapsRequired = 2
                imageWrapperScrollView.addGestureRecognizer(tapGesture)
            }

            imageWrapperScrollView.addGestureRecognizer(gesture!)
        }
    }
}

extension ImageViewer: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // SCROLL过程结束，重新设置currentIndex
//        if scrollView.contentOffset {
//            <#code#>
//        }
    }
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return scrollView.viewWithTag(1000)!
//    }
}
