//
//  WalletTransactionApi.h
//  VCWallet
//
//  Created by Tom on 2018/4/27.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletBaseApi.h"

@interface WalletTransactionApi : WalletBaseApi
-(instancetype)initWithRaw:(NSString *)raw;

@end
