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
        httpAddress =  [NSString stringWithFormat:@"%@/accounts/%@/code",[WalletUserDefaultManager getBlockUrl],address];
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
    return [NSDictionary class];
}
@end
