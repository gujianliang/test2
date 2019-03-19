//
//  WalletDAppSignPreVC.h
//  VeWallet
//
//  Created by HuChao on 2019/1/22.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppSignPreVC : UIViewController

@property (strong, nonatomic) NSMutableDictionary *dictParam;

@property (copy, nonatomic) void (^block)(void);

@end

NS_ASSUME_NONNULL_END
