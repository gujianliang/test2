//
//  WalletSingletonHandle.m
//  walletSDK
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletSingletonHandle.h"
#import "WalletManageModel.h"
#import "WalletGetBaseGasPriceApi.h"
#import "Payment.h"
#import "SocketRocketUtility.h"
#import "WalletDAppHead.h"

@implementation WalletSingletonHandle
{
    NSMutableArray *_walletList;
    WalletManageModel *_currentModel;
}

static WalletSingletonHandle *singleton = nil;
static dispatch_once_t predicate;

+ (instancetype)shareWalletHandle
{
    dispatch_once(&predicate, ^{
        singleton = [[self alloc] init];
        
    });
    return singleton;
}

-(void)addWallet:(NSArray *)walletList
{
    _walletList = [NSMutableArray array];
    for (NSString *keystore in walletList) {
        NSDictionary *dictKeystore = [NSJSONSerialization dictionaryWithJsonString:keystore];
        WalletManageModel *walletModel = [[WalletManageModel alloc]init];
        walletModel.address = [@"0x" stringByAppendingString:dictKeystore[@"address"]];
        walletModel.keyStore = keystore;
        [_walletList addObject:walletModel];
        [self getVETBalance:walletModel];
        [self getVTHOBalance:walletModel];
    }
}

- (void)getVETBalance:(WalletManageModel *)walletModel
{
    NSString *urlString = [NSString stringWithFormat:@"%@/accounts/%@",[WalletUserDefaultManager getBlockUrl],walletModel.address];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [httpManager GET:urlString
          parameters:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSDictionary *dictResponse = (NSDictionary *)responseObject;
         NSString *amount = dictResponse[@"balance"];
         BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
         
         NSString *coinAmount = @"0.00";
         if (!bigNumberCount.isZero) {
             coinAmount = [Payment formatEther:bigNumberCount];
         }
         
         walletModel.VETCount = coinAmount;
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
#if ReleaseVersion
         NSLog(@"Get VET balance failure.  URL：%@  \n error: %@", urlString, error);
#endif
     }];
}

- (void)getVTHOBalance:(WalletManageModel *)walletModel
{
    NSString *urlString = [NSString stringWithFormat:@"%@/accounts/%@",[WalletUserDefaultManager getBlockUrl],vthoTokenAddress]  ;
    
    NSMutableDictionary *dictParm = [NSMutableDictionary dictionary];
    [dictParm setObject:[WalletTools tokenBalanceData:walletModel.address] forKey:@"data"];
    [dictParm setObject:@"0x0" forKey:@"value"];
    
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [httpManager POST:urlString parameters:dictParm success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dictResponse = (NSDictionary *)responseObject;
        NSString *amount = dictResponse[@"data"];
        BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
        
        NSString *coinAmount = @"0.00";
        if (!bigNumberCount.isZero) {
            coinAmount = [Payment formatEther:bigNumberCount];
        }
        
        WalletCoinModel *vthoModel = [[WalletCoinModel alloc]init];
        vthoModel.symobl = @"VTHO";
        vthoModel.coinCount = coinAmount;
        walletModel.vthoModel = vthoModel;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#if ReleaseVersion
        NSLog(@"Get VTHO balance failure.  URL：%@  \n error: %@", urlString, error);
#endif
    }];
}


- (NSString *)getWalletKeystore:(NSString *)address
{
    for (WalletManageModel *model in _walletList) {
        if ([model.address.lowercaseString isEqualToString:address.lowercaseString]) {
            return model.keyStore;
        }
    }
    return @"";
}

- (NSArray *)getAllWallet
{
    return _walletList;
}

- (WalletManageModel *)currentWalletModel
{
    return _currentModel;
}

- (void)setCurrentModel:(NSString *)address
{
#warning 什么时候确认
    for (WalletManageModel *model in _walletList) {
        if ([model.address.lowercaseString isEqualToString:address.lowercaseString] ) {
            _currentModel = model;
            return;
        }
    }
}

+ (void)attempDealloc{
    predicate = 0;
    singleton = nil;
    [[SocketRocketUtility instance] SRWebSocketClose];
    
}

@end
