//
//  WalletDAppHandle+connexJS.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/23.
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
#import "WalletGetSymbolApi.h"
#import "WalletGetDecimalsApi.h"
#import "WalletDAppPeersApi.h"
#import "WalletBlockInfoApi.h"
#import "WalletDAppPeerModel.h"
#import "WalletDAppTransferDetailApi.h"
#import "SocketRocketUtility.h"
#import "WalletGetStorageApi.h"
#import "WalletDappLogEventApi.h"
#import "WalletDappSimulateMultiAccountApi.h"
#import "WalletDappSimulateAccountApi.h"

@implementation WalletDAppHandle (connexJS)

-(void)getGenesisBlockWithRequestId:(NSString *)requestId
                  completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    WalletGenesisBlockInfoApi *genesisBlock = [WalletGenesisBlockInfoApi new];
    [genesisBlock loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        NSDictionary *resultDict = [WalletTools packageWithRequestId:requestId
                                                               data:finishApi.resultDict
                                                               code:OK
                                                            message:@""];
        completionHandler([resultDict yy_modelToJSONString]);
        return;
    }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        NSDictionary *resultDict = [WalletTools packageWithRequestId:requestId
                                                               data:@""
                                                               code:ERROR_SERVER_DATA
                                                            message:ERROR_SERVER_DATA_MSG];
        completionHandler([resultDict yy_modelToJSONString]);
    }];
}

-(void)getStatusWithRequestId:(NSString *)requestId
            completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    WalletDAppPeersApi *peersApi = [[WalletDAppPeersApi alloc]init];
    
    [peersApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        NSString *blockNum = @"";
        NSArray *list = (NSArray *)finishApi.resultDict;
        
        for (NSDictionary *dict in list) {
            NSString *temp = dict[@"bestBlockID"];
            temp = [temp substringToIndex:10];
            BigNumber *new = [BigNumber bigNumberWithHexString:temp];
            BigNumber *old = [BigNumber bigNumberWithHexString:blockNum];
            if (new.decimalString.floatValue > old.decimalString.floatValue) {
                blockNum = temp;
            }
        }
        
        WalletBlockInfoApi *bestApi = [[WalletBlockInfoApi alloc]init];
        [bestApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
            
            WalletBlockInfoModel *blockModel = finishApi.resultModel;
            BigNumber *peerNum = [BigNumber bigNumberWithHexString:blockNum];
            CGFloat progress = peerNum.decimalString.floatValue/blockModel.number.floatValue;
            
            NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
            [dictParam setObject:@(progress) forKey:@"progress"];
            
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
            
        } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
            NSDictionary *resultDict = [WalletTools packageWithRequestId:requestId
                                                                    data:@""
                                                                    code:ERROR_SERVER_DATA
                                                                 message:ERROR_SERVER_DATA_MSG];
            completionHandler([resultDict yy_modelToJSONString]);
            
        }];
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        
        NSDictionary *resultDict = [WalletTools packageWithRequestId:requestId
                                                                data:@""
                                                                code:ERROR_SERVER_DATA
                                                             message:ERROR_SERVER_DATA_MSG];
        completionHandler([resultDict yy_modelToJSONString]);
        
    }];
}


- (void)methodAsClauseWithDictP:(NSDictionary *)dictP
                      requestId:(NSString *)requestId
                        webView:(WKWebView *)webView
                     callbackId:(NSString *)callbackId
{
    NSDictionary *dictclause = dictP[@"clause"];
    NSDictionary *dictOpts = dictP[@"opts"];
    NSString *revision = dictP[@"revision"];
    
    WalletDappSimulateAccountApi *accountApi = [[WalletDappSimulateAccountApi alloc]initClause:dictclause opts:dictOpts revision:revision];
    
    [accountApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        NSLog(@"ddd");
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:finishApi.resultDict
                                callbackId:callbackId
                                      code:OK];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        NSLog(@"ddd");
        [WalletTools callbackWithrequestId:requestId webView:webView data:finishApi.resultDict callbackId:callbackId code:ERROR_SERVER_DATA];
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
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        [WalletTools callbackWithrequestId:requestId webView:webView data:finishApi.resultDict callbackId:callbackId code:OK];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        
        [WalletTools callbackWithrequestId:requestId webView:webView data:finishApi.resultDict callbackId:callbackId code:ERROR_SERVER_DATA];
    }];
}

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
                                      code:ERROR_REQUEST_PARAMS];
        return;
    }
    
    WalletVETBalanceApi *vetBalanceApi = [[WalletVETBalanceApi alloc]initWith:address];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                     data:finishApi.resultDict
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
                                      code:ERROR_REQUEST_PARAMS];
        return;
    }
    
    WalletAccountCodeApi *vetBalanceApi = [[WalletAccountCodeApi alloc]initWithAddress:address];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                     data:finishApi.resultDict
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

