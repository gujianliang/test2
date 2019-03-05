//
//  WalletSdkMacro.h
//  WalletSDKDemo
//
//  Created by  VechainIOS on 2019/2/27.
//  Copyright © 2019 demo. All rights reserved.
//

#ifndef WalletSdkMacro_h
#define WalletSdkMacro_h

#define     ScreenW     [UIScreen mainScreen].bounds.size.width
#define     ScreenH     [UIScreen mainScreen].bounds.size.height
#define     Is_IPhoneX  ((ScreenH < 812) ? YES : NO)

#define     kStatusBarHeight                (Is_IPhoneX ? (20 + 24) : 20)
#define     kiPhoneXBottomOffset            (Is_IPhoneX ? 34 : 0)       /* safe area */
#define     kNavigationBarHeight            (Is_IPhoneX ? 88 : 64)
#define     KTabBarH            (Is_IPhoneX ? 83 : 49)                  /* the height of tabBar */
#define     Scale(num)          ((num) * SCREEN_WIDTH / 375.0)          /* the scale of width */
#define     ScaleH(num)         ((num) * SCREEN_HEIGHT / 667.0)         /* the scale of height */

#define     Test_Html           @"https://appwallet.oss-cn-shanghai.aliyuncs.com/testJS/test.html"                 /* Contract shortcut page */
#define     Test_Main_Page      @"https://appwallet.oss-cn-shanghai.aliyuncs.com/testJS/dist/index.html#/test"     /* Contract shortcut page */
#define     Test_Node      @"https://vethor-node-test.vechaindev.com"      /* The test Node environment of block */
#define     Main_Node      @"https://vethor-node.vechain.com"           /* The main Node environment of block */

#define     vthoTokenAddress    @"0x0000000000000000000000000000456e65726779"   /* A fixed contract address */

#endif /* WalletSdkMacro_h */
