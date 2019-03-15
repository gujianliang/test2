//
//  WalletDAppTransferDetailApi.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppTransferDetailApi.h"

@implementation WalletDAppTransferDetailApi

-(instancetype)initWithTxid:(NSString *)txid
{
    self = [super init];
    if (self){
        
        httpAddress =  [NSString stringWithFormat:@"%@/transactions/%@",[WalletUserDefaultManager getBlockUrl],txid];
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
