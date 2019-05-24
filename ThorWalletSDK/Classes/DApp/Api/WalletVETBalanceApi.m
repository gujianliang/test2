//
//  WalletVETBalanceApi.m
//  VCWallet
//
//  Created by Andy Deng on 2018/5/2.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletVETBalanceApi.h"
#import "ThorWalletHeader.h"

@implementation WalletVETBalanceApi

-(instancetype)initWith:(NSString *)address
{
    self = [super init];
    if (self){
        self.specialRequest = YES;
    
        self.httpAddress =  [NSString stringWithFormat:@"%@/accounts/%@",[WalletUserDefaultManager getBlockUrl], address];
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
    return [WalletBalanceModel class];
}

@end
