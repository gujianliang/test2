//
//  WalletSingletonHandle.h
//  walletSDK
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WalletManageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletSingletonHandle : NSObject

+ (instancetype)shareWalletHandle;

- (NSArray *)getAllWallet;

- (NSString *)getWalletKeystore:(NSString *)address;

- (void)addWallet:(NSArray *)walletList;

- (void)setCurrentModel:(NSString *)address;

- (WalletManageModel *)currentWalletModel;


@end

NS_ASSUME_NONNULL_END
