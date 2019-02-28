//
//  WalletSignatureViewHandle.m
//  WalletSDK
//
//  Created by 曾新 on 2019/2/14.
//  Copyright © 2019年 Ethers. All rights reserved.
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

- (void)checkBalcanceFromAddress:(NSString *)fromAddress amount:(NSString *)amount gasLimit:(NSString *)gasLimit block:(void(^)())block
{
    if (fromAddress.length > 0) {
        // vet检查
        [self getVETBalance:fromAddress amount:(NSString *)amount block:^{
            if (block) {
                block();
            }
        }];
        
        [self getVTHOBalance:fromAddress gasLimit:gasLimit block:^{
            if (block) {
                block();
            }
        }];
        return ;
    }
}

- (void)getVETBalance:(NSString *)address amount:(NSString *)amount block:(void(^)())block
{
    NSDictionary *dictCurrentNet = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentNet"];
    NSString *blockHost = dictCurrentNet[@"serverUrl"];
    
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
             
             NSString *msg = [NSString stringWithFormat:@"您当前地址余额%.2fVET，不够支付%.2fVET",vetBalance.floatValue,tempAmount.floatValue];
             
             [WalletAlertShower showAlert:@"余额不足提示"
                                      msg:msg
                                    inCtl:[WalletTools getCurrentVC]
                                    items:@[@"确定"]
                               clickBlock:^(NSInteger index)
              {
              }];
         }else{
             if (block) {
                 block();
             }
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         
         
     }];
}

- (void)getVTHOBalance:(NSString *)address gasLimit:(NSString *)gasLimit block:(void(^)())block
{
    NSDictionary *dictCurrentNet = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentNet"];
    NSString *blockHost = dictCurrentNet[@"serverUrl"];
    NSString *urlString = [blockHost stringByAppendingString:@"/accounts/0x0000000000000000000000000000456e65726779"] ;
    
    NSMutableDictionary *dictParm = [NSMutableDictionary dictionary];
    [dictParm setObject:[self tokenBalanceData:address] forKey:@"data"];
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
        
        NSDecimalNumber *transferVthoAmount = [NSDecimalNumber decimalNumberWithString:gasLimit];
        
        if ([vthoBalanceNum   compare:transferVthoAmount] == NSOrderedAscending) {
            
            NSString *msg = [NSString stringWithFormat:@"您当前地址余额%.2fVTHO，不够支付%.2fVTHO",vthoBalanceNum.floatValue,gasLimit.floatValue];
            
            [WalletAlertShower showAlert:@"余额不足提示"
                                     msg:msg
                                   inCtl:[WalletTools getCurrentVC]
                                   items:@[@"确定"]
                              clickBlock:^(NSInteger index)
             {
                 
             }];
            return;
        }else{
            if (block) {
                block();
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


//查询thor 余额
- (NSString *)tokenBalanceData:(NSString *)toAddress
{
    if ([[toAddress lowercaseString] hasPrefix:@"0x"]) {
        toAddress = [toAddress stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    }
    NSString *head = @"0x70a08231000000000000000000000000";
    NSString *data = [NSString stringWithFormat:@"%@%@",head,toAddress];
    return data;
}

- (void)tokenAddressConvetCoinInfo:(NSString *)tokenAddress coinModel:(WalletCoinModel *)coinModel block:(void(^)(void))block
{
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
            
            NSDictionary *dictResult = finishApi.resultDict;
            NSString *decimalsHex = dictResult[@"data"];
            NSString *decimals = [BigNumber bigNumberWithHexString:decimalsHex].decimalString;
            coinModel.decimals = decimals.integerValue;
            
            if (block) {
                block();
            }
            
        }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
            [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
        }];
    }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
    }];
}

@end
