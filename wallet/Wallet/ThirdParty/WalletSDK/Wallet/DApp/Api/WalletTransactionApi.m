//
//  WalletTransactionApi.m
//  VCWallet
//
//  Created by Tom on 2018/4/27.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletTransactionApi.h"

@implementation WalletTransactionApi
{
    NSString *_raw;
}
-(instancetype)initWithRaw:(NSString *)raw
{
    self = [super init];
    if (self){
        _raw = raw;
        self.requestMethod = RequestPostMethod;
        httpAddress =  [NSString stringWithFormat:@"%@%@",[WalletUserDefaultManager getBlockUrl],SendTransactionUrl];
    }
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    //增加参数
    NSMutableDictionary* dict = [super buildRequestDict];
    [dict setValue:_raw forKey:@"raw"];
    return dict;
}

-(Class)expectedModelClass
{
    return [NSDictionary class];
}
@end
