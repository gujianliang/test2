//
//  WalletSignatureViewHandle.m
//  WalletSDK
//
//  Created by 曾新 on 2019/2/14.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletSignatureViewHandle.h"
#import "WalletManageModel.h"
#import "WalletAlertShower.h"
#import "WalletMBProgressShower.h"
#import "WalletSignatureView.h"
#import "WalletGradientLayerButton.h"
#import "WalletBlockInfoApi.h"
#import "WalletTransactionApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletSignatureView+transferToken.h"
#import "WalletDAppSignPreVC.h"
#import "UIButton+block.h"
#import "WalletDAppSignPreVC.h"
#import "WalletSingletonHandle.h"
#import "NSBundle+Localizable.h"
#import "WalletGetSymbolApi.h"
#import "WalletGetDecimalsApi.h"
#import "WalletDAppHead.h"


@implementation WalletSignatureViewHandle
{
    WalletCoinModel *_coinModel;
}

- (void)checkBalcanceFromAddress:(NSString *)fromAddress coinModel:(WalletCoinModel *)coinModel amount:(NSString *)amount gasLimit:(NSString *)gasLimit block:(void(^)(BOOL result))block
{
    _coinModel = coinModel;
    
    if ([coinModel.symobl.lowercaseString isEqualToString:@"vet"]) {
        // vet检查
        [self getVETBalance:fromAddress amount:(NSString *)amount block:^(BOOL result){
            
#warning 要不要判断gas
            if (block) {
                block(result);
            }
        }];
    }else if(coinModel.tokenAddress.length > 0){
        [self getTokenBalance:fromAddress tokenAddress:coinModel.tokenAddress gasLimit:amount block:^(BOOL result){
            if (block) {
                block(result);
            }
        }];
    }
}

- (void)getVETBalance:(NSString *)address amount:(NSString *)amount block:(void(^)(BOOL result))block
{
    NSString *blockHost = [WalletUserDefaultManager getBlockUrl];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/accounts/%@",blockHost,address];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [httpManager GET:urlString
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSDictionary *dictResponse = (NSDictionary *)responseObject;
         NSString *balance = dictResponse[@"balance"];
         
         BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:balance];
         NSString *vetBalance = [Payment formatEther:bigNumberCount];
         
         NSDecimalNumber *vetBalanceNum = [NSDecimalNumber decimalNumberWithString:vetBalance];
         NSDecimalNumber *amountNum = [NSDecimalNumber decimalNumberWithString:amount];
         
         if ([vetBalanceNum compare:amountNum] == NSOrderedAscending) {
             
             NSString *tempAmount = amount;
             if ([amount containsString:@"0x"]) {
                 
                 BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
                 tempAmount = [Payment formatEther:bigNumberCount];
             }
             
             NSString *msg = [NSString stringWithFormat:VCNSLocalizedBundleString(@"contact_buy_failed_not_enough1", nil),vetBalance.floatValue,tempAmount.floatValue];
             
             [WalletAlertShower showAlert:VCNSLocalizedBundleString(@"transfer_wallet_send_balance_not_enough", nil)
                                      msg:msg
                                    inCtl:[WalletTools getCurrentVC]
                                    items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                               clickBlock:^(NSInteger index)
              {
              }];
         }else{
             if (block) {
                 block(YES);
             }
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [WalletMBProgressShower hide:[WalletTools getCurrentVC].view];
         [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
         if (block) {
             block(NO);
         }
     }];
}

- (void)getTokenBalance:(NSString *)address tokenAddress:(NSString *)tokenAddress gasLimit:(NSString *)gasLimit block:(void(^)(BOOL result))block
{
    NSString *blockHost = [WalletUserDefaultManager getBlockUrl];
    NSString *urlString = [NSString stringWithFormat:@"%@/accounts/%@",blockHost,tokenAddress]  ;
    
    NSMutableDictionary *dictParm = [NSMutableDictionary dictionary];
    [dictParm setObject:[WalletTools tokenBalanceData:address] forKey:@"data"];
    [dictParm setObject:@"0x0" forKey:@"value"];
    
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [httpManager POST:urlString parameters:dictParm progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dictResponse = (NSDictionary *)responseObject;
        NSString *amount = dictResponse[@"data"];
        
        BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
        NSString *vthoBalance = [Payment formatEther:bigNumberCount];
        
        NSDecimalNumber *vthoBalanceNum = [NSDecimalNumber decimalNumberWithString:vthoBalance];
        NSString * newAmont = [gasLimit stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSDecimalNumber *transferTokenAmount = [NSDecimalNumber decimalNumberWithString:newAmont];
        
        if ([vthoBalanceNum compare:transferTokenAmount] == NSOrderedAscending) {

            NSString *vthoBalanceFormat = [Payment formatToken:bigNumberCount decimals:_coinModel.decimals options:2];
            NSString *msg = [NSString stringWithFormat: VCNSLocalizedBundleString(@"contact_buy_failed_not_enough2",nil),vthoBalanceFormat,_coinModel.symobl,gasLimit,_coinModel.symobl];
            
            [WalletAlertShower showAlert:VCNSLocalizedBundleString(@"transfer_wallet_send_balance_not_enough", nil)
                                     msg:msg
                                   inCtl:[WalletTools getCurrentVC]
                                   items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                              clickBlock:^(NSInteger index)
             {
             }];
        }else{
            if (block) {
                block(YES);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Get VTHO balance failure. error: %@", error);
        [WalletMBProgressShower hide:[WalletTools getCurrentVC].view];
        [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
        if (block) {
            block(NO);
        }
    }];
}


- (void)tokenAddressConvetCoinInfo:(NSString *)tokenAddress coinModel:(WalletCoinModel *)coinModel block:(void(^)(BOOL result))block
{
    _coinModel = coinModel;
    
    [WalletMBProgressShower showLoadData:[WalletTools getCurrentVC].view Text:VCNSLocalizedBundleString(@"loading...", nil)];
    WalletGetSymbolApi *getSymbolApi = [[WalletGetSymbolApi alloc]initWithTokenAddress:tokenAddress];
    [getSymbolApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        NSDictionary *dictResult = finishApi.resultDict;
        NSString *symobl = dictResult[@"data"];
        if (symobl.length < 128) {
            [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
            return ;
        }
        symobl = [WalletTools abiDecodeString:symobl];
        coinModel.symobl = symobl;
        
        WalletGetDecimalsApi *getDecimalsApi = [[WalletGetDecimalsApi alloc]initWithTokenAddress:tokenAddress];
        [getDecimalsApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
            [WalletMBProgressShower hide:[WalletTools getCurrentVC].view];

            NSDictionary *dictResult = finishApi.resultDict;
            NSString *decimalsHex = dictResult[@"data"];
            NSString *decimals = [BigNumber bigNumberWithHexString:decimalsHex].decimalString;
            coinModel.decimals = decimals.integerValue;
            
            if (block) {
                block(YES);
            }
            
        }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
            [WalletMBProgressShower hide:[WalletTools getCurrentVC].view];
            [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
            if (block) {
                block(NO);
            }
        }];
    }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletMBProgressShower hide:[WalletTools getCurrentVC].view];
        [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
        
        if (block) {
            block(NO);
        }
    }];
}

@end
