//
//  WalletBestBlockInfoApi.m
//  VCWallet
//
//  Created by Tom on 2018/4/28.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletBestBlockInfoApi.h"

@implementation WalletBestBlockInfoApi
-(instancetype)init
{
    self = [super init];
    if (self){
        
        self.httpAddress =  [NSString stringWithFormat:@"%@%@",[WalletUserDefaultManager getBlockUrl],NewBlockInfoUrl];
    }
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    //add params
    NSMutableDictionary* dict = [super buildRequestDict];
    return dict;
}


-(Class)expectedModelClass
{
    return [WalletBlockInfoModel class];
}
@end
