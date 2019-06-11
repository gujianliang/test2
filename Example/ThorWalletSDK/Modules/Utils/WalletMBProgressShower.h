//
//  WalletMBProgressShower.h
//  VeChain
//
//  Created by VeChain on 18/4/7.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


@interface WalletMBProgressShower : NSObject

+(MBProgressHUD*)showCircleIn:(UIView*)view;

+(MBProgressHUD*)showTextIn:(UIView*)view
                       Text:(NSString*)text;

+(void)showTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time;

+ (MBProgressHUD*)showLoadData:(UIView*)view Text:(NSString*)text ;

+(MBProgressHUD*)showMulLineTextIn:(UIView*)view Text:(NSString*)text;

+(void)showMulLineTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time;

+(void)hide:(UIView*)view;

@end


