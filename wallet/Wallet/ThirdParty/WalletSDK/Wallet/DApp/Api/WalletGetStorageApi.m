//
//  WalletGetStorageApi.m
//  VeWallet
//
//  Created by Tom on 2019/2/20.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletGetStorageApi.h"

@implementation WalletGetStorageApi

-(instancetype)initWithkey:(NSString *)key address:(NSString *)address
{
    self = [super init];
    if (self){
        
        self.httpAddress =  [NSString stringWithFormat:@"%@/accounts/%@/storage/%@",[WalletUserDefaultManager getBlockUrl],address,key];
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
