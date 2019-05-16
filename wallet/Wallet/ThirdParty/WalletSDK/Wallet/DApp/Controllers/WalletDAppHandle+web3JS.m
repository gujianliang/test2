//
//  WalletDAppHandle+web3JSHardle.m
//  VeWallet
//
//  Created by Tom on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppHandle+web3JS.h"
#import "WalletVETBalanceApi.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletVETBalanceApi.h"
#import <WebKit/WebKit.h>
#import "WalletAccountCodeApi.h"
#import "WalletBlockApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletManageModel.h"
#import "WalletDAppHandle+connexJS.h"


@implementation WalletDAppHandle (web3JS)

// Get vet amount
- (void)getBalance:(NSString *)callbackId
           webView:(WKWebView *)webView
         requestId:(NSString *)requestId
           address:(NSString *)address
{
    WalletVETBalanceApi *vetBalanceApi = [[WalletVETBalanceApi alloc]initWith:address];
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        WalletBalanceModel *balanceModel = finishApi.resultModel;
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:balanceModel.balance
                               callbackId:callbackId
                                     code:OK];
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_SERVER_DATA];
    }];
}

//Get NodeUrl
- (void)getNodeUrl:(NSString *)requestId
  completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
//返回当前的 block url
    NSDictionary *dict1 = [WalletTools packageWithRequestId:requestId
                                                       data:[WalletUserDefaultManager getBlockUrl]
                                                       code:OK
                                                    message:@""];
    completionHandler([dict1 yy_modelToJSONString]);
}


//Get chaintag
- (void)getChainTag:(NSString *)requestId
  completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    // Get the creation block id to do chainTag
    WalletGenesisBlockInfoApi *genesisBlock = [WalletGenesisBlockInfoApi new];
    [genesisBlock loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        WalletBlockInfoModel *genesisblockModel = finishApi.resultModel;
        NSString *blockID = genesisblockModel.id;
        NSString *chainTag = [NSString stringWithFormat:@"0x%@", [blockID substringFromIndex:blockID.length-2]];
        
        NSDictionary *dict1 = [WalletTools packageWithRequestId:requestId
                                                           data:chainTag
                                                           code:OK
                                                        message:@""];
        completionHandler([dict1 yy_modelToJSONString]);
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        completionHandler(@"{}");
    }];
}


@end
