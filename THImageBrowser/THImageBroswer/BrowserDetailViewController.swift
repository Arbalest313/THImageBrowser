//
//  BrowserDetailViewController.swift
//  THImageBrowser
//
//  Created by Apple on 16/10/25.
//  Copyright © 2016年 Tsao. All rights reserved.
//

import UIKit

class BrowserDetailViewController: UIViewController, BrowserVCHandler {

    @IBOutlet weak var showImageView: UIImageView!
    
    let zoomableImageView = FDZoomableImageView()
    
    // 数据模型
    var dataModel: BrowserViewable?
    var actionSheet = UIActionSheet()
    
    var dismissSelf:((_ fadeOutView:UIView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        
        zoomableImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        view.addSubview(zoomableImageView)
        
        self.setupImageModeGestureRecognizers()
        
        if let model = dataModel, let urlStr = model.imageUrl, let url = URL(string: urlStr) {
            
            
            showImageView.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
                self.zoomableImageView.image = image
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    func setupImageModeGestureRecognizers() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(BrowserDetailViewController.dismiss as (BrowserDetailViewController) -> () -> ()))
        view.addGestureRecognizer(singleTap)
        
        
        let longpressGesutre = UILongPressGestureRecognizer(target: self, action: #selector(BrowserDetailViewController.handleLongpressGesture as (BrowserDetailViewController) -> () -> ()))
        longpressGesutre.numberOfTouchesRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(longpressGesutre)
        
        
        // 手势依赖
        singleTap.require(toFail: longpressGesutre)
        singleTap.require(toFail: zoomableImageView.doubleTapGestureRecognizer)

    }
    
    
    func dismiss () {
        
        if let dismissSelf = dismissSelf {
            dismissSelf(zoomableImageView)
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
    
    func panHandle(pan: UIPanGestureRecognizer) {
        
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
