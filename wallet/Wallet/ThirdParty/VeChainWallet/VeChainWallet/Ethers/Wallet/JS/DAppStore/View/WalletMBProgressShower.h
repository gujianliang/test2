//
//  WalletMBProgressShower.h
//  Stonebang
//
//  Created by 曾新 on 16/4/7.
//  Copyright © 2016年 stonebang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD.h"


@interface WalletMBProgressShower : NSObject

/**
 *  展示菊花轮
 *
 *  @param view 需要显示菊花轮的视图
 *
 *  @return HUD实例
 */
+(MBProgressHUD*)showCircleIn:(UIView*)view;

/**
 *  展示文本
 *
 *  @param view 展示文本的view
 *  @param text 展示文本内容
 *
 *  @return HUD实例
 */
+(MBProgressHUD*)showTextIn:(UIView*)view
                       Text:(NSString*)text;

/**
 *  固定时间消失的text
 *
 *  @param view 展示文本的view
 *  @param text 展示文本内容
 *  @param time 显示时间
 */
+(void)showTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time;
/**
 *  隐藏HUD
 */

+ (MBProgressHUD*)showLoadData:(UIView*)view Text:(NSString*)text ;

+(MBProgressHUD*)showMulLineTextIn:(UIView*)view Text:(NSString*)text;

+(void)showMulLineTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time;

+(void)hide:(UIView*)view;

@end


