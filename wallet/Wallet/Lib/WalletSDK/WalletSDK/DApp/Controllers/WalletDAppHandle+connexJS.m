//
//  WalletDAppHandle+connexJS.m
//  VeWallet
//
//  Created by Tom on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppHandle+connexJS.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletVETBalanceApi.h"
#import <WebKit/WebKit.h>
#import "WalletAccountCodeApi.h"
#import "WalletBlockApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletManageModel.h"
#import "WalletDAppPeersApi.h"
#import "WalletBestBlockInfoApi.h"
#import "WalletDAppPeerModel.h"
#import "WalletDAppTransferDetailApi.h"
#import "SocketRocketUtility.h"
#import "WalletGetStorageApi.h"
#import "WalletDappLogEventApi.h"
#import "WalletDappSimulateMultiAccountApi.h"
#import "WalletDappSimulateAccountApi.h"

#define nullString @"nu&*ll"

@implementation WalletDAppHandle (connexJS)

//Get the genesis block information
-(void)getGenesisBlockWithRequestId:(NSString *)requestId
                  completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    WalletGenesisBlockInfoApi *genesisBlock = [WalletGenesisBlockInfoApi new];
    [genesisBlock loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        NSDictionary *resultDict = [WalletTools packageWithRequestId:requestId
                                                               data:finishApi.resultDict
                                                               code:OK
                                                            message:@""];
        completionHandler([resultDict yy_modelToJSONString]);
        return;
    }failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        NSDictionary *resultDict = [WalletTools packageWithRequestId:requestId
                                                               data:@""
                                                               code:ERROR_NETWORK
                                                            message:ERROR_NETWORK_MSG];
        completionHandler([resultDict yy_modelToJSONString]);
    }];
}

//Get block status
-(void)getStatusWithRequestId:(NSString *)requestId
            completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    WalletDAppPeersApi *peersApi = [[WalletDAppPeersApi alloc]init];
    [peersApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        NSString *blockNum = @"";
        NSArray *list = (NSArray *)finishApi.resultDict;
        
        for (NSDictionary *dict in list) {
            NSString *bestBlockID = dict[@"bestBlockID"];
            bestBlockID = [bestBlockID substringToIndex:10];
            BigNumber *new = [BigNumber bigNumberWithHexString:bestBlockID];
            BigNumber *old = [BigNumber bigNumberWithHexString:blockNum];
            if (new.decimalString.floatValue > old.decimalString.floatValue) {
                blockNum = bestBlockID;
            }
        }
        
        // Get best block info
        WalletBestBlockInfoApi *bestApi = [[WalletBestBlockInfoApi alloc]init];
        [bestApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
            
            WalletBlockInfoModel *blockModel = finishApi.resultModel;
            BigNumber *peerNum = [BigNumber bigNumberWithHexString:blockNum];
            CGFloat progress = peerNum.decimalString.floatValue/blockModel.number.floatValue;
            
            NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
            [dictParam setValueIfNotNil:@(progress) forKey:@"progress"];
            
            NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
            [subDict setValueIfNotNil:blockModel.id         forKey:@"id"];
            [subDict setValueIfNotNil:@(blockModel.number.integerValue) forKey:@"number"];
            [subDict setValueIfNotNil:@(blockModel.timestamp.integerValue) forKey:@"timestamp"];
            [subDict setValueIfNotNil:blockModel.parentID    forKey:@"parentID"];
            
            [dictParam setValueIfNotNil:subDict forKey:@"head"];
            
            NSDictionary *resultDict = [WalletTools packageWithRequestId:requestId
                                                                    data:dictParam
                                                                    code:OK
                                                                 message:@""];
            completionHandler([resultDict yy_modelToJSONString]);
            
        } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
            NSDictionary *resultDict = [WalletTools packageWithRequestId:requestId
                                                                    data:@""
                                                                    code:ERROR_NETWORK
                                                                 message:ERROR_NETWORK_MSG];
            completionHandler([resultDict yy_modelToJSONString]);
            
        }];
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        
        NSDictionary *resultDict = [WalletTools packageWithRequestId:requestId
                                                                data:@""
                                                                code:ERROR_NETWORK
                                                             message:ERROR_NETWORK_MSG];
        completionHandler([resultDict yy_modelToJSONString]);
        
    }];
}


