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
#import "WalletSignatureView.h"
#import "WalletGetSymbolApi.h"
#import "WalletGetDecimalsApi.h"
#import "WalletDAppPeersApi.h"
#import "WalletBlockInfoApi.h"
#import "WalletDAppPeerModel.h"
#import "WalletDAppTransferDetailApi.h"
#import "WalletSingletonHandle.h"

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
            [subDict setValueIfNotNil:blockModel.number     forKey:@"number"];
            [subDict setValueIfNotNil:blockModel.timestamp  forKey:@"timestamp"];
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


- (void)getAccountRequestId:(NSString *)requestId
                    webView:(WKWebView *)webView
                    address:(NSString *)address
                 callbackId:(NSString *)callbackId
{
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
    WalletAccountCodeApi *vetBalanceApi = [[WalletAccountCodeApi alloc]initWithAddress:address];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        NSDictionary *balanceModel = finishApi.resultDict;
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                     data:balanceModel[@"code"]
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
    WalletTransantionsReceiptApi *vetBalanceApi = [[WalletTransantionsReceiptApi alloc]initWithTxid:txid];
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

-(void)getAccountsWithRequestId:(NSString *)requestId
                     callbackId:(NSString *)callbackId
                        webView:(WKWebView *)webView
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

- (void)VETTransferDictWithParamModel:(WalletSignParamModel *)paramModel
                   requestId:(NSString *)requestId
                     webView:(WKWebView *)webView
                  callbackId:(NSString *)callbackId

{
    if (![WalletTools errorAddressAlert:paramModel.toAddress] ||
        ![WalletTools fromISToAddress:paramModel.fromAddress to:paramModel.toAddress]
        ||!(paramModel.gas.integerValue > 0)) {
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_REQUEST_PARAMS];
        
        return;
    }
    
    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
    signatureView.transferType = JSVETTransferType;
    [signatureView updateViewParamModel:paramModel];
    
    [[WalletTools getCurrentVC].navigationController.view addSubview:signatureView];
    
    signatureView.transferBlock = ^(NSString * _Nonnull txid) {
        
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:txid
                                callbackId:callbackId
                                      code:OK];
    };
}

- (void)VTHOTransferWithParamModel:(WalletSignParamModel *)paramModel
                    requestId:(NSString *)requestId
                      webView:(WKWebView *)webView
                   callbackId:(NSString *)callbackId
{
    
    WalletGetSymbolApi *getSymbolApi = [[WalletGetSymbolApi alloc]initWithTokenAddress:paramModel.tokenAddress];
    [getSymbolApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        NSDictionary *dictResult = finishApi.resultDict;
        NSString *symobl = dictResult[@"data"];
        if (symobl.length < 128) {
            [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                         data:@""
                                   callbackId:callbackId
                                         code:ERROR_REQUEST_PARAMS];
            return ;
        }
        symobl = [WalletTools abiDecodeString:symobl];
        
        [self getTokenDecimalsWithParamModel:paramModel requestId:requestId webView:webView callbackId:callbackId];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_SERVER_DATA];
    }];
}

