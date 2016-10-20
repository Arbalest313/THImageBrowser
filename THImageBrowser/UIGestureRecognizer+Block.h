//
//  UIGestureRecognizer+Block.h
//  THImageViewer
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Tsao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^NVMGertureBlock)(id gesture);
@interface UIGestureRecognizer (Block)

+(instancetype)nvm_gestureRecongnizerWithActionBlock:(NVMGertureBlock)Block;

-(instancetype)initWithActionBlock:(NVMGertureBlock)Block;

@end
