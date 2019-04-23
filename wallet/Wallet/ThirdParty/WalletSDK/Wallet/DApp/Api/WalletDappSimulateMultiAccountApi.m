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
    
    NSMutableArray *clauseList = [NSMutableArray array];
    if (_clauseList.count > 0) {
        
        for (id clause in _clauseList) {
            if ([clause isKindOfClass:[ClauseModel class]]) {
                
                NSString *strClause = [clause yy_modelToJSONString];
                NSDictionary *dictClause = [NSJSONSerialization dictionaryWithJsonString:strClause];
                [clauseList addObject:dictClause];
            }else{
                [clauseList addObject:clause];
            }
        }
    }
    
    [dict setValueIfNotNil:clauseList forKey:@"clauses"];
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
