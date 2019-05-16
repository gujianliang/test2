//
//  WalletCheckVersionApi.m
//  WalletSDK
//
//  Created by Tom on 2019/5/9.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import "WalletCheckVersionApi.h"

@implementation WalletCheckVersionApi
{
    NSString *_version;
    NSString *_language;
}
-(instancetype)initWithVersion:(NSString *)version language:(NSString *)language
{
    self = [super init];
    if (self){
        _version = version;
        _language = language;
        
        self.requestMethod = RequestPostMethod;
        
        httpAddress = @"https://version-management-test.vechaindev.com/api/v1/version/";
    }
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    //增加参数
    NSMutableDictionary* dict = [super buildRequestDict];
    [dict setValueIfNotNil:@"iOS" forKey:@"platformType"];
    [dict setValueIfNotNil:_version forKey:@"softwareVersion"];
    [dict setValueIfNotNil:_language forKey:@"language"];
    [dict setValueIfNotNil:@"appstore" forKey:@"channel"];
    [dict setValueIfNotNil:@"27a7898b733ce99d90ec5338de5ced52" forKey:@"appid"];

    return dict;
}


-(Class)expectedModelClass
{
    return [NSDictionary class];
}
@end
