//
//  WalletVETBalanceApi.h
//  VCWallet
//
//  Created by Andy Deng on 2018/5/2.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "VCBaseApi.h"
#import "WalletBalanceModel.h"

@interface WalletVETBalanceApi : VCBaseApi

-(instancetype)initWith:(NSString *)address;

@end
