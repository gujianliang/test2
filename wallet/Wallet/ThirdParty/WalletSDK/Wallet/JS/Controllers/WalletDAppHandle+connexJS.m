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

- (void)VETTransferDictParam:(NSMutableDictionary *)dictParam
                        from:(NSString *)from
                          to:(NSString *)to
               amountTnteger:(CGFloat)amountTnteger
                   requestId:(NSString *)requestId
                         gas:(NSNumber *)gas
                     webView:(WKWebView *)webView
                  callbackId:(NSString *)callbackId

{
    if (![self errorAddressAlert:to] ||
        ![self errorAmount:[NSString stringWithFormat:@"%lf",amountTnteger] coinName:@"VET"] ||
        ![WalletTools fromISToAddress:from to:to]
        ||!(gas.integerValue > 0)) {
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_REQUEST_PARAMS];
        
        return;
    }
    
    [WalletUtils signViewFromAddress:from
                           toAddress:to
                              amount:[NSString stringWithFormat:@"%.2f",amountTnteger]
                              symbol:@"VET"
                                 gas:gas.stringValue
                        tokenAddress:@""
                            decimals:18
                               block:^(NSString *txId)
    {
                                
           if (txId.length == 0) {
//               
              
           }else{
               
               [WalletTools callbackWithrequestId:requestId
                                          webView:webView
                                             data:txId
                                       callbackId:callbackId
                                             code:OK];
           }
    }];
}

- (void)VTHOTransferDictParam:(NSMutableDictionary *)dictParam
                         from:(NSString *)from
                 tokenAddress:(NSString *)tokenAddress
                    toAddress:(NSString *)toAddress
                    requestId:(NSString *)requestId
                          gas:(NSNumber *)gas
                      webView:(WKWebView *)webView
                   callbackId:(NSString *)callbackId
                 gasPriceCoef:(NSString *)gasPriceCoef
                   clauseData:(NSString *)clauseData
{
    __block NSString *coinName = @"";
    
    WalletGetSymbolApi *getSymbolApi = [[WalletGetSymbolApi alloc]initWithTokenAddress:tokenAddress];
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
        coinName = [WalletTools abiDecodeString:symobl];
        
        [self getTokenDecimalsTokenAddress:tokenAddress dictParam:dictParam coinName:coinName gasPriceCoef:gasPriceCoef gas:gas clauseData:clauseData toAddress:toAddress from:from requestId:requestId webView:webView callbackId:callbackId];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_SERVER_DATA];
    }];
}

- (void)getTokenDecimalsTokenAddress:(NSString *)tokenAddress dictParam:(NSMutableDictionary *)dictParam coinName:(NSString *)coinName gasPriceCoef:(NSString *)gasPriceCoef gas:(NSNumber *)gas
                          clauseData:(NSString *)clauseData toAddress:(NSString *)toAddress from:(NSString *)from requestId:(NSString *)requestId webView:(WKWebView *)webView callbackId:(NSString *)callbackId
{
    WalletGetDecimalsApi *getDecimalsApi = [[WalletGetDecimalsApi alloc]initWithTokenAddress:tokenAddress];
    [getDecimalsApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        NSDictionary *dictResult = finishApi.resultDict;
        NSString *decimalsHex = dictResult[@"data"];
        NSString *decimals = [BigNumber bigNumberWithHexString:decimalsHex].decimalString;
        
        WalletCoinModel *coinModel = [[WalletCoinModel alloc]init];
        coinModel.coinName         = coinName;
        coinModel.transferGas      = [NSString stringWithFormat:@"%@",gas];
        coinModel.decimals         = decimals.integerValue;
        coinModel.address          = tokenAddress;
        
        [dictParam setValueIfNotNil:coinModel forKey:@"coinModel"];
        [dictParam setValueIfNotNil:[BigNumber bigNumberWithInteger:gasPriceCoef.integerValue] forKey:@"gasPriceCoef"];
        
        NSString *clauseDataTemp = [clauseData stringByReplacingOccurrencesOfString:TransferMethodId withString:@""];
        NSString *clauseValue = @"";
        
        if (clauseDataTemp.length >= 128) {
            clauseValue = [clauseDataTemp substringWithRange:NSMakeRange(64, 64)];
        }
        
        CGFloat amountTnteger = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"0x%@",clauseValue]].decimalString.floatValue/pow(10, decimals.integerValue);
        
