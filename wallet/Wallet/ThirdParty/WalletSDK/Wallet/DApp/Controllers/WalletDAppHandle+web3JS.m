//
//  WalletDAppHandle+web3JSHardle.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/23.
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
#import "WalletGetSymbolApi.h"
#import "WalletGetDecimalsApi.h"
#import "WalletSingletonHandle.h"
#import "WalletDAppHandle+connexJS.h"


@implementation WalletDAppHandle (web3JS)

//获取vet 金额
- (void)getBalance:(NSString *)callbackId
           webView:(WKWebView *)webView
         requestId:(NSString *)requestId
           address:(NSString *)address
{
    WalletVETBalanceApi *vetBalanceApi = [[WalletVETBalanceApi alloc]initWith:address];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        WalletBalanceModel *balanceModel = finishApi.resultModel;
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:balanceModel.balance
                               callbackId:callbackId
                                     code:OK];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_SERVER_DATA];
    }];
}

//获得wallet 地址
- (void)getAddress:(WKWebView *)webView requestId:(NSString *)requestId callbackId:(NSString *)callbackId
{
    NSMutableArray *addressList = [NSMutableArray array];
    WalletSingletonHandle *single = [WalletSingletonHandle shareWalletHandle];
    
    for (WalletManageModel *model in [single getAllWallet]) {
        [addressList addObject:model.address];
    }
    
    [WalletTools callbackWithrequestId:requestId
                               webView:webView
                                  data:addressList
                            callbackId:callbackId
                                  code:OK];
}

//获得NodeUrl
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


//获得chaintag
- (void)getChainTag:(NSString *)requestId
  completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    // 拉创世区块id做chainTag
    WalletGenesisBlockInfoApi *genesisBlock = [WalletGenesisBlockInfoApi new];
    [genesisBlock loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        WalletBlockInfoModel *genesisblockModel = finishApi.resultModel;
        NSString *blockID = genesisblockModel.id;
        NSString *chainTag = [NSString stringWithFormat:@"0x%@", [blockID substringFromIndex:blockID.length-2]];
        
        NSDictionary *dict1 = [WalletTools packageWithRequestId:requestId
                                                           data:chainTag
                                                           code:OK
                                                        message:@""];
        completionHandler([dict1 yy_modelToJSONString]);
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        completionHandler(@"{}");
    }];
}


@end
