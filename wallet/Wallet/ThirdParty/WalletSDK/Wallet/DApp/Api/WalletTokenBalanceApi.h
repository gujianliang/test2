//
//  WalletTokenBalanceApi.h
//  VCWallet
//
//  Created by Tom on 2018/4/28.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "VCBaseApi.h"
#import "WalletBalanceModel.h"

@interface WalletTokenBalanceApi : VCBaseApi

-(instancetype)initWith:(NSString *)tokenAddress
                   data:(NSString *)data;

@end