#warning coinName
        if (![self errorAddressAlert:toAddress] ||
            ![self errorAmount:[NSString stringWithFormat:@"%lf",amountTnteger] coinName:@"!VET"] || //不是vet
            ![WalletTools fromISToAddress:from to:toAddress]||
            !(gas.integerValue > 0)||
            clauseData.length == 0) {
            
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:@""
                                    callbackId:callbackId
                                          code:ERROR_REQUEST_PARAMS];
            
            return;
        }
        
        [self enterSignatureViewToAddress:toAddress from:from requestId:requestId webView:webView callbackId:callbackId dictParam:dictParam amountTnteger:amountTnteger];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_SERVER_DATA];
    }];
}

- (void)enterSignatureViewToAddress:(NSString *)toAddress from:(NSString *)from requestId:(NSString *)requestId webView:(WKWebView *)webView callbackId:(NSString *)callbackId dictParam:(NSMutableDictionary *)dictParam amountTnteger:(CGFloat)amountTnteger
{
    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
    signatureView.tag = SignViewTag;
    signatureView.transferType = JSVTHOTransferType;
    
    [signatureView updateView:from
                    toAddress:toAddress
                 contractType:NoContract_transferToken
                       amount:[NSString stringWithFormat:@"%.2f",amountTnteger]
                       params:@[dictParam]];
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
    
//    [WalletUtils signViewFrom:from
//                           to:toAddress
//                       amount:[NSString stringWithFormat:@"%.2f",amountTnteger]
//                     coinName:@"VTHO"
//                        block:^(NSString *txId)
//    {
//        if (txId.length == 0) {
//
//            [WalletTools callbackWithrequestId:requestId
//                                       webView:webView
//                                          data:@""
//                                    callbackId:callbackId
//                                          code:ERROR_CANCEL];
//        }else{
//
//            [WalletTools callbackWithrequestId:requestId
//                                       webView:webView
//                                          data:txId
//                                    callbackId:callbackId
//                                          code:OK];
//        }
//    }];
}

- (void)contractSignDictParam:(NSMutableDictionary *)dictParam
                           to:(NSString *)to
                         from:(NSString *)from
                amountTnteger:(CGFloat )amountTnteger
                    requestId:(NSString *)requestId
                          gas:(NSNumber *)gas
                      webView:(WKWebView *)webView
                   callbackId:(NSString *)callbackId
                   clauseData:(NSString *)clauseData
{
    if (clauseData.length == 0 ||
        !(gas.integerValue > 0)) {
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_REQUEST_PARAMS];
        
        return;
    }
    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
    signatureView.tag = SignViewTag;
    [dictParam setValueIfNotNil:to forKey:@"tokenAddress"];
    signatureView.transferType = JSContranctTransferType;
    [signatureView updateView:from
              toAddress:to
           contractType:NoContract_transferToken
                 amount:[NSString stringWithFormat:@"%.2f",amountTnteger]
                 params:@[dictParam]];
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

- (BOOL)errorAddressAlert:(NSString *)toAddress
{
    if ([toAddress isKindOfClass:[NSNull class]]) {
        return NO;
    }
    // 格式校验
    bool isOK = YES;
    if (!toAddress
        || ![toAddress.uppercaseString hasPrefix:@"0X"]
        || toAddress.length != 42
        || (![toAddress hasSuffix:[toAddress substringFromIndex:2]])) {
        // 是否有 checksum 校验
        isOK = NO;
        NSString *lowercaseAddress = [toAddress substringFromIndex:2].lowercaseString;
        if (toAddress
            && [toAddress hasSuffix:lowercaseAddress]
            && ![[toAddress substringFromIndex:2] hasSuffix:lowercaseAddress]) {
            
            isOK = NO;
        } else if ([[toAddress substringFromIndex:2] hasSuffix:lowercaseAddress]) {
            isOK = YES;
        } else if (!toAddress
                   && [toAddress.uppercaseString hasPrefix:@"0X"]
                   && toAddress.length == 42) {
            isOK = NO;
        }
        if (!isOK) {
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
    
    NSString *regex = @"^(0x|0X){1}[0-9A-Fa-f]{40}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL allAreValidChar = [predicate evaluateWithObject:toAddress];
    if (!allAreValidChar) {
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

- (BOOL)errorAmount:(NSString *)amount coinName:(NSString *)coinName
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
        && [[Payment parseEther:amount] lessThanEqualTo:[BigNumber constantZero]]
        && [coinName isEqualToString:@"VET"]){
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
