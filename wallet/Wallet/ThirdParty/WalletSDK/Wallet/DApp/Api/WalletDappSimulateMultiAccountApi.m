//
//  WalletDappSimulateMultiAccountApi.m
//  VeWallet
//
//  Created by 曾新 on 2019/4/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDappSimulateMultiAccountApi.h"

@implementation WalletDappSimulateMultiAccountApi
{
    NSArray *_clauseList;
    NSDictionary *_opts;
}

-(instancetype)initClause:(NSArray *)clauseList opts:(NSDictionary *)opts  revision:(NSString *)revision
{
    self = [super init];
    if (self){
        self.requestMethod = RequestPostMethod;
        _clauseList = clauseList;
        _opts = opts;
        
         httpAddress =  [NSString stringWithFormat:@"%@/accounts/*",[WalletUserDefaultManager getBlockUrl]];
        if (revision.length > 0) {
            NSString *temp = [NSString stringWithFormat:@"?revision=%@",revision];
            httpAddress = [httpAddress stringByAppendingString:temp];
        }
    }
    
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    //增加参数
    NSMutableDictionary* dict = [super buildRequestDict];
    [dict setValueIfNotNil:_clauseList forKey:@"clauses"];
    [dict setValueIfNotNil:_opts[@"gas"] forKey:@"gas"];
    [dict setValueIfNotNil:_opts[@"gasPrice"] forKey:@"gasPrice"];
    [dict setValueIfNotNil:_opts[@"caller"] forKey:@"caller"];
    
    return dict;
}


-(Class)expectedModelClass
{
    return [NSDictionary class];
}

@end
