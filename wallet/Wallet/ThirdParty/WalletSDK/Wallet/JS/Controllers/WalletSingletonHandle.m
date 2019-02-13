//
//  WalletSingletonHandle.m
//  walletSDK
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import "WalletSingletonHandle.h"
#import "WalletManageModel.h"

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

@end