- (void)methodAsCallWithDictP:(NSDictionary *)dictP
                      requestId:(NSString *)requestId
                        webView:(WKWebView *)webView
                     callbackId:(NSString *)callbackId
{
    NSString *revision        = dictP[@"revision"];
    NSDictionary *dictOpts    = dictP[@"opts"];
    NSDictionary *dictclause  = dictP[@"clause"];
    
    WalletDappSimulateAccountApi *accountApi = [[WalletDappSimulateAccountApi alloc]initClause:dictclause opts:dictOpts revision:revision];
    accountApi.supportOtherDataFormat = YES;
    [accountApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:finishApi.resultDict
                                    callbackId:callbackId
                                          code:OK];
        }else{
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackId
                                          code:OK];
        }
        
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (void)getStorageApiDictParam:(NSDictionary *)dictParam
                     requestId:(NSString *)requestId
                       webView:(WKWebView *)webView
                    callbackId:(NSString *)callbackId
{
    NSString *key = dictParam[@"key"];
    NSString *address = dictParam[@"address"];
    
    WalletGetStorageApi *vetBalanceApi = [[WalletGetStorageApi alloc]initWithkey:key address:address];
    vetBalanceApi.supportOtherDataFormat = YES;
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:finishApi.resultDict
                                    callbackId:callbackId
                                          code:OK];
        }else{
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackId
                                          code:OK];
        }
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_NETWORK];
    }];
}

//Get VET balance
- (void)getAccountRequestId:(NSString *)requestId
                    webView:(WKWebView *)webView
                    address:(NSString *)address
                 callbackId:(NSString *)callbackId
{
    if (![WalletTools errorAddressAlert:address]) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_CANCEL];
        return;
    }
    
    WalletVETBalanceApi *vetBalanceApi = [[WalletVETBalanceApi alloc]initWith:address];
    vetBalanceApi.supportOtherDataFormat = YES;
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:finishApi.resultDict
                                    callbackId:callbackId
                                          code:OK];
        }else{
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackId
                                          code:OK];
        }
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (void)getAccountCode:(NSString *)callbackId
               webView:(WKWebView *)webView
             requestId:(NSString *)requestId
               address:(NSString *)address
{
    if (![WalletTools errorAddressAlert:address]) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_CANCEL];
        return;
    }
    
    WalletAccountCodeApi *vetBalanceApi = [[WalletAccountCodeApi alloc]initWithAddress:address];
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:finishApi.resultDict
                                    callbackId:callbackId
                                          code:OK];
        }else{
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackId
                                          code:OK];
        }
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (void)getBlock:(NSString *)callbackId
         webView:(WKWebView *)webView
       requestId:(NSString *)requestId
        revision:(NSString *)revision
{
    BOOL revisionOK = NO;
    
    //Revision : "best" or decimal
    if (revision != nil ) {
        revisionOK = YES;
    }else if ([revision isEqualToString:@"best"]) {
        revisionOK = YES;
    }else{
        
        if ([WalletTools checkDecimalStr:revision]) {
            revisionOK = YES;
        }
    }
    
    if (!revisionOK) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_CANCEL];
        return;
    }
    
    WalletBlockApi *vetBalanceApi = [[WalletBlockApi alloc]initWithRevision:revision];
    vetBalanceApi.supportOtherDataFormat = YES;
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:finishApi.resultDict
                                    callbackId:callbackId
                                          code:OK];
            
        }else {
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackId
                                          code:OK];
        }
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (void)getTransaction:(NSString *)callbackId
               webView:(WKWebView *)webView
             requestId:(NSString *)requestId
                  txID:(NSString *)txID
{
    if (txID == nil || ![WalletTools checkHEXStr:txID] || txID.length != 66) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_CANCEL];
        return;
    }
    
    WalletDAppTransferDetailApi *vetBalanceApi = [[WalletDAppTransferDetailApi alloc]initWithTxid:txID];
    vetBalanceApi.supportOtherDataFormat = YES;
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            NSDictionary *balanceModel = finishApi.resultDict;
            
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:balanceModel
                                    callbackId:callbackId
                                          code:OK];
        }else{
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackId
                                          code:OK];
        }
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (void)getTransactionReceipt:(NSString *)callbackId
                      webView:(WKWebView *)webView
                    requestId:(NSString *)requestId
                         txid:(NSString *)txid
{
    if (txid == nil || ![WalletTools checkHEXStr:txid] || txid.length != 66) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_CANCEL];
        return;
    }
    
    WalletTransantionsReceiptApi *vetBalanceApi = [[WalletTransantionsReceiptApi alloc]initWithTxid:txid];
    vetBalanceApi.supportOtherDataFormat = YES;
    [vetBalanceApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        if (finishApi.resultDict) {
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:finishApi.resultDict
                                    callbackId:callbackId
                                          code:OK];
        }else{
            // The server returns an empty payment and needs to be changed to null.
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:nullString
                                    callbackId:callbackId
                                          code:OK];
        }
        
        
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_NETWORK];
    }];
}



