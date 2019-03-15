//
//  WalletGetBaseGasPriceApi.m
//  WalletSDK
//
//  Created by 曾新 on 2019/2/26.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletGetBaseGasPriceApi.h"

@implementation WalletGetBaseGasPriceApi

-(instancetype)init
{
    self = [super init];
    if (self){
        self.requestMethod = RequestPostMethod;
        httpAddress =  [NSString stringWithFormat:@"%@/accounts/%@",[WalletUserDefaultManager getBlockUrl],@"0x0000000000000000000000000000506172616D73"];
    }
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    //增加参数
    NSMutableDictionary* dict = [super buildRequestDict];
    [dict setValueIfNotNil:@"0x8eaa6ac0000000000000000000000000000000000000626173652d6761732d7072696365" forKey:@"data"];
    [dict setValueIfNotNil:@"0x0" forKey:@"value"];
    return dict;
}


-(Class)expectedModelClass
{
    return [NSDictionary class];
}


@end
