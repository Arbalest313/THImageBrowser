//
//  UIGestureRecognizer+Block.m
//  THImageViewer
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Tsao. All rights reserved.
//

#import <objc/message.h>
#import "UIGestureRecognizer+Block.h"


static const int target_key;
@implementation UIGestureRecognizer (Block)
+(instancetype)nvm_gestureRecongnizerWithActionBlock:(NVMGertureBlock)Block
{
    return [[self alloc]initWithActionBlock:Block];
}
-(instancetype)initWithActionBlock:(NVMGertureBlock)Block
{
    self = [self init];
    [self addActionBlock:Block];
    [self addTarget:self action:@selector(invoke:)];
    return self;
    
}
-(void)addActionBlock:(NVMGertureBlock)block
{
    if (block) {
        objc_setAssociatedObject(self, &target_key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}
-(void)invoke:(id)sender
{
    NVMGertureBlock block = objc_getAssociatedObject(self, &target_key);
    if (block) {
        block(sender);
    }
}
@end
