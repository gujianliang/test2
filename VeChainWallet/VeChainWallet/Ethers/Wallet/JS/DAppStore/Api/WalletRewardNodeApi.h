//
//  WalletRewardNodeApi.h
//  VeWallet
//
//  Created by 曾新 on 2018/5/17.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "VCBaseApi.h"
#import "WalletRewardNodeModel.h"

@interface WalletRewardNodeApi : VCBaseApi

@property (copy, nonatomic) NSString *oldAddress;   // 发送请求时的address

-(instancetype)initWith:(NSString *)address;

@end