- (void)getBlock:(NSString *)callbackId
         webView:(WKWebView *)webView
       requestId:(NSString *)requestId
        revision:(NSString *)revision
{
    BOOL revisionOK = NO;
    
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
                                      code:ERROR_REQUEST_PARAMS];
        return;
    }
    
    WalletBlockApi *vetBalanceApi = [[WalletBlockApi alloc]initWithRevision:revision];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                     data:finishApi.resultDict
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
                                      code:ERROR_REQUEST_PARAMS];
        return;
    }
    
    WalletDAppTransferDetailApi *vetBalanceApi = [[WalletDAppTransferDetailApi alloc]initWithTxid:txID];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        NSDictionary *balanceModel = finishApi.resultDict;

        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:balanceModel
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
                                      code:ERROR_REQUEST_PARAMS];
        return;
    }
    
    WalletTransantionsReceiptApi *vetBalanceApi = [[WalletTransantionsReceiptApi alloc]initWithTxid:txid];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        if (finishApi.resultDict) {
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:finishApi.resultDict
                                    callbackId:callbackId
                                          code:OK];
        }else{
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:@""
                                    callbackId:callbackId
                                          code:ERROR_SERVER_DATA];
        }
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_SERVER_DATA];
    }];
}

//获取本地wallet地址
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
                                      code:ERROR_INITDAPP_ERROR];
    }
}

- (void)tickerNextRequestId:(NSString *)requestId
                 callbackId:(NSString *)callbackId
{
    NSString *url = [[WalletUserDefaultManager getBlockUrl] stringByAppendingString:@"/subscriptions/block"];
    
    SocketRocketUtility *socket = [SocketRocketUtility instance];
    
    socket.requestIdList = @[requestId];
    socket.callbackId = callbackId;
    [socket SRWebSocketOpenWithURLString:url];
}

//vet 转账
- (void)VETTransferDictWithParamModel:(WalletSignParamModel *)paramModel
                   requestId:(NSString *)requestId
                     webView:(WKWebView *)webView
                  callbackId:(NSString *)callbackId
                               connex:(BOOL)bConnex

{
    if (![WalletTools fromISToAddress:paramModel.fromAddress to:paramModel.toAddress]) {
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_REQUEST_PARAMS];
        
        return;
    }
}

//vtho转账
- (void)VTHOTransferWithParamModel:(WalletSignParamModel *)paramModel
                    requestId:(NSString *)requestId
                      webView:(WKWebView *)webView
                   callbackId:(NSString *)callbackId
                            connex:(BOOL)bConnex
{
    
    CGFloat amountF = [BigNumber bigNumberWithHexString:paramModel.amount].decimalString.floatValue/pow(10, 18);
    
    if (![WalletTools errorAddressAlert:paramModel.toAddress] ||
        ![self errorAmount:[NSString stringWithFormat:@"%lf",amountF]]||
        ![WalletTools fromISToAddress:paramModel.fromAddress to:paramModel.toAddress]||
        paramModel.gas.integerValue == 0||
        paramModel.clauseData.length == 0) {
        
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_REQUEST_PARAMS];
        return;
    }
}

// contranct 签名
- (void)contractSignWithParamModel:(WalletSignParamModel *)paramModel
                         requestId:(NSString *)requestId
                           webView:(WKWebView *)webView
                    callbackId:(NSString *)callbackId
                            connex:(BOOL)bConnex
{
    if (paramModel.clauseData.length == 0 ||
        paramModel.gas.integerValue  == 0) {
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_REQUEST_PARAMS];
        
        return;
    }
}

- (void)certTransferParamModel:(NSDictionary *)callbackParams
                          from:(NSString *)from
                     requestId:(NSString *)requestId
                       webView:(WKWebView *)webView
                    callbackId:(NSString *)callbackId
{    
    NSDictionary *clauses = callbackParams[@"clauses"];
    WalletBlockInfoApi *bestApi = [[WalletBlockInfoApi alloc]init];
    [bestApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        WalletBlockInfoModel *blockModel = finishApi.resultModel;
        NSNumber *timestamp = (NSNumber *)blockModel.timestamp;
        
        
        NSString *time = [NSString stringWithFormat:@"%.0ld",(long)timestamp.integerValue];
        NSString *domain  = webView.URL.host;
        
        NSMutableDictionary *dictSignParam = [NSMutableDictionary dictionaryWithDictionary:clauses];
        
        [dictSignParam setValueIfNotNil:@(time.integerValue) forKey:@"timestamp"];
        [dictSignParam setValueIfNotNil:domain forKey:@"domain"];
        [dictSignParam setValueIfNotNil:from.lowercaseString forKey:@"signer"];

        NSString *packSign = [self packParam:dictSignParam];
        NSData *data = [packSign dataUsingEncoding:NSUTF8StringEncoding];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(onCertificate:signer:callback:)]) {
            
            [self.delegate onCertificate:data signer:from callback:^(NSData * _Nonnull signature) {
                
                NSString *hashSignture = [SecureData dataToHexString:signature];
                
                NSMutableDictionary *dictSub = [NSMutableDictionary dictionary];
                
                [dictSub setValueIfNotNil:dictSignParam[@"domain"] forKey:@"domain"];
                [dictSub setValueIfNotNil:from.lowercaseString forKey:@"signer"];
                [dictSub setValueIfNotNil:dictSignParam[@"timestamp"] forKey:@"timestamp"];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:dictSub forKey:@"annex"];
                [dict setObject:hashSignture forKey:@"signature"];
                
                [WalletTools callbackWithrequestId:requestId
                                           webView:webView
                                              data:dict
                                        callbackId:callbackId
                                              code:OK];
            }];
        }
        
    }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_CANCEL];
    }];
}

