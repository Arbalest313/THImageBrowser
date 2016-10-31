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
    
    lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        showImageView.contentMode = .scaleAspectFill
        showImageView.clipsToBounds = true
//        showImageView.frame = CGRect(x: (screenBounds.width - 100) / 2, y: (screenBounds.height -
        showImageView.isUserInteractionEnabled = true
        
        
        
        zoomableImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        view.addSubview(zoomableImageView)
        
        zoomableImageView.frame = CGRect(x: 0, y: 0, width:100, height: 100)
        zoomableImageView.setImageViewContenMode(.scaleAspectFill)
        zoomableImageView.center = view.center
        zoomableImageView.image = dataModel?.placeholder
        zoomableImageView.clipsToBounds = true
        
        
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center;
        view.addSubview(indicator)
        indicator.bringSubview(toFront:view)
        indicator.startAnimating()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupImageModeAndGestureRecognizers()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    
    
    func setupImageModeAndGestureRecognizers() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(BrowserDetailViewController.dismiss as (BrowserDetailViewController) -> () -> ()))
        view.addGestureRecognizer(singleTap)
        
        
        let longpressGesutre = UILongPressGestureRecognizer(target: self, action: #selector(BrowserDetailViewController.handleLongpressGesture as (BrowserDetailViewController) -> () -> ()))
        longpressGesutre.numberOfTouchesRequired = 1
        self.view.isUserInteractionEnabled = true
        // 手势依赖
        singleTap.require(toFail: longpressGesutre)
        singleTap.require(toFail: zoomableImageView.doubleTapGestureRecognizer)
        
        zoomableImageView.isUserInteractionEnabled = false
        if let model = dataModel, let urlStr = model.imageUrl, let url = URL(string: urlStr) {
            showImageView.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
                self.indicator.stopAnimating()
                self.zoomableImageView.contentMode = .scaleAspectFit
                self.zoomableImageView.setImageViewContenMode(.scaleAspectFit)
                self.zoomableImageView.image = image
                UIView.animate(withDuration: 0.4, animations: {
                    self.zoomableImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
                })
                self.zoomableImageView.isUserInteractionEnabled = true
                self.view.addGestureRecognizer(longpressGesutre)
            })
        }

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
