//
//  WalletGenesisBlockInfoApi.m
//  VCWallet
//
//  Created by Andy Deng on 2018/5/3.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletGenesisBlockInfoApi.h"

@implementation WalletGenesisBlockInfoApi
-(instancetype)init
{
    self = [super init];
    if (self){
        
        self.httpAddress =  [NSString stringWithFormat:@"%@/blocks/0",[WalletUserDefaultManager getBlockUrl]];
    }
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    NSMutableDictionary* dict = [super buildRequestDict];
    return dict;
}


-(Class)expectedModelClass
{
    return [WalletBlockInfoModel class];
}

@end
