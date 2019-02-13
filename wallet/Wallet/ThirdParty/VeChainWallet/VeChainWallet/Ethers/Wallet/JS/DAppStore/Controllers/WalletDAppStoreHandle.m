//
//  WalletDAppStoreHandle.m
//  walletSDK
//
//  Created by 曾新 on 2019/1/29.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import "WalletDAppStoreHandle.h"
#import <WebKit/WebKit.h>
#import "WalletDAppHead.h"
#import "NSJSONSerialization+NilDataParameter.h"

@implementation WalletDAppStoreHandle

- (void)injectJS:(WKWebView *)webview
{
    NSString *js = connex_js;
    [webview evaluateJavaScript:js completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"inject error == %@",error);
    }];
    
    //web3
    NSString *web3js = web3_js;
    [webview evaluateJavaScript:web3js completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"web3js error == %@",error);
    }];
}

- (void)test:(NSString *)defaultText 
{
//    NSLog(@"defaultText == %@",defaultText);
//    
//    NSString *result = [defaultText stringByReplacingOccurrencesOfString:@"wallet://" withString:@""];
//    NSDictionary *dict = [NSJSONSerialization dictionaryWithJsonString:result];
//    NSString *callbackID = dict[@"callbackId"];
//    NSString *requestId = dict[@"requestId"];
//    NSString *method = dict[@"method"];
//    NSDictionary *dictP = dict[@"params"];
//
//    //    if (![self checkNetwork]) {
//    //
//    //        [WalletTools callback:requestId
//    //                        data:@""
//    //                  callbackID:callbackID
//    //                     webview:webView
//    //                        code:ERROR_NETWORK
//    //                     message:@"network error"];
//    //
//    //        return;
//    //    }
//
//    if ([method isEqualToString:@"getStatus"]) {
//
//        [self getStatusWithRequestId:requestId completionHandler:completionHandler];
//        return;
//
//    }else if ([method isEqualToString:@"getGenesisBlock"])
//    {
//
//        [self getGenesisBlockWithRequestId:requestId completionHandler:completionHandler];
//
//        return;
//    }else if ([method isEqualToString:@"getAccount"]){
//
//        [self getAccountRequestId:requestId webView:webView address:dictP[@"address"] callbackID:callbackID];
//
//    }else if([method isEqualToString:@"getAccountCode"])
//    {
//        [self getAccountCode:callbackID
//                     webView:webView
//                   requestId:requestId
//                     address:dictP[@"address"]];
//
//    }else if([method isEqualToString:@"getBlock"])
//    {
//        [self getBlock:callbackID
//               webView:webView
//             requestId:requestId
//              revision:dictP[@"revision"]];
//
//    }else if([method isEqualToString:@"getTransaction"])
//    {
//        [self getTransaction:callbackID
//                     webView:webView
//                   requestId:requestId
//                        txID:dictP[@"id"]];
//    }
//    else if([method isEqualToString:@"getTransactionReceipt"])
//    {
//        [self getTransactionReceipt:callbackID
//                            webView:webView
//                          requestId:requestId
//                               txid:dictP[@"id"]];
//    }
//    else if([method isEqualToString:@"methodAsClause"])
//    {
//        [self methodAsClauseWithDictP:dictP
//                            requestId:requestId
//                    completionHandler:completionHandler];
//        return;
//
//    }else if ([method isEqualToString:@"getAccounts"])
//    {
//        [self getAccountsWithRequestId:requestId callbackID:callbackID webView:webView];
//
//    }
//    else if([method isEqualToString:@"sign"])
//    {
//        if ([self.navigationController.view viewWithTag:SelectWalletTag]) {
//            completionHandler(@"{}");
//            return;
//        }
//
//        NSString *to = dictP[@"clauses"][0][@"to"];
//        NSString *amount = dictP[@"clauses"][0][@"value"];
//        NSString *clauseData = dictP[@"clauses"][0][@"data"];
//        NSNumber *gas =  dictP[@"options"][@"gas"];
//
//        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
//        [dictParam setValueIfNotNil:@(0) forKey:@"isICO"];
//
//        BigNumber *gasBig = [BigNumber bigNumberWithNumber:gas];
//
//        BigNumber *gasCanUse = [[[[BigNumber bigNumberWithDecimalString:@"1000000000000000"] mul:[BigNumber bigNumberWithInteger:(1 + 120/255.0)*1000000]] mul:gasBig] div:[BigNumber bigNumberWithDecimalString:@"1000000"]];
//
//        NSString *miner = [[Payment formatEther:gasCanUse options:2] stringByAppendingString:@" VTHO"];
//
//        [dictParam setValueIfNotNil:miner forKey:@"miner"];
//        [dictParam setValueIfNotNil:[BigNumber bigNumberWithInteger:120] forKey:@"gasPriceCoef"];
//        [dictParam setValueIfNotNil:gas forKey:@"gas"];
//        [dictParam setValueIfNotNil:to forKey:@"to"];
//        [dictParam setValueIfNotNil:amount forKey:@"amount"];
//
//        NSData *secureData = [SecureData hexStringToData:clauseData];
//        [dictParam setValueIfNotNil:secureData forKey:@"clouseData"];
//
//        CGFloat amountTnteger = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"%@",amount]].decimalString.floatValue/pow(10, 18);
//
//        WalletDappStoreSelectView *selcetView = [[WalletDappStoreSelectView alloc]initWithFrame:self.view.frame ];
//        selcetView.tag = SelectWalletTag;
//        selcetView.amount = [NSString stringWithFormat:@"%lf",amountTnteger];
//        [self.navigationController.view addSubview:selcetView];
//        selcetView.block = ^(NSString *from,WalletDappStoreSelectView *viewSelf){
//
//            [viewSelf removeFromSuperview];
//
//            [dictParam setValueIfNotNil:from forKey:@"from"];
//
//            [self ConnexTransferWithClauseData:clauseData
//                                     dictParam:dictParam
//                                          from:from
//                                            to:to
//                                     requestId:requestId
//                                           gas:gas
//                                       webView:webView
//                                    callbackID:callbackID
//                                        amount:amount
//                                     gasCanUse:gasCanUse];
//        };
//    }else if ([method isEqualToString:@"getAddress"] ) {
//
//        [self getAddress:webView callbackID:callbackID];
//
//    }else if ([method isEqualToString:@"getBalance"]){
//
//        [self getBalance:callbackID
//                 webView:webView
//               requestId:requestId
//                 address:dictP[@"address"]];
//
//    }else if([method isEqualToString:@"getChainTag"]){
//
//        [self getChainTag:requestId completionHandler:completionHandler];
//        return;
//
//    }else if ([method isEqualToString:@"send"]){
//
//        if ([self.navigationController.view viewWithTag:SelectWalletTag]) {
//            completionHandler(@"{}");
//            return;
//        }
//        __block NSString *to = dictP[@"to"];
//        __block NSString *amount = dictP[@"value"];
//        NSString *cluseData = dictP[@"data"];
//        __block NSString *tokenAddress;
//        NSString *gas = [BigNumber bigNumberWithHexString:dictP[@"gas"]].decimalString;
//
//        NSString *gasPrice = dictP[@"gasPrice"];
//        if (gasPrice.length == 0) {
//            gasPrice = @"0x78";
//        }
//
//        CGFloat amountTnteger = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"%@",amount]].decimalString.floatValue/pow(10, 18);
//
//        WalletDappStoreSelectView *selcetView = [[WalletDappStoreSelectView alloc]initWithFrame:self.view.frame ];
//        selcetView.tag = SelectWalletTag;
//        selcetView.amount = [NSString stringWithFormat:@"%lf",amountTnteger];
//        [self.navigationController.view addSubview:selcetView];
//        selcetView.block = ^(NSString *from,WalletDappStoreSelectView *viewSelf){
//
//            [viewSelf removeFromSuperview];
//
//            WalletSignatureView *signaVC = [[WalletSignatureView alloc] initWithFrame:self.view.bounds];
//            if (cluseData.length < 3) { // vet 转账clauseData == nil,
//                signaVC.transferType = JSVETTransferType;
//            }else if ([cluseData hasPrefix:transferMethodId]) {// vtho 转账
//                tokenAddress = dictP[@"to"];
//                NSString *cluseData1 = [cluseData stringByReplacingOccurrencesOfString:transferMethodId withString:@""];
//                NSString *first = [cluseData1 substringToIndex:64];
//                to = [@"0x" stringByAppendingString: [first substringFromIndex:24]];
//                amount = [cluseData1 substringFromIndex:65];
//                signaVC.transferType = JSVTHOTransferType;
//            }else{
//                signaVC.transferType = JSContranctTransferType;
//            }
//
//            BigNumber *gasBig = [BigNumber bigNumberWithDecimalString:gas];
//            NSString *gasPriceDecimal = [BigNumber bigNumberWithHexString:gasPrice].decimalString;
//            BigNumber *gasCanUse = [[[[BigNumber bigNumberWithDecimalString:@"1000000000000000"] mul:[BigNumber bigNumberWithInteger:(1+gasPriceDecimal.integerValue/255.0)*1000000]] mul:gasBig] div:[BigNumber bigNumberWithDecimalString:@"1000000"]];
//
//            [self WEB3TransferWithClauseData:cluseData
//                                       from1:from
//                                          to:to
//                                   requestId:requestId
//                                         gas:gas
//                                     webView:webView
//                                  callbackID:callbackID
//                                      amount:amount
//                                   gasCanUse:gasCanUse
//                                     signaVC:signaVC
//                                    gasPrice:gasPrice
//                                tokenAddress:tokenAddress];
//        };
//    }
//    completionHandler(@"{}");
    
}

@end
