//
//  WalletGetStorageApi.h
//  VeWallet
//
//  Created by Tom on 2019/2/20.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "VCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletGetStorageApi : VCBaseApi

-(instancetype)initWithkey:(NSString *)key address:(NSString *)address;

@end

NS_ASSUME_NONNULL_END
