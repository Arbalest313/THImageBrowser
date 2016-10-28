//
//  BrowserDetailViewController.swift
//  THImageBrowser
//
//  Created by Apple on 16/10/25.
//  Copyright © 2016年 Tsao. All rights reserved.
//

import UIKit

let screenBounds = UIScreen.main.bounds

class BrowserDetailViewController: UIViewController, BrowserVCHandler {
//    @IBOutlet weak var showImageView: UIImageView!
//    @IBOutlet weak var mainScrollView: UIScrollView!
    let showImageView = UIImageView()
    let mainScrollView = UIScrollView()
    
    fileprivate var imageWidth: CGFloat = screenBounds.size.width
    fileprivate var imageHeight: CGFloat?
    
    // 数据模型
    var dataModel: BrowserViewable?
    var actionSheet = UIActionSheet()
    
    var dismissSelf:((_ fadeOutView:UIView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        showImageView.frame = CGRect(x: (screenBounds.width - 100) / 2, y: (screenBounds.height - 100) / 2, width: 100, height: 100)
        mainScrollView.frame = view.bounds
        showImageView.center = mainScrollView.center
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(showImageView)
        
        if let model = dataModel, let urlStr = model.imageUrl, let url = URL(string: urlStr) {
            showImageView.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
                if let realImageWidth = image?.size.width, let realImageHeight = image?.size.height {
                    guard realImageWidth != 0 && realImageHeight != 0 else {
                        return
                    }
                    self.imageHeight = self.imageWidth / realImageWidth * realImageHeight
                    UIView.animate(withDuration: 0.3, animations: { 
                        self.showImageView.frame.size = CGSize(width: self.imageWidth, height: self.imageHeight!)
                        self.showImageView.center = self.mainScrollView.center
                    })
                    
//                    self.showImageView.translatesAutoresizingMaskIntoConstraints = true
//                    self.showImageView.removeConstraints(self.showImageView.constraints)
//                    self.showImageView.removeFromSuperview()
//                    self.mainScrollView.addSubview(self.showImageView)
//                    self.showImageView.autoSetDimensions(to: CGSize(width: self.imageWidth, height: self.imageHeight!))
//                    self.showImageView.autoCenterInSuperview()
//                    self.showImageView.layoutIfNeeded()
                }
            })
        }
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(BrowserDetailViewController.dismiss as (BrowserDetailViewController) -> () -> ()))
        showImageView.addGestureRecognizer(singleTap)
        
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target: self, action: #selector(BrowserDetailViewController.handleLongpressGesture as (BrowserDetailViewController) -> () -> ()))
        longpressGesutre.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(longpressGesutre)

        showImageView.isUserInteractionEnabled = true
        
        mainScrollView.delegate = self
        mainScrollView.maximumZoomScale = 2.0
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
    }
    
    func doubleTapHandle(tap: UIGestureRecognizer) {
        
        // 双击：如果未放大，则放大两倍；否则，缩小为原图大小
        if self.mainScrollView.zoomScale == 1.0 {
            
            let touchCenter = tap.location(in: tap.view)
            
            let zoomRect = self.zoomRect(forScale: 2.0, withCenter: touchCenter)
            self.mainScrollView.zoom(to: zoomRect, animated: true)
            
        } else {
            self.mainScrollView.setZoomScale(1.0, animated: true)
        }
    }
    
//    func pinchHandle(pinch: UIGestureRecognizer) {
//        let pinchPoint =  pinch.location(in: pinch.view)
//        let zoomRect = self.zoomRect(forScale: 2.0, withCenter: pinchPoint)
//        self.mainScrollView.zoom(to: zoomRect, animated: true)
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    func dismiss () {
        if let dismissSelf = dismissSelf {
            dismissSelf(showImageView)
        }
    }
    
    //长按  弹出Action
    func handleLongpressGesture () {
        actionSheet.addButton(withTitle: "取消")
        actionSheet.addButton(withTitle: "保存图片")
        actionSheet.cancelButtonIndex = 0
        actionSheet.delegate = self
        actionSheet.show(in: self.view)
    }
    
}

// MARK: - Action代理
extension BrowserDetailViewController: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 1 {
            //保存图片
            let img = showImageView.image
            saveImageToAlbum(image: img!)
        }
    }
    
    func saveImageToAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(showImageView.image!, self,  #selector(BrowserDetailViewController.image(image:didFinishSavingWithError:contextInfo:)) , nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject)
    {
        var title: String!
        if didFinishSavingWithError != nil
        {
            title = "图片保存失败"
        } else {
            title = "图片保存成功"
        }
        let myAlert = UIAlertView(title: title, message: nil, delegate: nil, cancelButtonTitle: "OK")
        myAlert.show()
    }
}

extension BrowserDetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.showImageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale < 1.0 {
            self.mainScrollView.setZoomScale(1.0, animated: true)
        }
//        print("size:<<<\(mainScrollView.contentSize)\n offset\(mainScrollView.contentOffset)")
        
        
    }
}

extension BrowserDetailViewController {
    func adjustContentOffset() {
        let currentY = mainScrollView.contentOffset.y
        
        let lower = (mainScrollView.contentSize.height - imageHeight!) / 2
        var result = currentY
        if  lower > currentY{
            result = lower
        }
        if lower + showImageView.frame.height/2 < currentY {
            result =  lower + showImageView.frame.height/2
        }
        print("result :\(result) currntY:\(currentY)  lower:\(lower)")

        mainScrollView.setContentOffset(CGPoint(x:mainScrollView.contentOffset.x, y:result), animated: false);
    }
    
    func zoomRect(forScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        
        // 调整可能点击图片空白区域的center
        let adjustCenter = self.adjustScaleCenter(withCenter: center)
        
        
        var tempRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        tempRect.size.height = showImageView.frame.size.height / scale
        tempRect.size.width = showImageView.frame.size.width / scale
        
        let zoomCenter = showImageView.convert(adjustCenter, from: self.mainScrollView)
        
        
        tempRect.origin.x = zoomCenter.x - (tempRect.size.width / 2.0)

        tempRect.origin.y = zoomCenter.y - (tempRect.size.height / 2.0)
        
        print("size:<<<\(tempRect))")

        return tempRect
        
    }
    
    
    
    func adjustScaleCenter(withCenter touchCenter: CGPoint) -> CGPoint {
        
        var center = touchCenter
        
        guard let _ = self.imageHeight else {
            return CGPoint(x: 0, y: 0)
        }
        
        if self.isOperatingOnBlankArea(withCenter: center) {
            center.y = self.showImageView.bounds.size.height / 2
        }
        
        return center
    }
    
    func isOperatingOnBlankArea(withCenter operateCenter: CGPoint) -> Bool {
        
        if let actualImageHeight = self.imageHeight {
            let actualImageY = (self.showImageView.bounds.size.height - actualImageHeight) / 2
            
            // 交互区域在图片上方空白处
            if operateCenter.y > 0 && operateCenter.y < actualImageY {
                return true
            }
            
            let actualImageMaxY = (self.showImageView.bounds.size.height + actualImageHeight) / 2
            // 交互区域在图片下方空白处
            if operateCenter.y > actualImageMaxY && operateCenter.y < self.showImageView.bounds.size.height {
                return true
            }
        }
        return false
    }
}


// extension BrowserDetailViewController: UIGestureRecognizerDelegate {
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
//        let operatePoint = gestureRecognizer.location(in: gestureRecognizer.view)
//        if self.isOperatingOnBlankArea(withCenter: operatePoint) {
//            return false
//        }
        
//        return true
//    }
// }
