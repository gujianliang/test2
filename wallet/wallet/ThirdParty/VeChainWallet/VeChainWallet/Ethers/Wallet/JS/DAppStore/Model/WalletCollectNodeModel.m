//
//  WalletCollectNodeModel.m
//  VeWallet
//
//  Created by 曾新 on 2018/10/9.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletCollectNodeModel.h"

@implementation WalletCollectNodeModel

+(NSDictionary *)modelCustomPropertyMapper
{
    return @{@"pdescription":@"description"};
}

@end

@implementation WalletCollectNodeListModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"catalogs":[WalletCollectNodeModel class]};
}

@end

