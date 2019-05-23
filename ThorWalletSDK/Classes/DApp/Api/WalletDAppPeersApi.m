//
//  WalletDAppPeersApi.m
//  VeWallet
//
//  Created by Tom on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppPeersApi.h"

@implementation WalletDAppPeersApi

-(instancetype)init
{
    self = [super init];
    if (self){
        self.requestMethod = RequestGetMethod;
        self.specialRequest = YES;
        self.httpAddress =  [NSString stringWithFormat:@"%@/node/network/peers",[WalletUserDefaultManager getBlockUrl]];
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
