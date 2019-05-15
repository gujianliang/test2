//
//  WalletDappSimulateAccountApi.m
//  VeWallet
//
//  Created by Tom on 2019/4/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDappSimulateAccountApi.h"

@implementation WalletDappSimulateAccountApi
{
//    NSString *_data;
//    NSString *_to;
//    NSString *_value;
//    NSString *_gas;
//    NSString *_gasPrice;
//    NSString *_caller;
    
    NSDictionary *_clause;
    NSDictionary *_opts;

}

-(instancetype)initClause:(NSDictionary *)clause opts:(NSDictionary *)opts  revision:(NSString *)revision
{
    self = [super init];
    if (self){
        self.requestMethod = RequestPostMethod;
        _clause = clause;
        _opts = opts;
        
        NSString *to = clause[@"to"];
        if (to.length > 0) {
            httpAddress =  [NSString stringWithFormat:@"%@/accounts/%@",[WalletUserDefaultManager getBlockUrl],to];
        }else{
            httpAddress =  [NSString stringWithFormat:@"%@/accounts/",[WalletUserDefaultManager getBlockUrl]];
        }
        
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
    [dict setValueIfNotNil:_clause[@"data"] forKey:@"data"];
    [dict setValueIfNotNil:_clause[@"value"] forKey:@"value"];
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
