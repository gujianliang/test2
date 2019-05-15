//
//  WalletDAppTransferDetailApi.h
//  VeWallet
//
//  Created by Tom on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "VCBaseModel.h"
#import "VCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppTransferDetailApi : VCBaseApi

-(instancetype)initWithTxid:(NSString *)txid;

@end

NS_ASSUME_NONNULL_END
