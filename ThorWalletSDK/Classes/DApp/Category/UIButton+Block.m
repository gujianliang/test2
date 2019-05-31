//
//  UIButton+Block.m
//  VCBMW
//
//  Created by vechaindev on 2018/3/14.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "UIButton+Block.h"

@implementation UIButton (block)


-(void)setBlock:(void(^)(UIButton*))block
{
    objc_setAssociatedObject(self,@selector(block), block,OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget: self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside];
}

-(void(^)(UIButton*))block
{
    return objc_getAssociatedObject(self,@selector(block));
}

-(void)addTapBlock:(void(^)(UIButton*))block
{
    self.block= block;
    [self addTarget: self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)click:(UIButton*)btn
{
    if(self.block){
        self.block(btn);
    }
}

@end
