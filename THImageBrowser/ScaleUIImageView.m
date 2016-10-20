
//
//  UIImageView+Pinch.m
//  THImageViewer
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Tsao. All rights reserved.
//

#import "ScaleUIImageView.h"

@implementation ScaleUIImageView

- (instancetype)init{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.scale = 1.0;    
}

- (void)setScale:(CGFloat)scale{
    if (_scale != scale) {
        _scale = scale;
        
//        [self.layer setAffineTransform:
//         CGAffineTransformScale([self.layer affineTransform],
//                                scale,
//                                scale)];
    }
}

@end
