//
//  WalletDappLogTransferApi.m
//  VeWallet
//
//  Created by Tom on 2019/4/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDappLogTransferApi.h"

@implementation WalletDappLogTransferApi

-(instancetype)init
{
    self = [super init];
    if (self){
        self.requestMethod = RequestPostMethod;
        
        self.httpAddress =  [NSString stringWithFormat:@"%@/logs/transfer",[WalletUserDefaultManager getBlockUrl]];
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
