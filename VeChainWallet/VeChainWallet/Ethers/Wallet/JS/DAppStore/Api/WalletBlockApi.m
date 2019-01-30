//
//  WalletBlockApi.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/18.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletBlockApi.h"

@implementation WalletBlockApi

-(instancetype)initWithRevision:(NSString *)revision
{
    self = [super init];
    if (self){
        self.requestMethod = RequestGetMethod;
        self.specialRequest = YES;
        httpAddress =  [NSString stringWithFormat:@"%@/blocks/%@",[WalletUserDefaultManager getBlockUrl],revision];
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