- (void)tickerNextRequestId:(NSString *)requestId
                 callbackId:(NSString *)callbackId
{
    NSString *url = [[WalletUserDefaultManager getBlockUrl] stringByAppendingString:@"/subscriptions/block"];
    
    // Open web socket
    SocketRocketUtility *socket = [SocketRocketUtility instance];
    
    socket.requestIdList = @[requestId];
    socket.callbackId = callbackId;
    [socket SRWebSocketOpenWithURLString:url];
}

// Cert sign
- (void)certTransferParamModel:(NSDictionary *)callbackParams
                          from:(NSString *)from
                     requestId:(NSString *)requestId
                       webView:(WKWebView *)webView
                    callbackId:(NSString *)callbackId
{    
    NSDictionary *clauses = callbackParams[@"clauses"];
    
    if (![clauses isKindOfClass:[NSDictionary class]]) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_CANCEL];
        return;
    }
    // Get the timestamp on the block
    WalletBestBlockInfoApi *bestApi = [[WalletBestBlockInfoApi alloc]init];
    [bestApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        
        WalletBlockInfoModel *blockModel = finishApi.resultModel;
        NSNumber *timestamp = (NSNumber *)blockModel.timestamp;
        
        
        NSString *time = [NSString stringWithFormat:@"%.0ld",(long)timestamp.integerValue];
        NSString *domain  = webView.URL.host;
        
        NSMutableDictionary *dictSignParam = [NSMutableDictionary dictionaryWithDictionary:clauses];
        
        [dictSignParam setValueIfNotNil:@(time.integerValue) forKey:@"timestamp"];
        [dictSignParam setValueIfNotNil:domain forKey:@"domain"];
        [dictSignParam setValueIfNotNil:from.lowercaseString forKey:@"signer"];

        if (self.delegate && [self.delegate respondsToSelector:@selector(onCertificate:signer:callback:)]) {
            
            [self.delegate onCertificate:dictSignParam signer:from callback:^(NSString * _Nonnull signer, NSData * _Nonnull signature) {
                
                NSString *hashSignture = [SecureData dataToHexString:signature];
                
                NSMutableDictionary *dictSub = [NSMutableDictionary dictionary];
                
                [dictSub setValueIfNotNil:dictSignParam[@"domain"] forKey:@"domain"];
                [dictSub setValueIfNotNil:signer.lowercaseString forKey:@"signer"];
                [dictSub setValueIfNotNil:dictSignParam[@"timestamp"] forKey:@"timestamp"];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValueIfNotNil:dictSub forKey:@"annex"];
                [dict setValueIfNotNil:hashSignture forKey:@"signature"];
                
                [WalletTools callbackWithrequestId:requestId
                                           webView:webView
                                              data:dict
                                        callbackId:callbackId
                                              code:OK];
            }];
        }else{
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:@""
                                    callbackId:callbackId
                                          code:ERROR_CANCEL];
        }
        
    }failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_NETWORK];
    }];
}

