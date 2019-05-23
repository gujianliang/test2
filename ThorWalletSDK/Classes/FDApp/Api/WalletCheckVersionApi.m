//
//  WalletCheckVersionApi.m
//  WalletSDK
//
//  Created by Tom on 2019/5/9.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletCheckVersionApi.h"
#import "WalletDAppHead.h"

@implementation WalletCheckVersionApi
{
    NSString *_language;
}
-(instancetype)initWithLanguage:(NSString *)language
{
    self = [super init];
    if (self){
        _language = language;
        
        self.requestMethod = RequestPostMethod;
        if ([[WalletUserDefaultManager getBlockUrl] isEqualToString: Test_Node]) {
            self.httpAddress = @"https://version-management-test.vechaindev.com/api/v1/version/";

        }else{
            self.httpAddress = @"https://version-management.vechain.com/api/v1/version/";
        }
    }
    return self;
}

-(NSMutableDictionary*)buildRequestDict
{
    // increase the parameter
    NSMutableDictionary* dict = [super buildRequestDict];
    [dict setValueIfNotNil:@"iOS" forKey:@"platformType"];
    [dict setValueIfNotNil:SDKVersion forKey:@"softwareVersion"];
    [dict setValueIfNotNil:_language forKey:@"language"];
    [dict setValueIfNotNil:@"appstore" forKey:@"channel"];
 
    if ([[WalletUserDefaultManager getBlockUrl] isEqualToString: Test_Node]) {
        [dict setValueIfNotNil:AppId_Test forKey:@"appid"];

     }else{
         [dict setValueIfNotNil:AppId forKey:@"appid"];
     }

    return dict;
}


-(Class)expectedModelClass
{
    return [NSDictionary class];
}
@end
