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
    WalletCoinModel *_coinModel;
    UIView *_superView;
}

- (void)checkBalcanceFromAddress:(NSString *)fromAddress coinModel:(WalletCoinModel *)coinModel amount:(NSString *)amount gasLimit:(NSString *)gasLimit superView:(UIView *)superView block:(void(^)(BOOL result))block
{
    _coinModel = coinModel;
    _superView = superView;
    
    if ([coinModel.symobl.lowercaseString isEqualToString:@"vet"]) {
        // vet检查
        [self getVETBalance:fromAddress
                     amount:amount
                   gasLimit:gasLimit
                      block:^(BOOL result)
         {
             
             if (block) {
                 block(result);
             }
         }];
    }else if(coinModel.tokenAddress.length > 0){
        
        // 是vtho
        if ([coinModel.symobl.lowercaseString isEqualToString:@"vtho"]) {
            [self getVthoBalance:fromAddress
                    tokenAddress:coinModel.address
                          amount:amount
                        gasLimit:gasLimit
                           block:^(BOOL result)
             {
                 if (block) {
                     block(result);
                 }
             }];
        }else{  // 不是vtho
            
            [self getTokenBalance:fromAddress
                     tokenAddress:coinModel.address
                           amount:amount
                         gasLimit:gasLimit
                            block:^(BOOL result)
             {
                 if (block) {
                     block(result);
                 }
             }];
        }
    }else{
        if (block) {
            block(NO);
        }
    }
}

- (void)getVETBalance:(NSString *)address amount:(NSString *)amount gasLimit:(NSString *)gasLimit block:(void(^)(BOOL result))block
{
    [WalletMBProgressShower showLoadData:_superView Text:VCNSLocalizedBundleString(@"list_load_ing", nil)];
    
    NSString *blockHost = [WalletUserDefaultManager getBlockUrl];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/accounts/%@",blockHost,address];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    [httpManager GET:urlString
          parameters:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [WalletMBProgressShower hide:_superView];
         
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
             
             NSString *msg = [NSString stringWithFormat:VCNSLocalizedBundleString(@"contact_buy_failed_not_enough1", nil),[NSString stringWithFormat:@"%.2f",vetBalance.floatValue],tempAmount];
             [WalletMBProgressShower showMulLineTextIn:[WalletTools getCurrentNavVC].view Text:msg During:2.5];
         }else{
             
             WalletTokenBalanceApi *vthoApi = [[WalletTokenBalanceApi alloc]initWith:vthoTokenAddress data:[WalletTools tokenBalanceData:address]];
             [vthoApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
                 
                 WalletBalanceModel *balanceModel = finishApi.resultModel;
                 NSString *amount = balanceModel.data;
                 
                 BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
                 NSString *vthoBalance = [Payment formatEther:bigNumberCount];
                 NSLog(@"dd");
                 
                 NSDecimalNumber *vthoBalanceNum = [NSDecimalNumber decimalNumberWithString:vthoBalance];
                 NSString * newAmont = [gasLimit stringByReplacingOccurrencesOfString:@"," withString:@""];
                 NSDecimalNumber *transferTokenAmount = [NSDecimalNumber decimalNumberWithString:newAmont];
                 
                 if ([vthoBalanceNum compare:transferTokenAmount] == NSOrderedAscending) {
                     
                     NSString *vthoBalanceFormat = [Payment formatToken:bigNumberCount decimals:_coinModel.decimals options:2];
                     NSString *msg = [NSString stringWithFormat: VCNSLocalizedBundleString(@"contact_buy_failed_not_enough3",nil),vthoBalanceFormat,@"VTHO",gasLimit,@"VTHO"];
                     [WalletMBProgressShower showMulLineTextIn:[WalletTools getCurrentNavVC].view Text:msg During:2.5];
                 }else{
                     
                     if (block) {
                         block(YES);
                     }
                 }
                 
             } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
                 
                 [WalletMBProgressShower hide:_superView];
                 [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
                 if (block) {
                     block(NO);
                 }
             }];
             
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [WalletMBProgressShower hide:_superView];
         [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1.5];
         
         if (block) {
             block(NO);
         }
     }];
}

