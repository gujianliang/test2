//
//  WalletDappLogEventApi.m
//  VeWallet
//
//  Created by Tom on 2019/4/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDappLogEventApi.h"

@implementation WalletDappLogEventApi

-(instancetype)initWithKind:(NSString *)kind
{
    self = [super init];
    if (self){
        self.requestMethod = RequestPostMethod;

        self.httpAddress =  [NSString stringWithFormat:@"%@/logs/%@",[WalletUserDefaultManager getBlockUrl],kind];
    }
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    //add params
    NSMutableDictionary* dict = [super buildRequestDict];
    [dict setValueIfNotNil:_dictRange   forKey:@"range"];
    [dict setValueIfNotNil:_dictOptions forKey:@"options"];
    [dict setValueIfNotNil:_dictCriteriaSet forKey:@"criteriaSet"];
    [dict setValueIfNotNil:_order           forKey:@"order"];

    return dict;
}


-(Class)expectedModelClass
{
    return [NSDictionary class];
}

@end
