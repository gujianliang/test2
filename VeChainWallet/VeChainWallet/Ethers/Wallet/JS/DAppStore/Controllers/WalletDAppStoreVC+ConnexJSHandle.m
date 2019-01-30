//
//  WalletDAppStoreVC+ConnexJSHandle.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppStoreVC+ConnexJSHandle.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletVETBalanceApi.h"
#import <WebKit/WebKit.h>
#import "WalletAccountCodeApi.h"
#import "WalletBlockApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletManageModel.h"
//#import "WalletSqlDataEngine.h"
#import "WalletSignatureView.h"
#import "WalletGetSymbolApi.h"
#import "WalletGetDecimalsApi.h"
#import "WalletDAppPeersApi.h"
#import "WalletBlockInfoApi.h"
#import "WalletDAppPeerModel.h"
#import "WalletDAppTransferDetailApi.h"

@implementation WalletDAppStoreVC (ConnexJSHandle)

-(void)getGenesisBlockWithRequestId:(NSString *)requestId
                  completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    WalletGenesisBlockInfoApi *genesisBlock = [WalletGenesisBlockInfoApi new];
    [genesisBlock loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        NSDictionary *resultDict = [FFBMSTools packageWithRequestId:requestId
                                                               data:finishApi.resultDict
                                                               code:OK
                                                            message:@""];
        completionHandler([resultDict yy_modelToJSONString]);
        return;
    }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        NSDictionary *resultDict = [FFBMSTools packageWithRequestId:requestId
                                                               data:@""
                                                               code:ERROR_SERVER_DATA
                                                            message:@"Server response error"];
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
            [subDict setValueIfNotNil:blockModel.id forKey:@"id"];
            [subDict setValueIfNotNil:blockModel.number forKey:@"number"];
            [subDict setValueIfNotNil:blockModel.timestamp forKey:@"timestamp"];
            [subDict setValueIfNotNil:blockModel.parentID forKey:@"parentID"];
            
            [dictParam setValueIfNotNil:subDict forKey:@"head"];
            
            NSDictionary *resultDict = [FFBMSTools packageWithRequestId:requestId
                                                                   data:dictParam
                                                                   code:OK
                                                                message:@""];
            completionHandler([resultDict yy_modelToJSONString]);

        } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
            NSDictionary *resultDict = [FFBMSTools packageWithRequestId:requestId
                                                                   data:@""
                                                                   code:ERROR_SERVER_DATA
                                                                message:@"Server response error"];
            completionHandler([resultDict yy_modelToJSONString]);

        }];
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        
        NSDictionary *resultDict = [FFBMSTools packageWithRequestId:requestId
                                                               data:@""
                                                               code:ERROR_SERVER_DATA
                                                            message:@"Server response error"];
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
    if (decodeStr.length > 10) {
        NSDictionary *resultDict = [FFBMSTools packageWithRequestId:requestId
                                                               data:[decodeStr substringToIndex:10]
                                                               code:OK
                                                            message:@""];
        completionHandler([resultDict yy_modelToJSONString]);
    }
}


- (void)getAccountRequestId:(NSString *)requestId
                    webView:(WKWebView *)webView
                    address:(NSString *)address
                 callbackID:(NSString *)callbackID
{
    WalletVETBalanceApi *vetBalanceApi = [[WalletVETBalanceApi alloc]initWith:address];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        [FFBMSTools callback:requestId
                  data:finishApi.resultDict
            callbackID:callbackID
               webview:webView
                  code:OK
                     message:@""];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        
        [FFBMSTools callback:requestId
                        data:@""
                  callbackID:callbackID
                     webview:webView
                        code:ERROR_SERVER_DATA
                     message:@"Server response error"];
    }];
}

- (void)getAccountCode:(NSString *)callbackID
               webView:(WKWebView *)webView
             requestId:(NSString *)requestId
               address:(NSString *)address
{
    WalletAccountCodeApi *vetBalanceApi = [[WalletAccountCodeApi alloc]initWithAddress:address];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        NSDictionary *balanceModel = finishApi.resultDict;
        
        [FFBMSTools callback:requestId
                        data:balanceModel[@"code"]
                  callbackID:callbackID
                     webview:webView
                        code:OK
                     message:@""];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [FFBMSTools callback:requestId
                        data:@""
                  callbackID:callbackID
                     webview:webView
                        code:ERROR_SERVER_DATA
                     message:@"Server response error"];
    }];
}

