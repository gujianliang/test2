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
        self.supportOtherDataFormat = YES;
        self.httpAddress =  [NSString stringWithFormat:@"%@/transactions",[WalletUserDefaultManager getBlockUrl]];
    }
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    // increase the parameter
    NSMutableDictionary* dict = [super buildRequestDict];
    [dict setValueIfNotNil:_raw forKey:@"raw"];
    return dict;
}

-(Class)expectedModelClass
{
    return [NSDictionary class];
}
@end
