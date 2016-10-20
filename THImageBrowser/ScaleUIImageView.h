//
//  UIImageView+Pinch.h
//  THImageViewer
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Tsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleUIImageView: UIImageView
// 当前缩放比例
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) BOOL zoomed;
@end
