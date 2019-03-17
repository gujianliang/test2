//
//  WalletTokenBalanceApi.m
//  VCWallet
//
//  Created by 曾新 on 2018/4/28.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletTokenBalanceApi.h"

@implementation WalletTokenBalanceApi
{
    NSString *_data;
}

-(instancetype)initWith:(NSString *)tokenAddress
                   data:(NSString *)data
{
    self = [super init];
    if (self){
        _data = data;
        self.requestMethod = RequestPostMethod;
        self.specialRequest = YES;
        httpAddress =  [NSString stringWithFormat:@"%@%@",[WalletUserDefaultManager getBlockUrl],StringWithParam(BalanceWithAddress, tokenAddress)];
    }
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    //增加参数
    NSMutableDictionary* dict = [super buildRequestDict];
    [dict setValueIfNotNil:@"0x0" forKey:@"value"];
    [dict setValueIfNotNil:_data forKey:@"data"];
    return dict;
}


-(Class)expectedModelClass
{
    return [WalletBalanceModel class];
}
@end
