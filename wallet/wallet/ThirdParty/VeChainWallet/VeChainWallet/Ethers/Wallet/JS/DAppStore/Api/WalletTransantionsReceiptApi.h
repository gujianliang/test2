//
//  WalletTransantionsReceiptApi.h
//  VeWallet
//
//  Created by 曾新 on 2018/6/1.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "VCBaseApi.h"
#import "WalletTransantionsReceiptModel.h"
@interface WalletTransantionsReceiptApi : VCBaseApi

-(instancetype)initWithTxid:(NSString *)txid;

@end