- (BOOL)errorAmount:(NSString *)amount
{
    // 例外情况 - VET 转账0
    BOOL bAmount = YES;
    
    // 金额逻辑校验
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
//        [WalletAlertShower showAlert:nil
//                                msg:VCNSLocalizedBundleString(@"h5_params_error", nil)
//                              inCtl:[WalletTools getCurrentVC]
//                              items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
//                         clickBlock:^(NSInteger index) {
//                         }];
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
                                 code:ERROR_SERVER_DATA];
}


- (void)filterDictParam:(NSDictionary *)dictParam
              requestId:(NSString *)requestId
                webView:(WKWebView *)webView
             callbackId:(NSString *)callbackId
{
    WalletDappLogEventApi *eventApi = [[WalletDappLogEventApi alloc]initWithKind:dictParam[@"kind"]];
    eventApi.dictRange = dictParam[@"filterBody"][@"range"];;
    eventApi.dictOptions = dictParam[@"filterBody"][@"options"];
    eventApi.dictCriteriaSet = dictParam[@"filterBody"][@"criteriaSet"];
    eventApi.order = dictParam[@"filterBody"][@"order"];
    
    [eventApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:finishApi.resultDict
                                callbackId:callbackId
                                      code:OK];
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_REQUEST_PARAMS];
    }];
}

- (void)explainDictParam:(NSDictionary *)dictParam
               requestId:(NSString *)requestId
                 webView:(WKWebView *)webView
              callbackId:(NSString *)callbackId
{
    NSLog(@"dd");
    NSArray *clauses = dictParam[@"clauses"];
    NSDictionary *options = dictParam[@"options"];
    NSString *rev = dictParam[@"rev"];
    WalletDappSimulateMultiAccountApi *multiApi = [[WalletDappSimulateMultiAccountApi alloc]initClause:clauses opts:options revision:rev];
    [multiApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:finishApi.resultDict
                                callbackId:callbackId
                                      code:OK];
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_REQUEST_PARAMS];
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
                
                injectJS = [injectJS stringByReplacingOccurrencesOfString:@"\"true\"" withString:@"true"];
                completionHandler(injectJS);
                
            }else{
               
                NSDictionary *resultDict = [WalletTools packageWithRequestId:requestId
                                                                        data:@"false"
                                                                        code:OK
                                                                     message:@""];
                NSString *injectJS = [resultDict yy_modelToJSONString];
                
                injectJS = [injectJS stringByReplacingOccurrencesOfString:@"\"false\"" withString:@"false"];
                
                completionHandler(injectJS);
                
            }
            
        }];
    }
}

- (NSString *)packParam:(NSDictionary *)param
{
    NSMutableDictionary *dictOrigin = [NSMutableDictionary dictionaryWithDictionary:param];
    
    NSArray *keys = [dictOrigin allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableArray *keyAndValueList = [NSMutableArray array];
    for (NSString *key in sortedArray) {
        NSString *value = dictOrigin[key];
        NSString *keyValue = nil;
        if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber *num = (NSNumber *)value;
            value = ((NSNumber *)num).stringValue;
            
            keyValue = [NSString stringWithFormat:@"\"%@\":%@",key,value];
        }else if([value isKindOfClass:[NSDictionary class]])
        {
            keyValue = [NSString stringWithFormat:@"\"%@\":%@",key, [self packParam:(NSDictionary *)value]];
        }else{
            keyValue = [NSString stringWithFormat:@"\"%@\":\"%@\"",key,value];
        }
        
        [keyAndValueList addObject:keyValue];
        
    }
    return [NSString stringWithFormat:@"{%@}",[keyAndValueList componentsJoinedByString:@","]];
}

@end