- (void)getBlock:(NSString *)callbackID
         webView:(WKWebView *)webView
       requestId:(NSString *)requestId
        revision:(NSString *)revision
{
    WalletBlockApi *vetBalanceApi = [[WalletBlockApi alloc]initWithRevision:revision];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        [FFBMSTools callback:requestId
                  data:finishApi.resultDict
            callbackID:callbackID
               webview:webView
                  code:OK
                     message:@""];
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [FFBMSTools callback:requestId
                        data:@""
                  callbackID:callbackID
                     webview:webView
                        code:ERROR_SERVER_DATA
                     message:@"Server response error"];
    }];
}


- (void)getTransaction:(NSString *)callbackID
               webView:(WKWebView *)webView
             requestId:(NSString *)requestId
                  txID:(NSString *)txID
{
    WalletDAppTransferDetailApi *vetBalanceApi = [[WalletDAppTransferDetailApi alloc]initWithTxid:txID];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        NSDictionary *balanceModel = finishApi.resultDict;
        
        [FFBMSTools callback:requestId
                        data:balanceModel
                  callbackID:callbackID
                     webview:webView
                        code:OK
                     message:@""];
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [FFBMSTools callback:requestId
                        data:@""
                  callbackID:callbackID
                     webview:webView
                        code:ERROR_SERVER_DATA
                     message:@"Server response error"];
    }];
}

- (void)getTransactionReceipt:(NSString *)callbackID
                      webView:(WKWebView *)webView
                    requestId:(NSString *)requestId
                         txid:(NSString *)txid
{
    WalletTransantionsReceiptApi *vetBalanceApi = [[WalletTransantionsReceiptApi alloc]initWithTxid:txid];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        [FFBMSTools callback:requestId
                        data:finishApi.resultDict
                  callbackID:callbackID
                     webview:webView
                        code:OK
                     message:@""];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [FFBMSTools callback:requestId
                        data:@""
                  callbackID:callbackID
                     webview:webView
                        code:ERROR_SERVER_DATA
                     message:@"Server response error"];
    }];
}

-(void)getAccountsWithRequestId:(NSString *)requestId
                     callbackID:(NSString *)callbackID
                        webView:(WKWebView *)webView
{
    NSMutableArray *addressList = [NSMutableArray array];
//    for (WalletManageModel *model in [[WalletSqlDataEngine sharedInstance] getAllWallet]) {
//        [addressList addObject:model.address];
//    }
//    [FFBMSTools callback:requestId
//                    data:addressList
//              callbackID:callbackID
//                 webview:webView
//                    code:OK
//                 message:@""];
}

- (void)VETTransferDictParam:(NSMutableDictionary *)dictParam
               from:(NSString *)from
                 to:(NSString *)to
      amountTnteger:(CGFloat)amountTnteger
          requestId:(NSString *)requestId
                gas:(NSNumber *)gas
            webView:(WKWebView *)webView
         callbackID:(NSString *)callbackID

{
    if (![self errorAddressAlert:to] ||
        ![self errorAmount:[NSString stringWithFormat:@"%lf",amountTnteger] coinName:@"VET"] ||
        ![self fromISToAddress:from to:to]
        ||!(gas.integerValue > 0)) {
        
        [FFBMSTools callback:requestId
                        data:@""
                  callbackID:callbackID
                     webview:webView
                        code:ERROR_REQUEST_PARAMS
                     message:@"request params error"];
        
        return;
    }
    WalletSignatureView *signaVC = [[WalletSignatureView alloc] initWithFrame:self.view.bounds];
    signaVC.tag = SignViewTag;
    signaVC.transferType = JSVETTransferType;
    
    WalletCoinModel *coinModel = [[WalletCoinModel alloc]init];
    coinModel.coinName = @"VET";
    coinModel.transferGas = [NSString stringWithFormat:@"%@",gas];
    coinModel.decimals = 18;
    [dictParam setValueIfNotNil:coinModel forKey:@"coinModel"];
    
    signaVC.jsUse = YES;
    [signaVC updateView:from
              toAddress:to
           contractType:NoContract_transferToken
                 amount:[NSString stringWithFormat:@"%.2f",amountTnteger]
                 params:@[dictParam]];
    [self.navigationController.view addSubview:signaVC];
    
    signaVC.transferBlock = ^(NSString * _Nonnull txid) {
        NSLog(@"txid = %@",txid);
        if (txid.length == 0) {
            
            [FFBMSTools callback:requestId
                            data:@""
                      callbackID:callbackID
                         webview:webView
                            code:ERROR_CANCEL
                         message:@"User cancelled"];
        }else{
            
            [FFBMSTools callback:requestId
                            data:txid
                      callbackID:callbackID
                         webview:webView
                            code:OK
                         message:@""];
        }
        
    };
}

