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
#import "WalletTokenBalanceApi.h"


@implementation WalletSignatureViewHandle
{
}

+ (void)checkBalcanceFromAddress:(NSString *)fromAddress coinModel:(WalletCoinModel *)coinModel amount:(NSString *)amount gasLimit:(NSString *)gasLimit superView:(UIView *)superView block:(void(^)(BOOL result))block
{
    [WalletMBProgressShower showCircleIn:superView];
    if ([coinModel.symobl.lowercaseString isEqualToString:@"vet"]) {
        // vet检查
        [self getVETBalance:fromAddress
                     amount:amount
                   gasLimit:gasLimit
                  superView:superView
                  coinModel:coinModel
                      block:^(BOOL result)
         {
             [WalletMBProgressShower hide:superView];
             if (block) {
                 block(result);
             }
         }];
    }else if(coinModel.address.length > 0){
        
        // 是vtho
        if ([coinModel.symobl.lowercaseString isEqualToString:@"vtho"]) {
            [self getVthoBalance:fromAddress
                    tokenAddress:coinModel.address
                          amount:amount
                        gasLimit:gasLimit
                       superView:superView
                       coinModel:coinModel
                           block:^(BOOL result)
             {
                 [WalletMBProgressShower hide:superView];

                 if (block) {
                     block(result);
                 }
             }];
        }else{  // 不是vtho
            
            [self getTokenBalance:fromAddress
                     tokenAddress:coinModel.address
                           amount:amount
                         gasLimit:gasLimit
                        superView:superView
                        coinModel:coinModel
                            block:^(BOOL result)
             {
                 [WalletMBProgressShower hide:superView];

                 if (block) {
                     block(result);
                 }
             }];
        }
    }else{
        [WalletMBProgressShower hide:superView];

        if (block) {
            block(NO);
        }
    }
}

+ (void)getVETBalance:(NSString *)address amount:(NSString *)amount gasLimit:(NSString *)gasLimit superView:(UIView *)superView coinModel:(WalletCoinModel *)coinModel block:(void(^)(BOOL result))block
{
    
    NSString *blockHost = [WalletUserDefaultManager getBlockUrl];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/accounts/%@",blockHost,address];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    [httpManager GET:urlString
          parameters:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSDictionary *dictResponse = (NSDictionary *)responseObject;
         NSString *balance = dictResponse[@"balance"];
         
         BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:balance];
         NSString *vetBalance = [Payment formatEther:bigNumberCount];
         
         NSDecimalNumber *vetBalanceNum = [NSDecimalNumber decimalNumberWithString:vetBalance];
         
         NSString *amountNarrow = @"";
         [self convertAmountFormat:amount amountNarrow:&amountNarrow];

         NSDecimalNumber *amountNum = [NSDecimalNumber decimalNumberWithString:amountNarrow];
         
         if ([vetBalanceNum compare:amountNum] == NSOrderedAscending) {
             
             NSString *tempAmount = amount;
             if ([amount containsString:@"0x"]) {
                 
                 BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
                 tempAmount = [Payment formatEther:bigNumberCount];
             }
             
             NSString *msg = [NSString stringWithFormat:VCNSLocalizedBundleString(@"contact_buy_failed_not_enough1", nil),[NSString stringWithFormat:@"%.2f",vetBalance.floatValue],tempAmount];
             [WalletMBProgressShower showMulLineTextIn:[WalletTools getCurrentNavVC].view Text:msg During:2.5];
         }else{
             
             WalletTokenBalanceApi *vthoApi = [[WalletTokenBalanceApi alloc]initWith:vthoTokenAddress data:[WalletTools tokenBalanceData:address]];
             [vthoApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
                 
                 WalletBalanceModel *balanceModel = finishApi.resultModel;
                 NSString *amount = balanceModel.data;
                 
                 BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
                 NSString *vthoBalance = [Payment formatEther:bigNumberCount];
                 
                 NSDecimalNumber *vthoBalanceNum = [NSDecimalNumber decimalNumberWithString:vthoBalance];
                 NSString * newAmont = [gasLimit stringByReplacingOccurrencesOfString:@"," withString:@""];
                 NSDecimalNumber *transferTokenAmount = [NSDecimalNumber decimalNumberWithString:newAmont];
                 
                 if ([vthoBalanceNum compare:transferTokenAmount] == NSOrderedAscending) {
                     
                     NSString *vthoBalanceFormat = [Payment formatToken:bigNumberCount decimals:coinModel.decimals options:2];
                     NSString *msg = [NSString stringWithFormat: VCNSLocalizedBundleString(@"contact_buy_failed_not_enough3",nil),vthoBalanceFormat,@"VTHO",gasLimit,@"VTHO"];
                     [WalletMBProgressShower showMulLineTextIn:[WalletTools getCurrentNavVC].view Text:msg During:2.5];
                 }else{
                     
                     if (block) {
                         block(YES);
                     }
                 }
                 
             } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
                 if (block) {
                     block(NO);
                 }
                 [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
                 
             }];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (block) {
             block(NO);
         }
         [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1.5];
         
         
     }];
}

