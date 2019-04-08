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
              completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    NSDictionary *abi = dictP[@"abi"];
    NSString *methodName = abi[@"name"];
    NSArray *paramList = abi[@"inputs"];
    NSMutableArray *subInput = [NSMutableArray array];
    for (NSDictionary *subInputDict in paramList) {
        NSString *type = subInputDict[@"type"];
        if (type.length > 0) {
            [subInput addObject:type];
        }
    }
    NSString *incodeStr = @"";
    if (subInput.count > 0) {
        
        incodeStr = [NSString stringWithFormat:@"%@(%@)",methodName,[subInput componentsJoinedByString:@","]];
    }else{
        incodeStr = [NSString stringWithFormat:@"%@()",methodName];
    };
    
    NSData *incodeData =[incodeStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decodeData = [SecureData KECCAK256:incodeData];
    NSString *decodeStr = [SecureData dataToHexString:decodeData];
    if (decodeStr.length >= 10) {
        NSDictionary *resultDict = [WalletTools packageWithRequestId:requestId
                                                               data:[decodeStr substringToIndex:10]
                                                               code:OK
                                                            message:@""];
        completionHandler([resultDict yy_modelToJSONString]);
    }
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
    
//    [self showSignView:WalletVETTransferType paramModel:paramModel requestId:requestId webView:webView callbackId:callbackId connex:bConnex];
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
    
//    [self showSignView:WalletTokenTransferType paramModel:paramModel requestId:requestId webView:webView callbackId:callbackId connex:bConnex];
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
    
//    [self showSignView:WalletContranctTransferType paramModel:paramModel requestId:requestId webView:webView callbackId:callbackId connex:bConnex];
}

//- (void)certTransferParamModel:(WalletSignParamModel *)paramModel
//                    requestId:(NSString *)requestId
//                      webView:(WKWebView *)webView
//                   callbackId:(NSString *)callbackId
//{
////#warning
//
////    NSString *purpose = dictParam[@"purpose"];
////    NSString *payload = dictParam[@"payload"][@"type"];
////    NSString *content = dictParam[@"payload"][@"content"];
////
////    if (purpose.length == 0 ||
////        payload.length == 0 ||
////        content.length == 0 ) {
////
////        [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_REQUEST_PARAMS];
////
////        return;
////    }
////    WalletSignatureView *signaVC = [[WalletSignatureView alloc] initWithFrame:[UIScreen mainScreen].bounds];
////    signaVC.tag = SignViewTag;
////    signaVC.transferType = WalletVETTransferType;
////
////#warning
//////    signaVC.jsUse = YES;
//////    signaVC.bCert = YES;
////    [signaVC updateView:from
////              toAddress:@""
////                 amount:[NSString stringWithFormat:@"%.2d",0]
////                 params:@[dictParam]];
////    [[WalletTools getCurrentVC].view addSubview:signaVC];
////
////    signaVC.transferBlock = ^(NSString * _Nonnull txid) {
////        NSLog(@"txid = %@",txid);
////        if (txid.length == 0) {
////
////            [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_CANCEL];
////        }else{
////
////            [WalletTools callbackWithrequestId:requestId webView:webView data:txid callbackId:callbackId code:OK];
////        }
////    };
//}

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
    
    if (amount.length > 20) {
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

////调用签名view
//- (void)showSignView:(WalletTransferType)transferType paramModel:(WalletSignParamModel *)paramModel requestId:(NSString *)requestId webView:(WKWebView *)webView callbackId:(NSString *)callbackId connex:(BOOL)bConnex
//{
//    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
//    signatureView.tag = SignViewTag;
//    signatureView.transferType = transferType;
//    [signatureView updateViewParamModel:paramModel];
//    
//    [[WalletTools getCurrentNavVC].view addSubview:signatureView];
//    
//    signatureView.transferBlock = ^(NSString * _Nonnull txid ,NSInteger code) {
//#if ReleaseVersion
//        NSLog(@"txid = %@",txid);
//#endif
//        if (txid.length != 0) {
//            id data = nil;
//            if (bConnex) {
//                NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
//                [dictData setObject:txid forKey:@"txId"];
//                [dictData setObject:paramModel.fromAddress forKey:@"signer"];
//                
//                data = dictData;
//            }else{
//                data = txid;
//            }
//            [WalletTools callbackWithrequestId:requestId
//                                       webView:webView
//                                          data:data
//                                    callbackId:callbackId
//                                          code:OK];
//        }else{
//            [WalletTools callbackWithrequestId:requestId
//                                       webView:webView
//                                          data:@""
//                                    callbackId:callbackId
//                                          code:code];
//        }
//    };
//}
@end