- (void)VTHOTransferDictParam:(NSMutableDictionary *)dictParam
                from:(NSString *)from
                  to:(NSString *)to
           requestId:(NSString *)requestId
                 gas:(NSNumber *)gas
             webView:(WKWebView *)webView
          callbackID:(NSString *)callbackID
           gasCanUse:(BigNumber *)gasCanUse
          clauseData:(NSString *)clauseData
{
    
    
    WalletSignatureView *signaVC = [[WalletSignatureView alloc] initWithFrame:self.view.bounds];
    signaVC.tag = SignViewTag;
    signaVC.transferType = JSVTHOTransferType;
    __block NSString *name = @"";
    
    WalletGetSymbolApi *getSymbolApi = [[WalletGetSymbolApi alloc]initWithTokenAddress:to];
    [getSymbolApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        NSDictionary *dictResult = finishApi.resultDict;
        NSString *symobl = dictResult[@"data"];
        name = [FFBMSTools abiDecodeString:symobl];
        
        WalletGetDecimalsApi *getDecimalsApi = [[WalletGetDecimalsApi alloc]initWithTokenAddress:to];
        [getDecimalsApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
            
            NSDictionary *dictResult = finishApi.resultDict;
            NSString *symoblHex = dictResult[@"data"];
            NSString *symobl = [BigNumber bigNumberWithHexString:symoblHex].decimalString;
            
            NSString *gasstr = [Payment formatEther:gasCanUse options:2];
            
            [dictParam setValueIfNotNil:@(0) forKey:@"isICO"];
            
            WalletCoinModel *coinModel = [[WalletCoinModel alloc]init];
            coinModel.coinName = name;
            coinModel.transferGas = [NSString stringWithFormat:@"%@",gas];
            coinModel.decimals = symobl.integerValue;
            coinModel.address = to;
            
            [dictParam setValueIfNotNil:coinModel forKey:@"coinModel"];
            [dictParam setValueIfNotNil:gasstr forKey:@"miner"];
            [dictParam setValueIfNotNil:[BigNumber bigNumberWithInteger:120] forKey:@"gasPriceCoef"];
            
            NSString *clauseDataTemp = [clauseData stringByReplacingOccurrencesOfString:transferMethodId withString:@""];
            NSString *clauseValue = @"";
            
            if (clauseDataTemp.length > 32) {
                clauseValue = [clauseDataTemp substringWithRange:NSMakeRange(64, 64)];
            }
            
            CGFloat amountTnteger = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"0x%@",clauseValue]].decimalString.floatValue/pow(10, symobl.integerValue);
            
            if (![self errorAddressAlert:to] ||
                ![self errorAmount:[NSString stringWithFormat:@"%lf",amountTnteger] coinName:@"!VET"] || //不是vet
                ![self fromISToAddress:from to:to]||
                !(gas.integerValue > 0)||
                clauseData.length == 0) {
                
                [FFBMSTools callback:requestId
                                data:@""
                          callbackID:callbackID
                             webview:webView
                                code:ERROR_REQUEST_PARAMS
                             message:@"request params error"];
                
                return;
            }
            
            signaVC.jsUse = YES;
            [signaVC updateView:from
                      toAddress:to
                   contractType:NoContract_transferToken
                         amount:[NSString stringWithFormat:@"%.2f",amountTnteger]
                         params:@[dictParam]];
            [self.navigationController.view addSubview:signaVC];
            
            signaVC.transferBlock = ^(NSString * _Nonnull txid) {
                NSLog(@"txid = %@",txid);
                if (txid.length == 0) {
                    
                    [FFBMSTools callback:requestId
                                    data:@""
                              callbackID:callbackID
                                 webview:webView
                                    code:ERROR_CANCEL
                                 message:@"User cancelled"];
                }else{
                    
                    [FFBMSTools callback:requestId
                                    data:txid
                              callbackID:callbackID
                                 webview:webView
                                    code:OK
                                 message:@""];
                }
            };
        } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
            [FFBMSTools callback:requestId
                            data:@""
                      callbackID:callbackID
                         webview:webView
                            code:ERROR_SERVER_DATA
                            message:@"Server response error"];
        }];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [FFBMSTools callback:requestId
                        data:@"Server response error"
                  callbackID:callbackID
                     webview:webView
                        code:ERROR_SERVER_DATA
                        message:@"Server response error"];
    }];
}

