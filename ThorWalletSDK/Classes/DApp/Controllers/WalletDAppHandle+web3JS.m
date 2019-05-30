/**
    Copyright (c) 2019 vechaindev <support@vechain.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

**/

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

// Get VET balance
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
                                     code:ERROR_NETWORK];
    }];
}

//Get NodeUrl
- (void)getNodeUrl:(NSString *)requestId
  completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    NSDictionary *dict = [WalletTools packageWithRequestId:requestId
                                                       data:[WalletUserDefaultManager getBlockUrl]
                                                       code:OK
                                                    message:@""];
    completionHandler([dict yy_modelToJSONString]);
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
        
        NSDictionary *dict = [WalletTools packageWithRequestId:requestId
                                                           data:chainTag
                                                           code:OK
                                                        message:@""];
        completionHandler([dict yy_modelToJSONString]);
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        completionHandler(@"{}");
    }];
}

//Get the local wallet address
-(void)getAccountsWithRequestId:(NSString *)requestId
                     callbackId:(NSString *)callbackId
                        webView:(WKWebView *)webView
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onGetWalletAddress:)]) {
        
        [self.delegate onGetWalletAddress:^(NSArray * _Nonnull addressList) {
            
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:addressList
                                    callbackId:callbackId
                                          code:OK];
        }];
        
    }else{
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_REJECTED];
    }
}
@end
