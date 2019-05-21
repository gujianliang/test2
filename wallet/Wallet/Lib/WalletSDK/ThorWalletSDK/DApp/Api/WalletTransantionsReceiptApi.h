//
//  WalletTransantionsReceiptApi.h
//  VeWallet
//
//  Created by Tom on 2018/6/1.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletBaseApi.h"
#import "WalletTransantionsReceiptModel.h"
@interface WalletTransantionsReceiptApi : WalletBaseApi

-(instancetype)initWithTxid:(NSString *)txid;

@end