- (void)contractSignDictParam:(NSMutableDictionary *)dictParam
                  to:(NSString *)to
                         from:(NSString *)from
       amountTnteger:(CGFloat )amountTnteger
           requestId:(NSString *)requestId
                 gas:(NSNumber *)gas
             webView:(WKWebView *)webView
          callbackID:(NSString *)callbackID
          clauseData:(NSString *)clauseData
{
    if (clauseData.length == 0 ||
        !(gas.integerValue > 0)) {
        
        [FFBMSTools callback:requestId
                        data:@""
                  callbackID:callbackID
                     webview:webView
                        code:ERROR_REQUEST_PARAMS
                     message:@"request params error"];
        
        return;
    }
    WalletSignatureView *signaVC = [[WalletSignatureView alloc] initWithFrame:self.view.bounds];
    signaVC.tag = SignViewTag;
    signaVC.jsUse = YES;
    [dictParam setValueIfNotNil:to forKey:@"tokenAddress"];
    signaVC.transferType = JSContranctTransferType;
    [signaVC updateView:from
              toAddress:to
           contractType:NoContract_transferToken
                 amount:[NSString stringWithFormat:@"%.2f",amountTnteger]
                 params:@[dictParam]];
    [self.navigationController.view addSubview:signaVC];
    
    signaVC.transferBlock = ^(NSString * _Nonnull txid) {
        NSLog(@"txid = %@",txid);
        if (txid.length == 0) {
            
            [FFBMSTools callback:requestId
                            data:@""
                      callbackID:callbackID
                         webview:webView
                            code:ERROR_CANCEL
                         message:@"User cancelled"];
        }else{
            
            [FFBMSTools callback:requestId
                            data:txid
                      callbackID:callbackID
                         webview:webView
                            code:OK
                         message:@""];
        }
    };
}

- (BOOL)errorAddressAlert:(NSString *)toAddress
{
    // 格式校验
    bool isok = YES;
    if (!toAddress
        || ![toAddress.uppercaseString hasPrefix:@"0X"]
        || toAddress.length != 42
        || (![toAddress hasSuffix:[toAddress substringFromIndex:2]])) {
//            0x1113A  1113A
            // 是否有 checksum 校验
            isok = NO;
            NSString *lowercaseAddress = [toAddress substringFromIndex:2].lowercaseString;
            if (toAddress
                && [toAddress hasSuffix:lowercaseAddress]
                && ![[toAddress substringFromIndex:2] hasSuffix:lowercaseAddress]) {
//                noChecksum = YES;
                isok = NO;
            } else if ([[toAddress substringFromIndex:2] hasSuffix:lowercaseAddress]) {
                isok = YES;
            } else if (!toAddress
                       && [toAddress.uppercaseString hasPrefix:@"0X"]
                       && toAddress.length == 42) {
                isok = NO;
            }
        if (!isok) {
            [FFBMSAlertShower showAlert:nil
                                    msg:NSLocalizedString(@"非法参数", nil)
                                  inCtl:[UIApplication sharedApplication].keyWindow.rootViewController
                                  items:@[NSLocalizedString(@"dialog_yes", nil)]
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
        [FFBMSAlertShower showAlert:nil
                                msg:NSLocalizedString(@"非法参数", nil)
                              inCtl:[UIApplication sharedApplication].keyWindow.rootViewController
                              items:@[NSLocalizedString(@"dialog_yes", nil)]
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
        [FFBMSAlertShower showAlert:nil
                                msg:NSLocalizedString(@"非法参数", nil)
                              inCtl:[UIApplication sharedApplication].keyWindow.rootViewController
                              items:@[NSLocalizedString(@"dialog_yes", nil)]
                         clickBlock:^(NSInteger index) {
                         }];
        return NO;
    }
    return YES;
}

- (BOOL)fromISToAddress:(NSString *)from to:(NSString *)to
{
    bool isSame = NO;
    if ([from.lowercaseString isEqualToString:to.lowercaseString]) {
        isSame = YES;
    }
    if (isSame) {
        [FFBMSAlertShower showAlert:nil
                                msg:NSLocalizedString(@"非法参数", nil)
                              inCtl:[UIApplication sharedApplication].keyWindow.rootViewController
                              items:@[NSLocalizedString(@"dialog_yes", nil)]
                         clickBlock:^(NSInteger index) {
                         }];
        return NO;
    }
    return YES;
}

- (void)failResult:(NSString *)requestId
        callbackID:(NSString *)callbackID
           webView:(WKWebView *)webView
{
    [FFBMSTools callback:requestId
                    data:@""
              callbackID:callbackID
                 webview:webView
                    code:ERROR_SERVER_DATA
                 message:@"Server response error"];
}

@end
