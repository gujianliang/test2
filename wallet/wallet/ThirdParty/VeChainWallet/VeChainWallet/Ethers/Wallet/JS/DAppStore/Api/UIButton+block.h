//
//  UIButton+block.h
//  VCBMW
//
//  Created by 曾新 on 2018/3/14.
//  Copyright © 2018年 曾新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (block)

@property(nonatomic ,copy)void(^block)(UIButton *btn);

-(void)addTapBlock:(void(^)(UIButton*btn))block;

@end
