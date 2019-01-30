//
//  WalletBlockInfoApi.m
//  VCWallet
//
//  Created by 曾新 on 2018/4/28.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletBlockInfoApi.h"

@implementation WalletBlockInfoApi
-(instancetype)init
{
    self = [super init];
    if (self){
        
        httpAddress =  [NSString stringWithFormat:@"%@%@",[WalletUserDefaultManager getBlockUrl],NewBlockInfoUrl];
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
    return [WalletBlockInfoModel class];
}
@end
