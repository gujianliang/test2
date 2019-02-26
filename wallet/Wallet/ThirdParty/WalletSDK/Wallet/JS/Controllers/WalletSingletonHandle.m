//
//  WalletSingletonHandle.m
//  walletSDK
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import "WalletSingletonHandle.h"
#import "WalletManageModel.h"
#import "WalletGetBaseGasPriceApi.h"

@implementation WalletSingletonHandle
{
    NSMutableArray *_walletList;
    WalletManageModel *_currentModel;
}

+ (instancetype)shareWalletHandle
{
    static WalletSingletonHandle *singleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        singleton = [[self alloc] init];
        
    });
    return singleton;
}

-(void)addWallet:(NSArray *)walletList
{
    _walletList = [NSMutableArray array];
    for (NSDictionary *dict in walletList) {
        WalletManageModel *walletModel = [[WalletManageModel alloc]init];
        walletModel.address = dict[@"address"];
        walletModel.keyStore = dict[@"keystore"];
        [_walletList addObject:walletModel];
    }
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
    for (WalletManageModel *model in _walletList) {
        if ([model.address.lowercaseString isEqualToString:address.lowercaseString] ) {
            _currentModel = model;
            return;
        }
    }
}

//- (NSString *)getBaseGasPrice
//{
//    NSString *saveBaseGasPrice = [[NSUserDefaults standardUserDefaults]objectForKey:@"baseGasPrice"];
//    if (saveBaseGasPrice.length > 0) {
//        return saveBaseGasPrice;
//    }else{
//        WalletGetBaseGasPriceApi *basegas = [[WalletGetBaseGasPriceApi alloc]init];
//        [basegas loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
//            NSString *temp = finishApi.resultDict[@"data"];
//            NSString *tt = [BigNumber bigNumberWithHexString:temp].decimalString;
//            
//            
//        } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
//            
//        }];
//    }
//}
//    NSMutableDictionary* dictParameters = [NSMutableDictionary dictionary];
//    [dictParameters setValueIfNotNil:@"0x8eaa6ac0000000000000000000000000000000000000626173652d6761732d7072696365" forKey:@"data"];
//    [dictParameters setValueIfNotNil:@"0x0" forKey:@"value"];
//
//   NSString *httpAddress =  [NSString stringWithFormat:@"%@/accounts/%@",[WalletUserDefaultManager getBlockUrl],@"0x0000000000000000000000000000506172616D73"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:httpAddress]];
//    //设置请求方式也POST（默认是GET）
//    request.timeoutInterval = 30;
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:dictParameters];
//    //同步方式连接服务器
//    NSData *responseObject = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSError *error;
//    if (responseObject){
//        NSString *responseStr =  [[ NSString alloc]initWithData:responseObject
//                                                       encoding:NSUTF8StringEncoding];
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr
//                                                                      dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error]  ;
//        NSLog(@"dd");
//
//    }else  {
//
//
//    }
//}

- (void)setBaseGasPrice
{
    WalletGetBaseGasPriceApi *basegas = [[WalletGetBaseGasPriceApi alloc]init];
    [basegas loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        NSString *resultStr = finishApi.resultDict[@"data"];
        _baseGasPrice = [BigNumber bigNumberWithHexString:resultStr].decimalString;
        if (_baseGasPrice.length > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:_baseGasPrice forKey:@"baseGasPrice"];;
        }
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        
    }];
}

@end