+ (void)getTokenBalance:(NSString *)address tokenAddress:(NSString *)tokenAddress amount:(NSString *)tokenAmount gasLimit:(NSString *)gasLimit superView:(UIView *)superView coinModel:(WalletCoinModel *)coinModel block:(void(^)(BOOL result))block
{
    
    WalletTokenBalanceApi *tokenApi = [[WalletTokenBalanceApi alloc]initWith:tokenAddress data:[WalletTools tokenBalanceData:address]];
    [tokenApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        WalletBalanceModel *balanceModel = finishApi.resultModel;
        NSString *amount = balanceModel.data;
        
        BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
        NSString *vthoBalance = [Payment formatEther:bigNumberCount];
        
        NSDecimalNumber *vthoBalanceNum = [NSDecimalNumber decimalNumberWithString:vthoBalance];
        
        NSString *amountNarrow = @"";
        
        [self convertAmountFormat:tokenAmount amountNarrow:&amountNarrow];
        
        NSDecimalNumber *transferTokenAmount = [NSDecimalNumber decimalNumberWithString:amountNarrow];
        
        if ([vthoBalanceNum compare:transferTokenAmount] == NSOrderedAscending) {
            
            NSString *vthoBalanceFormat = [Payment formatToken:bigNumberCount decimals:coinModel.decimals options:2];
            NSString *msg = [NSString stringWithFormat: VCNSLocalizedBundleString(@"contact_buy_failed_not_enough3",nil),vthoBalanceFormat,coinModel.symobl,tokenAmount,coinModel.symobl];
            
            
            [WalletMBProgressShower showMulLineTextIn:[WalletTools getCurrentNavVC].view Text:msg During:1.5];
            
        }else{
            
            WalletTokenBalanceApi *vthoApi = [[WalletTokenBalanceApi alloc]initWith:vthoTokenAddress data:[WalletTools tokenBalanceData:address]];
            [vthoApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
                
                
                WalletBalanceModel *balanceModel = finishApi.resultModel;
                NSString *amount = balanceModel.data;
                
                BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
                NSString *vthoBalance = [Payment formatEther:bigNumberCount];
                
                NSDecimalNumber *vthoBalanceNum = [NSDecimalNumber decimalNumberWithString:vthoBalance];
                NSString * newAmont = [gasLimit stringByReplacingOccurrencesOfString:@"," withString:@""];
                NSDecimalNumber *transferTokenAmount = [NSDecimalNumber decimalNumberWithString:newAmont];
                
                if ([vthoBalanceNum compare:transferTokenAmount] == NSOrderedAscending) {
                    
                    NSString *vthoBalanceFormat = [Payment formatToken:bigNumberCount decimals:coinModel.decimals options:2];
                    NSString *msg = [NSString stringWithFormat: VCNSLocalizedBundleString(@"contact_buy_failed_not_enough3",nil),vthoBalanceFormat,@"VTHO",gasLimit,@"VTHO"];
                    
                    [WalletMBProgressShower showMulLineTextIn:[WalletTools getCurrentNavVC].view Text:msg During:1.5];
                }else{
                    if (block) {
                        block(YES);
                    }
                }
                
            }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
                if (block) {
                    block(NO);
                }
                [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
            }];
        }
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        if (block) {
            block(NO);
        }
        [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
        
    }];
    
    
}

+ (void)getVthoBalance:(NSString *)address tokenAddress:(NSString *)tokenAddress amount:(NSString *)tokenAmount gasLimit:(NSString *)gasLimit superView:(UIView *)superView coinModel:(WalletCoinModel *)coinModel block:(void(^)(BOOL result))block
{
    
    WalletTokenBalanceApi *tokenApi = [[WalletTokenBalanceApi alloc]initWith:tokenAddress data:[WalletTools tokenBalanceData:address]];
    [tokenApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        WalletBalanceModel *balanceModel = finishApi.resultModel;
        NSString *amount = balanceModel.data;
        
        BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
        NSString *vthoBalance = [Payment formatEther:bigNumberCount];
        
        NSDecimalNumber *vthoBalanceNum = [NSDecimalNumber decimalNumberWithString:vthoBalance];
        
        NSString *amountNarrow = @"";
        [self convertAmountFormat:tokenAmount amountNarrow:&amountNarrow];
        
        NSString *total = [NSString stringWithFormat:@"%.2lf",amountNarrow.floatValue + gasLimit.floatValue];
        
        NSString * newAmont = [total stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSDecimalNumber *transferTokenAmount = [NSDecimalNumber decimalNumberWithString:newAmont];
        
        
        
        if ([vthoBalanceNum compare:transferTokenAmount] == NSOrderedAscending) {
            
            NSString *vthoBalanceFormat = [Payment formatToken:bigNumberCount decimals:coinModel.decimals options:2];
            NSString *msg = [NSString stringWithFormat: VCNSLocalizedBundleString(@"contact_buy_failed_not_enough3",nil),vthoBalanceFormat,coinModel.symobl,total,coinModel.symobl];
            
            [WalletMBProgressShower showMulLineTextIn:[WalletTools getCurrentNavVC].view Text:msg During:1.5];
        }else{
            if (block) {
                block(YES);
            }
        }
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        if (block) {
            block(NO);
        }
        [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
        
    }];
}


+ (void)convertAmountFormat:(NSString *)originAmount amountNarrow:(NSString **)amountNarrow
{
    if (originAmount.length == 0) {
        *amountNarrow = @"";
    }else if ([WalletTools checkDecimalStr:originAmount])
    {
        if (originAmount.length > 18) {
            *amountNarrow = [Payment formatEther:[BigNumber bigNumberWithDecimalString:originAmount]];
        }else{
            *amountNarrow = originAmount;
        }
        
    }else if ([WalletTools checkHEXStr:originAmount]) {
        *amountNarrow = [Payment formatEther:[BigNumber bigNumberWithHexString:originAmount]];
    }
}

@end
