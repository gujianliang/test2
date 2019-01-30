//
//  NETDetailVC.h
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoverView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NETDetailVC : UIViewController

- (void)netType:(NetType)netType;
- (void)netName:(NSString *)netName netUrl:(NSString *)netUrl;

@end

NS_ASSUME_NONNULL_END
