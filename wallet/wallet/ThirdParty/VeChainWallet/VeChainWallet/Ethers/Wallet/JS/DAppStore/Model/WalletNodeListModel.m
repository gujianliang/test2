//
//  WalletNodeListModel.m
//  VCWallet
//
//  Created by 曾新 on 2018/5/9.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletNodeListModel.h"

@implementation WalletNodeListModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
             @"addressInfos" : [WalletNodeModel class]
             };
}
@end

@implementation WalletNodeModel
@end
