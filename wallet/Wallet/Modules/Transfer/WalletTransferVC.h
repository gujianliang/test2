//
//  TransferVC.h
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/27.
//  Copyright © 2018年 demo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletTransferVC : UIViewController

@property (nonatomic ,copy)NSString *amount;
@property (nonatomic ,assign)BOOL isVET;

@end

NS_ASSUME_NONNULL_END
