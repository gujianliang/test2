//
//  WalletAccountCodeApi.m
//  VeWallet
//
//  Created by Tom on 2019/1/18.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletAccountCodeApi.h"

@implementation WalletAccountCodeApi

-(instancetype)initWithAddress:(NSString *)address
{
    self = [super init];
    if (self){
        self.requestMethod = RequestGetMethod;
        self.specialRequest = YES;
        self.httpAddress =  [NSString stringWithFormat:@"%@/accounts/%@/code",[WalletUserDefaultManager getBlockUrl],address];
    }
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    // increase the parameter
    NSMutableDictionary* dict = [super buildRequestDict];
    return dict;
}


-(Class)expectedModelClass
{
    return [NSDictionary class];
}
@end
