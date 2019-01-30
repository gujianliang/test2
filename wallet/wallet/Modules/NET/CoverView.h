//
//  CoverView.h
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger,NetType)
{
    ProductServer,
    TestServer,
    CustomServer
};

@interface CoverView : UIView

@property(nonatomic,copy)void (^block)(NetType netType);
@end

NS_ASSUME_NONNULL_END
