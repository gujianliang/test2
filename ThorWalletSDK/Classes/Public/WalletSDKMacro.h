//
//  WalletSDKMacro.h
//  WalletSDK
//
//  Created by Tom on 2019/5/20.
//  Copyright © 2019 VeChain. All rights reserved.
//

#ifndef WalletSDKMacro_h
#define WalletSDKMacro_h

#define SDKVersion  @"1.0.0"

#define AppId @"5c50bb8d9736b60f1f0f4f5c56604326"

#define AppId_Test @"27a7898b733ce99d90ec5338de5ced52"

#define     Test_Node      @"https://vethor-node-test.digonchain.com"      /* The test Node environment of block chain */
#define     Main_Node      @"https://vethor-node.digonchain.com"           /* The main Node environment of block chain*/


#define VCNSLocalizedBundleString(key, comment) [WalletTools localStringBundlekey:(key)]

#define SCREEN_WIDTH          ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT         ([UIScreen mainScreen].bounds.size.height)

// MARK: -
// MARK: iPhoneX
#define iS_iPhoneX ([UIScreen mainScreen].bounds.size.height >= 812)
#define kStatusBarHeight                (iS_iPhoneX ? (20 + kiPhoneXStatusBarOffset) : 20)
#define kNavigationBarHeight            (iS_iPhoneX ? 88 : 64)

#define KBottomHeight       ((SCREEN_HEIGHT >= 812) ? 34 : 0)     // iPhonex bottom height
#define KNavY               ((SCREEN_HEIGHT >= 812) ? 20 : 0)     // iPhonex navigation bar height
#define KTabBarH            ((SCREEN_HEIGHT >= 812) ? 83 : 49)    // tabBar height
#define Scale(num)          ((num) * SCREEN_WIDTH / 375.0)
#define ScaleH(num)         ((num) * SCREEN_HEIGHT / 667.0)

// control NSLog
#define     ReleaseVersion    1


#endif /* WalletSDKMacro_h */
