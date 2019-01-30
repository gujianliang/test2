//
//  WalletRewardNodeApi.m
//  VeWallet
//
//  Created by 曾新 on 2018/5/17.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletRewardNodeApi.h"

@implementation WalletRewardNodeApi

-(instancetype)initWith:(NSString *)address
{
    self = [super init];
    if (self){
        self.needEncrypt = YES;
        self.oldAddress = address;
        
        httpAddress =  [NSString stringWithFormat:@"%@%@",[WalletUserDefaultManager getNodeExchangeUrl],
                        StringWithParam(RewardNodeInfoWithAddress,address)];
    }
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    //增加参数
    NSMutableDictionary* dict = [super buildRequestDict];
    return dict;
}


-(Class)expectedModelClass
{
    return [WalletRewardNodeModel class];
}
@end
