//
//  TransferVC.h
//  walletSDKDemo
//
//  Created by vechaindev on 2018/12/27.
//  Copyright © 2019 WalletSDKDemo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletTransferVC : UIViewController

@property (copy, nonatomic) NSString *coinAmount;     /* The balance of the coin */
@property (assign, nonatomic) BOOL isVET;             /* It is used to mark whether a VET or a VTHO coin */

@end

NS_ASSUME_NONNULL_END