- (void)getTokenBalance:(NSString *)address tokenAddress:(NSString *)tokenAddress amount:(NSString *)tokenAmount gasLimit:(NSString *)gasLimit block:(void(^)(BOOL result))block
{
    
    WalletTokenBalanceApi *tokenApi = [[WalletTokenBalanceApi alloc]initWith:tokenAddress data:[WalletTools tokenBalanceData:address]];
    [tokenApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        WalletBalanceModel *balanceModel = finishApi.resultModel;
        NSString *amount = balanceModel.data;
        
        BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
        NSString *vthoBalance = [Payment formatEther:bigNumberCount];
        NSLog(@"dd");
        
        NSDecimalNumber *vthoBalanceNum = [NSDecimalNumber decimalNumberWithString:vthoBalance];
        NSString * newAmont = [tokenAmount stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSDecimalNumber *transferTokenAmount = [NSDecimalNumber decimalNumberWithString:newAmont];
        
        if ([vthoBalanceNum compare:transferTokenAmount] == NSOrderedAscending) {
            
            NSString *vthoBalanceFormat = [Payment formatToken:bigNumberCount decimals:_coinModel.decimals options:2];
            NSString *msg = [NSString stringWithFormat: VCNSLocalizedBundleString(@"contact_buy_failed_not_enough3",nil),vthoBalanceFormat,_coinModel.symobl,tokenAmount,_coinModel.symobl];
            
            
            [WalletMBProgressShower showMulLineTextIn:[WalletTools getCurrentNavVC].view Text:msg During:1.5];
            
        }else{
            
            [WalletMBProgressShower showLoadData:_superView Text:VCNSLocalizedBundleString(@"list_load_ing", nil)];
            WalletTokenBalanceApi *vthoApi = [[WalletTokenBalanceApi alloc]initWith:vthoTokenAddress data:[WalletTools tokenBalanceData:address]];
            [vthoApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
                
                [WalletMBProgressShower hide:_superView];
                
                
                WalletBalanceModel *balanceModel = finishApi.resultModel;
                NSString *amount = balanceModel.data;
                
                BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
                NSString *vthoBalance = [Payment formatEther:bigNumberCount];
                NSLog(@"dd");
                
                NSDecimalNumber *vthoBalanceNum = [NSDecimalNumber decimalNumberWithString:vthoBalance];
                NSString * newAmont = [gasLimit stringByReplacingOccurrencesOfString:@"," withString:@""];
                NSDecimalNumber *transferTokenAmount = [NSDecimalNumber decimalNumberWithString:newAmont];
                
                if ([vthoBalanceNum compare:transferTokenAmount] == NSOrderedAscending) {
                    
                    NSString *vthoBalanceFormat = [Payment formatToken:bigNumberCount decimals:_coinModel.decimals options:2];
                    NSString *msg = [NSString stringWithFormat: VCNSLocalizedBundleString(@"contact_buy_failed_not_enough3",nil),vthoBalanceFormat,@"VTHO",gasLimit,@"VTHO"];
                    
                    [WalletMBProgressShower showMulLineTextIn:[WalletTools getCurrentNavVC].view Text:msg During:1.5];
                }else{
                    if (block) {
                        block(YES);
                    }
                }
                
            }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
                [WalletMBProgressShower hide:_superView];
                [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
                
                if (block) {
                    block(NO);
                }
            }];
        }
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        
        [WalletMBProgressShower hide:_superView];
        [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
        if (block) {
            block(NO);
        }
    }];
    
    
}

- (void)getVthoBalance:(NSString *)address tokenAddress:(NSString *)tokenAddress amount:(NSString *)tokenAmount gasLimit:(NSString *)gasLimit block:(void(^)(BOOL result))block
{
    
    WalletTokenBalanceApi *tokenApi = [[WalletTokenBalanceApi alloc]initWith:tokenAddress data:[WalletTools tokenBalanceData:address]];
    [tokenApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        WalletBalanceModel *balanceModel = finishApi.resultModel;
        NSString *amount = balanceModel.data;
        
        BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
        NSString *vthoBalance = [Payment formatEther:bigNumberCount];
        NSString *total = [NSString stringWithFormat:@"%.2lf",tokenAmount.floatValue + gasLimit.floatValue];
        
        NSDecimalNumber *vthoBalanceNum = [NSDecimalNumber decimalNumberWithString:vthoBalance];
        NSString * newAmont = [total stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSDecimalNumber *transferTokenAmount = [NSDecimalNumber decimalNumberWithString:newAmont];
        
        if ([vthoBalanceNum compare:transferTokenAmount] == NSOrderedAscending) {
            
            NSString *vthoBalanceFormat = [Payment formatToken:bigNumberCount decimals:_coinModel.decimals options:2];
            NSString *msg = [NSString stringWithFormat: VCNSLocalizedBundleString(@"contact_buy_failed_not_enough3",nil),vthoBalanceFormat,_coinModel.symobl,total,_coinModel.symobl];
            
            [WalletMBProgressShower showMulLineTextIn:[WalletTools getCurrentNavVC].view Text:msg During:1.5];
        }else{
            if (block) {
                block(YES);
            }
        }
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletMBProgressShower hide:_superView];
        [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view Text:ERROR_REQUEST_PARAMS_MSG During:1];
        
        if (block) {
            block(NO);
        }
    }];
}



@end
