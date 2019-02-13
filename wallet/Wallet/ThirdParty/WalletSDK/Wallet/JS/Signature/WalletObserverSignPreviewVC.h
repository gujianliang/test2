//
//  WalletObserverSignPreviewVC.h
//  VeWallet
//
//  Created by 曾新 on 2018/10/25.
//  Copyright © 2018年 VeChain. All rights reserved.
//

//#import "VCBaseVC.h"
#import <UIKit/UIKit.h>

//#import "WalletAuthScanQRCodeHandle.h"
#import "WalletSignObserverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletObserverSignPreviewVC : UIViewController

- (instancetype)initWithData:(WalletSignObserverModel *)model;  // 二维码扫描后的数据
@property (nonatomic, assign)BusinessType businessType;
@end

NS_ASSUME_NONNULL_END
