//
//  WalletVETBalanceApi.h
//  VCWallet
//
//  Created by Andy Deng on 2018/5/2.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletBaseApi.h"
#import "WalletBalanceModel.h"

@interface WalletVETBalanceApi : WalletBaseApi

-(instancetype)initWith:(NSString *)address;

@end
