//
//  WalletMBProgressShower.h
//  Stonebang
//
//  Created by Tom on 18/4/7.
//  Copyright © 2016年 stonebang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD.h"


@interface WalletMBProgressShower : NSObject

/**
 *  Show daisy wheel
 *
 *  @param view Need to display the view of the daisy wheel
 *
 *  @return HUD
 */
+(MBProgressHUD*)showCircleIn:(UIView*)view;

/**
 *  展示文本
 *
 *  @param view View of the text
 *  @param text Display text content
 *
 *  @return HUD
 */
+(MBProgressHUD*)showTextIn:(UIView*)view
                       Text:(NSString*)text;

/**
 *  Text that disappears at a fixed time
 *
 *  @param view View of the text
 *  @param text Display text content
 *  @param time display time
 */
+(void)showTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time;
/**
 *  hide HUD
 */

+ (MBProgressHUD*)showLoadData:(UIView*)view Text:(NSString*)text ;

+(MBProgressHUD*)showMulLineTextIn:(UIView*)view Text:(NSString*)text;

+(void)showMulLineTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time;

+(void)hide:(UIView*)view;

@end