- (BOOL)errorAmount:(NSString *)amount
{
    // Exception - VET Transfer 0
    BOOL bAmount = YES;
    
    // Amount logic check
    if ([amount floatValue] <= 0
        || [Payment parseEther:amount] == nil
        || amount.length == 0) {
        bAmount = NO;
    }
    
    if (amount.length == 0) {
        bAmount = NO;
    }
    
    if ([amount floatValue] == 0
        && [[Payment parseEther:amount] lessThanEqualTo:[BigNumber constantZero]]){
        bAmount = YES;
    }
    if (!bAmount) {

        return NO;
    }
    return YES;
}

- (void)failResult:(NSString *)requestId
        callbackId:(NSString *)callbackId
           webView:(WKWebView *)webView
{
    [WalletTools callbackWithrequestId:requestId
                               webView:webView
                                 data:@""
                           callbackId:callbackId
                                 code:ERROR_NETWORK];
}


- (void)filterDictParam:(NSDictionary *)dictParam
              requestId:(NSString *)requestId
                webView:(WKWebView *)webView
             callbackId:(NSString *)callbackId
{
    WalletDappLogEventApi *eventApi = [[WalletDappLogEventApi alloc]initWithKind:dictParam[@"kind"]];
    eventApi.dictRange          = dictParam[@"filterBody"][@"range"];;
    eventApi.dictOptions        = dictParam[@"filterBody"][@"options"];
    eventApi.dictCriteriaSet    = dictParam[@"filterBody"][@"criteriaSet"];
    eventApi.order              = dictParam[@"filterBody"][@"order"];
    
    [eventApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:finishApi.resultDict
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

- (void)explainDictParam:(NSDictionary *)dictParam
               requestId:(NSString *)requestId
                 webView:(WKWebView *)webView
              callbackId:(NSString *)callbackId
{
    NSArray *clauses = dictParam[@"clauses"];
    NSDictionary *options = dictParam[@"options"];
    NSString *rev = dictParam[@"rev"];
    
    if ([WalletTools isEmpty:clauses] ) {
        
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_CANCEL];
        return;
    }
    
    WalletDappSimulateMultiAccountApi *multiApi = [[WalletDappSimulateMultiAccountApi alloc]initClause:clauses opts:options revision:rev];
    [multiApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:finishApi.resultDict
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

- (void)checkAddressOwn:(NSString *)address
              requestId:(NSString *)requestId
             callbackId:(NSString *)callbackId
      completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    if (self.delegate
        &&[self.delegate respondsToSelector:@selector(onCheckOwnAddress:callback:)]) {
        [self.delegate onCheckOwnAddress:address callback:^(BOOL result) {
            
            if (result) {
               
                NSDictionary *resultDict = [WalletTools packageWithRequestId:requestId
                                                                        data:@"true"
                                                                        code:OK
                                                                     message:@""];
                NSString *injectJS = [resultDict yy_modelToJSONString];
                
                //Remove "
                injectJS = [injectJS stringByReplacingOccurrencesOfString:@"\"true\"" withString:@"true"];
                completionHandler(injectJS);
                
            }else{
               
                NSDictionary *resultDict = [WalletTools packageWithRequestId:requestId
                                                                        data:@"false"
                                                                        code:OK
                                                                     message:@""];
                NSString *injectJS = [resultDict yy_modelToJSONString];
                
                //Remove "
                injectJS = [injectJS stringByReplacingOccurrencesOfString:@"\"false\"" withString:@"false"];
                
                completionHandler(injectJS);
            }
        }];
    }else{
        completionHandler(@"{}");
    }
}




@end
