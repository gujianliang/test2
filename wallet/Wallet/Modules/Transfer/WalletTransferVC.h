//
//  TransferVC.h
//  walletSDKDemo
//
//  Created by Tom on 2018/12/27.
//  Copyright © 2018年 demo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletTransferVC : UIViewController

@property (copy, nonatomic) NSString *coinAmount;     /* The balance of the coin */
@property (assign, nonatomic) BOOL isVET;             /* It is used to mark whether a VET or a VTHO coin */

@end

NS_ASSUME_NONNULL_END
