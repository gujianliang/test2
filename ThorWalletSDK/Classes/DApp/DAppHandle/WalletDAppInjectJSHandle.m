//
//  WalletDAppInjectJSHandle.m
//  AFNetworking
//
//  Created by 曾新 on 2019/6/6.
//

#import "WalletCheckVersionApi.h"
#import "WalletDAppInjectJSHandle.h"
#import "WalletVersionModel.h"

@implementation WalletDAppInjectJSHandle

+ (void)injectJS:(WKWebViewConfiguration *)config
         callback:(void (^)(WalletVersionModel *versionModel))callback
{
    // Check sdk version
    WalletCheckVersionApi *checkApi = [[WalletCheckVersionApi alloc]initWithLanguage:[self getLanuage]];
    [checkApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        NSDictionary *dataDict = finishApi.resultDict[@"data"];
       
       WalletVersionModel *versionModel = [WalletVersionModel yy_modelWithDictionary:dataDict];
        
        BOOL forceUpdate = [self analyzeVersion:versionModel];
        if (!forceUpdate) {
            [self inject:config];
        }
        callback(versionModel);
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        
    }];
}

+ (BOOL)analyzeVersion:(WalletVersionModel *)versionModel
{
    NSString *update        = versionModel.update;
    NSString *latestVersion = versionModel.latestVersion;
    NSString *description   = versionModel.pdescription;
    
    //Update = 1 : forced upgrade
    if (update.boolValue) {
        NSLog(@"Wallet SDK must update version url:%@, Current version:%@. Latest version:%@,  Description:%@",versionModel.url,SDKVersion,latestVersion,description);
    }else{
        if (![SDKVersion isEqualToString:latestVersion]) {
            NSLog(@"Wallet SDK update version url:%@, Current version:%@. Latest version:%@,  Description:%@",versionModel.url,SDKVersion,latestVersion,description);
        }
    }
    
    return update.boolValue;
}

+ (void)inject:(WKWebViewConfiguration *)config
{
    
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
                            stringByAppendingPathComponent:@"/ThorWalletSDKBundle.bundle"];
    
    
    if(!bundlePath){
        return ;
    }
    NSString *path = [bundlePath stringByAppendingString:@"/connex.js"];
    NSString *connex_js = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    connex_js = [connex_js stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    WKUserScript* userScriptConnex = [[WKUserScript alloc] initWithSource:connex_js
                                                            injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                         forMainFrameOnly:YES];
    [config.userContentController addUserScript:userScriptConnex];
    
    
    //Inject web3 js
    NSString *web3Path = [bundlePath stringByAppendingString:@"/web3.js"];
    NSString *web3js = [NSString stringWithContentsOfFile:web3Path encoding:NSUTF8StringEncoding error:nil];
    web3js = [web3js stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    WKUserScript* userScriptWeb3 = [[WKUserScript alloc] initWithSource:web3js
                                                          injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                       forMainFrameOnly:YES];
    [config.userContentController addUserScript:userScriptWeb3];
}

// Get phone language
+(NSString *)getLanuage
{
    NSString *language = @"";
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *localeLanguageCode = [appLanguages objectAtIndex:0];
    
    if ([localeLanguageCode containsString:@"zh"]) {
        language = @"zh-Hans";
        
    }else{
        language = @"en";
    }
    
    return language;
}

@end
