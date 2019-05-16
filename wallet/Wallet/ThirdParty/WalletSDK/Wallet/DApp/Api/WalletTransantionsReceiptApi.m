//
//  WalletTransantionsReceiptApi.m
//  VeWallet
//
//  Created by Tom on 2018/6/1.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletTransantionsReceiptApi.h"

@implementation WalletTransantionsReceiptApi

-(instancetype)initWithTxid:(NSString *)txid
{
    self = [super init];
    if (self){
        
        self.httpAddress =  [NSString stringWithFormat:@"%@%@",[WalletUserDefaultManager getBlockUrl],StringWithParam(ReceiptInfoWithAddress, txid)];
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
    return [WalletTransantionsReceiptModel class];
}

@end
