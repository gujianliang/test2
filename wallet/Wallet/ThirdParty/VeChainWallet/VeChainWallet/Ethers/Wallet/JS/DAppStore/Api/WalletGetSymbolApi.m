//
//  WalletGetSymbolApi.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/16.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletGetSymbolApi.h"

@implementation WalletGetSymbolApi
-(instancetype)initWithTokenAddress:(NSString *)tokenAddress
{
    self = [super init];
    if (self){
        self.requestMethod = RequestPostMethod;
        self.specialRequest = YES;
        httpAddress =  [NSString stringWithFormat:@"%@/accounts/%@",[WalletUserDefaultManager getBlockUrl],tokenAddress];
    }
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    //增加参数
    NSMutableDictionary* dict = [super buildRequestDict];
    
    [dict setValueIfNotNil:@"0x95d89b41" forKey:@"data"];
    [dict setValueIfNotNil:@"0x0" forKey:@"value"];
    return dict;
}


-(Class)expectedModelClass
{
    return [NSDictionary class];
}

@end