- (void)getTokenDecimalsWithParamModel:(WalletSignParamModel *)paramModel requestId:(NSString *)requestId webView:(WKWebView *)webView callbackId:(NSString *)callbackId
{
    WalletGetDecimalsApi *getDecimalsApi = [[WalletGetDecimalsApi alloc]initWithTokenAddress:paramModel.tokenAddress];
    [getDecimalsApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        NSDictionary *dictResult = finishApi.resultDict;
        NSString *decimalsHex = dictResult[@"data"];
        NSString *decimals = [BigNumber bigNumberWithHexString:decimalsHex].decimalString;
        
        CGFloat amountTnteger = [BigNumber bigNumberWithHexString:paramModel.amount].decimalString.floatValue/pow(10, decimals.integerValue);

        if (![WalletTools errorAddressAlert:paramModel.toAddress] ||
            ![self errorAmount:[NSString stringWithFormat:@"%lf",amountTnteger]]||
            ![WalletTools fromISToAddress:paramModel.fromAddress to:paramModel.toAddress]||
            !(paramModel.gas.integerValue > 0)||
            paramModel.clauseData.length == 0) {
            
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:@""
                                    callbackId:callbackId
                                          code:ERROR_REQUEST_PARAMS];
            return;
        }
        
        WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
        signatureView.tag = SignViewTag;
        signatureView.transferType = JSTokenTransferType;
        [signatureView updateViewParamModel:paramModel];
        
        [[WalletTools getCurrentVC].navigationController.view addSubview:signatureView];
        
        signatureView.transferBlock = ^(NSString * _Nonnull txid) {
            NSLog(@"txid = %@",txid);
            if (txid.length == 0) {
                
                [WalletTools callbackWithrequestId:requestId
                                           webView:webView
                                              data:@""
                                        callbackId:callbackId
                                              code:ERROR_CANCEL];
            }else{
                
                [WalletTools callbackWithrequestId:requestId
                                           webView:webView
                                              data:txid
                                        callbackId:callbackId
                                              code:OK];
            }
        };
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_SERVER_DATA];
    }];
}

- (void)contractSignWithParamModel:(WalletSignParamModel *)paramModel
                         requestId:(NSString *)requestId
                           webView:(WKWebView *)webView
                    callbackId:(NSString *)callbackId
{
    if (paramModel.clauseData.length == 0 ||
        !(paramModel.gas.integerValue > 0)) {
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_REQUEST_PARAMS];
        
        return;
    }
    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
    signatureView.tag = SignViewTag;
    signatureView.transferType = JSContranctTransferType;
    [signatureView updateViewParamModel:paramModel];
    
    [[WalletTools getCurrentVC].navigationController.view addSubview:signatureView];
    
    signatureView.transferBlock = ^(NSString * _Nonnull txid) {
        NSLog(@"txid = %@",txid);
        if (txid.length == 0) {
            
            
        }else{
            
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                         data:txid
                                   callbackId:callbackId
                                         code:OK];
        }
    };
}

- (void)certTransferParamModel:(WalletSignParamModel *)paramModel
                    requestId:(NSString *)requestId
                      webView:(WKWebView *)webView
                   callbackId:(NSString *)callbackId
{
#warning
   
//    NSString *purpose = dictParam[@"purpose"];
//    NSString *payload = dictParam[@"payload"][@"type"];
//    NSString *content = dictParam[@"payload"][@"content"];
//    
//    if (purpose.length == 0 ||
//        payload.length == 0 ||
//        content.length == 0 ) {
//        
//        [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_REQUEST_PARAMS];
//        
//        return;
//    }
//    WalletSignatureView *signaVC = [[WalletSignatureView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    signaVC.tag = SignViewTag;
//    signaVC.transferType = JSVETTransferType;
//    
//#warning 
////    signaVC.jsUse = YES;
////    signaVC.bCert = YES;
//    [signaVC updateView:from
//              toAddress:@""
//                 amount:[NSString stringWithFormat:@"%.2d",0]
//                 params:@[dictParam]];
//    [[WalletTools getCurrentVC].view addSubview:signaVC];
//    
//    signaVC.transferBlock = ^(NSString * _Nonnull txid) {
//        NSLog(@"txid = %@",txid);
//        if (txid.length == 0) {
//            
//            [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_CANCEL];
//        }else{
//            
//            [WalletTools callbackWithrequestId:requestId webView:webView data:txid callbackId:callbackId code:OK];
//        }
//    };
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
    
    if (amount.length > 20) {
        bAmount = NO;
    }
    
    if ([amount floatValue] == 0
        && [[Payment parseEther:amount] lessThanEqualTo:[BigNumber constantZero]]){
        bAmount = YES;
    }
    if (!bAmount) {
        [WalletAlertShower showAlert:nil
                                msg:VCNSLocalizedBundleString(@"h5_params_error", nil)
                              inCtl:[WalletTools getCurrentVC]
                              items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                         clickBlock:^(NSInteger index) {
                         }];
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

@end
